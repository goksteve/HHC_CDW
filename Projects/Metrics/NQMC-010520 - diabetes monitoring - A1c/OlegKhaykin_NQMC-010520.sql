set arraysize 1000
set copycommit 1000
set timi on

alter session enable parallel dml;
alter session enable parallel ddl;
-- =============================================================================
-- Preparing reference data:

-- Create list of Medicaid patients in 2016 (i.e. those for who Medicaid paid in 2016):
drop table tst_mdcd_ptnt_2016 purge;

create table tst_mdcd_ptnt_2016 parallel 2 compress basic as 
select distinct v.patient_id, v.facility_id
from ud_master.visit v
join ud_master.visit_segment_payer vsp on vsp.visit_id = v.visit_id 
cross join v$database db 
join goreliks1.payer_mapping pm
  on pm.network = substr(db.name, 1, 3)
 and pm.payer_id = vsp.payer_id
where v.admission_date_time between timestamp '2016-01-01 00:00:00' and timestamp '2016-12-31 23:59:59'
and pm.payer_group = 'Medicaid'; 

exec dbms_stats.gather_table_stats('khaykino','tst_mdcd_ptnt_2016');

alter table tst_mdcd_ptnt_2016 noparallel;

select count(1) from tst_mdcd_ptnt_2016;
-- CBN:  88,742
-- GP1: 158,558
-- GP2:  56,534
-- NBN:  72,654
-- NBX:  74,500
-- QHN:  48,408
-- SBN:  38,515
-- SMN:  82,575

-- Create a list of prescriptions given to Medicaid patients in 2015-2016:
drop table tst_mdcd_prscr_2015_2016 purge;

create table tst_mdcd_prscr_2015_2016 
(
  patient_id not null,
  order_time not null,
  procedure_name,
  derived_product_name
) compress basic parallel 2
partition by range (order_time) interval(interval '1' year)
(
  partition old_data values less than (date '2015-01-01')
) as
select pd.patient_id, pd.order_time, pd.procedure_name, pd.derived_product_name
from tst_mdcd_ptnt_2016 p
cross join v$database db
join goreliks1.prescription_detail_dimension pd
  on pd.network = substr(db.name, 1, 3)
 and pd.patient_id = p.patient_id
 and pd.order_time between timestamp '2015-01-01 00:00:00' and timestamp '2016-12-31 23:59:59';

create index idx1_tst_mdcd_prscr_2015_2016 on tst_mdcd_prscr_2015_2016(patient_id) local;

exec dbms_stats.gather_table_stats('khaykino','tst_mdcd_prscr_2015_2016');

alter table tst_mdcd_prscr_2015_2016 noparallel;

select count(1) cnt from tst_mdcd_prscr_2015_2016;
-- CBN: 1,428,574
-- GP1: 3,410,738
-- GP2: 1,034,122
-- NBN: 1,513,133
-- NBX: 1,474,319
-- QHN:   828,009
-- SBN:   826,039
-- SMN: 1,776,371

-- Create list of Medicaid Patient diagnoses valid in 2016:
drop table tst_mdcd_diag_2016 purge;

create table tst_mdcd_diag_2016 compress basic parallel 2 as
select distinct
  pd.patient_id,
  'ICD'||pd.diag_coding_scheme diag_coding_scheme,
  pd.diag_code,
  pd.diag_description,
  nvl(pd.onset_date, pd.start_date) start_date,
  pd.stop_date
from tst_mdcd_ptnt_2016 p
cross join v$database db
join goreliks1.patient_diag_dimension pd
  on pd.network = substr(db.name, 1, 3)
 and pd.patient_id = p.patient_id
 and
 (
   nvl(pd.onset_date, pd.start_date) < date '2017-01-01'
   and nvl(pd.stop_date, sysdate) >= date '2016-01-01'
 );

create index idx1_tst_mdcd_diag_2016 on tst_mdcd_diag_2016(patient_id);

exec dbms_stats.gather_table_stats('khaykino','tst_mdcd_diag_2016');

alter table tst_mdcd_diag_2016 noparallel;

select count(1) from tst_mdcd_diag_2016;
-- CBN: 2,123,102
-- GP1: 2,947,892
-- GP2: 1,211,170
-- NBN: 1,770,291
-- NBX: 1,928,314
-- QHN: 1,349,842
-- SBN: 1,166,725
-- SMN: 1,813,813

-- =============================================================================
-- Calculating the measure:
-- Denominator:
drop table nqmc_010537_denominator purge;

