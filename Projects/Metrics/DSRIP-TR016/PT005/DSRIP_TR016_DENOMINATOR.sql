

create table dsrip_tr016_denominator parallel 2 as
select patient_id 
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
select pr.patient_id -- take only those who were prescribed anti-psychotic medications in 2016
from meta_conditions lkp
join tst_prscr_2015_2016 pr 
  on pr.stop_dt > date '2016-01-01'
  and 
  (
    lower(pr.drug_name) like lkp.value
    or lower(pr.drug_description) like lkp.value
  )
where lkp.criterion_id = 34 -- Antipsychotic medications
minus
select patient_id -- exclude those who had diabetes in 2015
from tst_diabetic_patients
where start_dt < date '2016-01-01' and stop_dt > date '2015-12-31'
minus
select pr.patient_id -- exclude those who was prescribed diabetes medications in 2015
from meta_conditions lkp
join tst_prscr_2015_2016 partition(p_2015) pr
  on 
  (
    lower(pr.drug_name) like lkp.value
    or lower(pr.drug_description) like lkp.value
  )
where lkp.criterion_id = 33; -- 'MEDICATIONS:DIABETES'

select --+ parallel(8)
  count(1) cnt -- 68,749
from
(
  select -- index(pr)
    network, patient_id
  from tst_ok_prescriptions pr
  join tst_ok_drug_names dn on dn.drug_name = pr.drug_name and dn.drug_type = 'ANTIPSYCHOTIC'
 union
  select -- index(pr)
    network, patient_id
  from tst_ok_prescriptions pr
  join tst_ok_drug_descriptions dn on dn.drug_description = pr.drug_description and dn.drug_type = 'ANTIPSYCHOTIC'
);

select --+ parallel(8)
  count(1) cnt -- 68,749
from
(
  select --+ index_join(pr)
    distinct 
    network, patient_id
  from tst_ok_prescriptions pr
  left join tst_ok_drug_names dn on dn.drug_name = pr.drug_name
  left join tst_ok_drug_descriptions dd on dd.drug_description = pr.drug_description
  where dn.drug_type = 'ANTIPSYCHOTIC' or dd.drug_type = 'ANTIPSYCHOTIC'
);



SELECT --+ parallel(8)
  count(1) cnt -- 59,755
from
(
  select -- index(pr)
    network, patient_id
  from prescription_detail_dimension pr
  join tst_ok_drug_names dn on dn.drug_name = lower(pr.procedure_name) and dn.drug_type = 'ANTIPSYCHOTIC'
  where order_time >= DATE '2015-01-01'
 union
  select -- index(pr)
    network, patient_id
  from prescription_detail_dimension pr
  join tst_ok_drug_descriptions dn on dn.drug_description = lower(pr.derived_product_name) and dn.drug_type = 'ANTIPSYCHOTIC'
  where order_time >= DATE '2015-01-01'
);