create table nqmc_010537_denominator parallel 2 as
select pt.patient_id, pt.facility_id
from tst_mdcd_ptnt_2016 pt -- begin with taking all 2016 Medicaid Patients
join
(
  select --+ materialize 
    patient_id -- take only real people who were 18 to 64 years old as of 12/31/16
  from ud_master.patient p
  where p.birthdate between date '1952-01-01' and date '1998-12-31'
  and lower(p.sex) <> 'unknown'
  and p.birthdate is not null
  and lower(p.name) not like 'test,%'
  and lower(p.name) not like 'testing,%'
  and lower(p.name) not like '%,test'
  and lower(p.name) not like 'testggg,%'
  and lower(p.name) not like '%,test%ccd'
  and lower(p.name) not like 'test%ccd,%'
  and lower(p.name) <> 'emergency,testone'
  and lower(p.name) <> 'testtwo,testtwo'
 intersect
  select patient_id -- take only those who were prescribed Antipsychotic medications in 2016
  from tst_mdcd_prscr_2015_2016 pr 
  join meta_conditions lkp
    on lkp.criterion_id = 34 -- Antipsychotic medications
   and pr.order_time between timestamp '2016-01-01 00:00:00' and timestamp '2016-12-31 23:59:59'
   and
   (
     lower(pr.procedure_name) like lkp.value
     or lower(pr.derived_product_name) like lkp.value
   )
 minus
  select d.patient_id -- exclude those who had diabetes in 2016
  from tst_mdcd_diag_2016 d
  join meta_conditions lkp
    on lkp.criterion_id = 6 -- 'DIAGNOSIS:DIABETES' 
   and lkp.qualifier = d.diag_coding_scheme and lkp.value = d.diag_code
 minus
  select pr.patient_id -- exclude those who was prescribed diabetes medications in 2015-2016
  from tst_mdcd_prscr_2015_2016 pr
  join meta_conditions lkp 
    on lkp.criterion_id = 33 -- 'MEDICATIONS:DIABETES'
   and
   (
     lower(pr.procedure_name) like lkp.value
     or lower(pr.derived_product_name) like lkp.value
   )
) q on q.patient_id = pt.patient_id;

exec dbms_stats.gather_table_stats('khaykino','nqmc_010537_denominator');

alter table nqmc_010537_denominator noparallel;

select count(1) from nqmc_010537_denominator;
-- CBN: 3,470
-- GP1: 4,667
-- GP2: 1,941
-- NBN: 2,376
-- NBX: 1,801
-- QHN: 1,760
-- SBN: 1,026
-- SMN: 2,527

-- Visits:
drop table nqmc_010537_visits purge;

create table nqmc_010537_visits parallel 2 compress basic as
select
  2016 as reporting_year, 
  db.network, 
  q.facility_id,
  NVL(f.name, 'N/A') facility_name,
  q.patient_id,
  psn.secondary_number as med_rec_number, 
  q.visit_id,
  q.visit_number,
  q.admission_date_time, 
  q.discharge_date_time,
  q.diagnoses
from
(
  select
    v.facility_id,
    v.patient_id,
    v.visit_id,
    NVL(v.visit_number, 'N/A') visit_number,
    v.admission_date_time,
    v.discharge_date_time,
    rtrim(listagg(vs.diagnosis || nvl2(vs.diagnosis, '|', null)) within group(order by vs.visit_segment_number), '|') diagnoses
  from nqmc_010537_denominator dnm
  join ud_master.visit v
    on v.patient_id = dnm.patient_id
   and v.admission_date_time >= date '2016-01-01' 
   and v.admission_date_time < date '2016-12-31'
   and v.visit_status_id not in (8,9,10,11) -- remove cancelled, closed cancelled, no show, closed no show
   and v.visit_type_id not in (8,5,7,-1) -- remove lifecare, refferal, historical, unknown
  join ud_master.visit_segment vs on vs.visit_id = v.visit_id
  group by v.facility_id, v.patient_id, v.visit_id, v.visit_number, v.admission_date_time, v.discharge_date_time
) q
cross join
(
  select substr(name, 1, 3) network
  from v$database
) db
left join ud_master.facility f
 on f.facility_id = q.facility_id
left join ud_master.patient_secondary_number psn
  on psn.patient_id = q.patient_id
 and psn.secondary_nbr_type_id =
  case
   when db.network = 'GP1' and q.facility_id = 1 then 13
   when db.network = 'GP1' and q.facility_id in (2, 4) then 11
   when db.network = 'GP1' and q.facility_id = 3 then 12
   when db.network = 'CBN' and q.facility_id = 4 then 12
   when db.network = 'CBN' and q.facility_id = 5 then 13
   when db.network = 'NBN' and q.facility_id = 2 then 9
   when db.network = 'NBX' and q.facility_id = 2 then 11
   when db.network = 'QHN' and q.facility_id = 2 then 11
   when db.network = 'SBN' and q.facility_id = 1 then 11
   when db.network = 'SMN' and q.facility_id = 2 then 11
   when db.network = 'SMN' and q.facility_id = 7 then 13
  end
 and psn.secondary_nbr_id = 1;

exec dbms_stats.gather_table_stats('khaykino','nqmc_010537_visits');

alter table nqmc_010537_visits noparallel;

select count(1) from nqmc_010537_visits;
-- CBN: 56,288
-- GP1: 55,971
-- GP2: 22,851
-- NBN: 27,538
-- NBX: 22,895
-- QHN: 12,634
-- SBN: 19,467
-- SMN: 41,322

-- Results:
drop table nqmc_010537_results purge;

-- For Non-GP1 networks:
create table nqmc_010537_results parallel 2 compress basic as
select --+ index(r)
  v.reporting_year, 
  v.network, 
  v.facility_id,
  v.facility_name,
  v.patient_id,
  v.med_rec_number,
  v.visit_id,
  e.date_time as event_date_time,
  pr.name as proc_name,
  rf.name as data_element_name,
  r.value as data_element_value
from nqmc_010537_visits v
join meta_conditions lkp
  on lkp.network = v.network
 and lkp.criterion_id = 4 -- A1C tests
join ud_master.result r
  on r.visit_id = v.visit_id
 and r.data_element_id = lkp.value
join ud_master.proc_event pe
  on pe.visit_id = r.visit_id
 and pe.event_id = r.event_id 
join ud_master.event e
  on e.visit_id = pe.visit_id
 and e.event_id = pe.event_id
join ud_master.proc pr
  on pr.proc_id = pe.proc_id
join ud_master.result_field rf
  on rf.data_element_id = r.data_element_id;

-- For GP1:
create table nqmc_010537_results compress basic parallel 2 as
SELECT --+ index(r ie_deid_result)
  v.reporting_year,
  v.network,
  v.facility_id,
  v.facility_name,
  v.patient_id,
  v.med_rec_number,
  v.visit_id,
  e.date_time AS event_date_time,
  pr.proc_id,
  pr.name AS proc_name,
  rf.data_element_id,
  rf.name AS data_element_name,
  r.VALUE AS data_element_value
FROM ud_master.result_field rf
JOIN ud_master.result r
  ON r.data_element_id = rf.data_element_id 
JOIN nqmc_010537_visits v
  ON v.visit_id = r.visit_id
JOIN ud_master.proc_event pe
  ON pe.visit_id = r.visit_id AND pe.event_id = r.event_id
JOIN ud_master.proc pr
  ON pr.proc_id = pe.proc_id AND pr.name NOT LIKE '%REVIEW A1C/FINGERSTICK GLU%'
JOIN ud_master.event e
  ON e.visit_id = pe.visit_id AND e.event_id = pe.event_id
WHERE UPPER (rf.name) LIKE '%A1C%'
  AND UPPER (rf.name) NOT LIKE '%A1C (R)%'
  AND UPPER (rf.name) NOT LIKE '%A1C%NEVER%USED%'
  AND UPPER (rf.name) NOT LIKE '%A1C%ORDER%'
  AND UPPER (rf.name) NOT LIKE '%CURRENT HBA1C%'
  AND UPPER (rf.name) NOT LIKE '%EQUIVALENT HEMOGLOBIN A1C%'
  AND UPPER (rf.name) NOT LIKE '%GLYCATED A1C HEMOGLOBIN%'
  AND UPPER (rf.name) NOT LIKE '%GLYCOSYLATED HBG (HGB A1C) TWICE A YEAR%'
  AND UPPER (rf.name) NOT LIKE '%HGA1C-HIS%'
  AND UPPER (rf.name) NOT LIKE '%HGB A1C COMMENT%'
  AND UPPER (rf.name) NOT LIKE '%HGBA1C%TRIMESTER%'
  AND UPPER (rf.name) NOT LIKE '%LAST HEMOGLOBIN A1C%'
  AND UPPER (rf.name) NOT LIKE '%LAST%A1C%'
  AND UPPER (rf.name) NOT LIKE '%MOST RECENT HGB A1C%'
  AND UPPER (rf.name) NOT LIKE '%ORDER%A1C%'
  AND UPPER (rf.name) NOT LIKE '%REVIEW A1C/FINGERSTICK GLU%'
  AND UPPER (rf.name) NOT LIKE '%REVIEW GLU/A1C,HGB,FERR,IRON SATURATION%';
  
exec dbms_stats.gather_table_stats('khaykino','nqmc_010537_results');

alter table nqmc_010537_results noparallel;

select count(1) cnt from nqmc_010537_results;
-- CBN: 2,205
-- GP1: 6,996
-- GP2:   742
-- NBN: 1,751
-- NBX:   618
-- QHN:   168
-- SBN:   634
-- SMN: 1,547

-- Patients:
drop table nqmc_010537_patients purge;

create table nqmc_010537_patients as
select
  2016 reporting_year,
  substr(db.name, 1, 3) network,
  dnm.facility_id,
  f.name as facility_name,
  p.patient_id,
  p.medical_record_number,
  nvl2(q.patient_id, 'Y', 'N') in_numerator,
  p.name as patient_name,
  p.sex,
  NVL(r.name, 'Unknown') as race,
  p.birthdate,
  p.date_of_death,
  floor(months_between(date '2016-12-31', p.birthdate)/12) as effective_age,
  rtrim(p.street_address||' '||p.addr_string) address,
  p.city,
  p.state,
  p.mailing_code
from nqmc_010537_denominator dnm
cross join v$database db
join ud_master.facility f
  on f.facility_id = dnm.facility_id
join ud_master.patient p 
  on p.patient_id = dnm.patient_id
 and (p.date_of_death is null or p.date_of_death >= date '2017-01-01')
left join
(
  select distinct patient_id, facility_id
  from nqmc_010537_results
) q
on q.patient_id = dnm.patient_id and q.facility_id = dnm.facility_id
left join ud_master.race r on r.race_id = p.race_id;

exec dbms_stats.gather_table_stats('khaykino','nqmc_010537_patients');

select count(1) cnt from nqmc_010537_patients;
-- CBN: 3,466
-- GP1: 4,662
-- GP2: 1,940
-- NBN: 2,370
-- NBX: 1,800
-- QHN: 1,760
-- SBN: 1,022
-- SMN: 2,527

-- Prescriptions:
drop table nqmc_010537_prescriptions purge;

create table nqmc_010537_prescriptions compress basic as
select distinct
  p.reporting_year, 
  p.network, 
  p.patient_id,
  p.patient_name,
  pr.order_time prescription_time,
  pr.procedure_name medication,
  pr.derived_product_name,
  substr(mc.criterion_cd, instr(mc.criterion_cd, ':')+1) medication_type 
from nqmc_010537_patients p
join meta_conditions lkp on lkp.criterion_id in (33, 34) 
join tst_mdcd_prscr_2015_2016 pr
  on pr.patient_id = p.patient_id
 and pr.order_time between date '2016-01-01' and date '2017-01-01'
 and 
 (
   lower(pr.procedure_name) like lkp.value
   or lower(pr.derived_product_name) like lkp.value
 )
join meta_criteria mc on mc.criterion_id = lkp.criterion_id;

exec dbms_stats.gather_table_stats('khaykino','nqmc_010537_prescriptions');

select count(1) cnt from nqmc_010537_prescriptions;
-- CBN: 15,282
-- GP1: 14,910
-- GP2:  6,949
-- NBN:  8,540  
-- NBX:  4,943
-- QHN:  4,408
-- SBN:  3,784
-- SMN: 11,020

drop table nqmc_measures_denom_numer purge;

create table nqmc_measures_denom_numer as
select
  'NQMC_010537' nqmc_id,
  'Diabetes screening for people with schizophrenia or bipolar disorder' nqca_description,
  to_date(reporting_year||'-01-01', 'YYYY-MM-DD') as measure_period_start,
  'Y' period_type,
  network,
  facility_id,
  facility_name,
  'Medicaid members age 18 to 64 years as of December 31 of the measurement year with schizophrenia or bipolar disorder who were dispensed an antipsychotic medication' denominator_desc,
  'A glucose test or a hemoglobin A1c (HbA1c) test performed during the measurement year' numerator_desc,
  count(1) denominator,
  sum(case when in_numerator = 'Y' then 1 else 0 end) numerator,
  sum(case when in_numerator = 'Y' then 1 else 0 end)/count(1) ratio
from nqmc_010537_patients
group by reporting_year, network, facility_id, facility_name;

exec dbms_stats.gather_table_stats('khaykino','nqmc_measures_denom_numer');

select * from nqmc_measures_denom_numer;
