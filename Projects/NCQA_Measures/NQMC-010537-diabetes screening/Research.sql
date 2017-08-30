set timi on;
set sqlblanklines on;
alter session enable parallel dml;
alter session enable parallel ddl;

select * from ud_master.visit_type;

select * from goreliks1.dsrip_category_crt;
select * from goreliks1.dsrip_measure_desc;

update dsrip_spec_crt_lookup set crt_dtl = ltrim(crt_dtl)
where crt_dtl <> ltrim(crt_dtl);

select
  *
from dsrip_spec_crt_lookup
where 1=1
and category_id in ('MED')
and measure_id = 6
--and network = 'GP1'
--and include_ind = 'Y'
order by include_ind desc, category_id desc, crt_dtl;

select
  count(distinct v.visit_id) cnt,
  count(distinct vs.visit_id) vs_cnt,
  count(vs.visit_id) seg_cnt,
  count(vs.diagnosis) dig_cnt
from ud_master.visit v
left join ud_master.visit_segment vs on vs.visit_id = v.visit_id;
/*
       CNT     VS_CNT    SEG_CNT    DIG_CNT
---------- ---------- ---------- ----------
  18415363   18405019   18888771   13150226
*/  
select diagnosis
from ud_master.visit_segment
where diagnosis is not null
;

select sid, serial#, program, status 
from v$session
where username = 'KHAYKINO'
--and status = 'ACTIVE'
;

alter session enable parallel dml;
alter session enable parallel ddl;

create table tst_prescriptions parallel 4
as select 'PROCEDURE_NAME' col_name, procedure_name col_value
from goreliks1.prescription_detail
union
select 'DERIVED_PRODUCT_NAME', derived_product_name
from goreliks1.prescription_detail;

select col_name, count(1) cnt
from tst_prescriptions
group by col_name;

select trim(upper(col_value)) from tst_prescriptions --where col_name = 'PROCEDURE_NAME'
intersect -- only 6 entries intersected
select trim(upper(crt_dtl)) from goreliks1.dsrip_spec_crt_lookup where category_id = 'MED' and measure_id = 6;

select * from ud_master.visit_type;
select * from ud_master.visit_subtype;

select --+ parallel(4)
  diag, count(1) cnt
from
(
  select --+ parallel(8)
    ltrim
    (
      case when upper(vs.diagnosis) like '%SCHIZOPHRENIA%' then 'SCHIZOPHRENIA' end ||
      case when upper(vs.diagnosis) like '%BIPOLAR%' then '\BIPOLAR' end,
      '\' 
    ) diag
  from ud_master.visit v
  join tst_medicaid_patients_2016 p on p.patient_id = v.patient_id
  join ud_master.visit_segment vs on vs.visit_id = v.visit_id
  where v.admission_date_time between timestamp '2016-01-01 00:00:00' and timestamp '2016-12-31 23:59:59'
  and upper(vs.diagnosis) like '%SCHIZOPHRENIA%' or upper(vs.diagnosis) like '%BIPOLAR%'
)
group by diag;

drop table tst_payer_stat purge;

--create table tst_payer_stat parallel 4 as 
select * from det order by visit_id, visit_segment_number, payer_number;
select
  patient_id,
  count(distinct payer_id) payer_cnt,
  listagg
  (
    case when payer_group <> nvl(prev_payer_group, 'NULL') then '\'||payer_group end
  ) within group(order by visit_id) payers
from
(
  select
    patient_id,
    visit_id,
    admission_date_time,
    payer_id,
    payer_group,
    lag(payer_group) over(partition by patient_id order by visit_id) prev_payer_group
  from
  (
    select -- use_hash(vsp)
      v.patient_id,
      v.visit_id,
      v.admission_date_time,
      vsp.visit_segment_number,
      vsp.payer_number,
      vsp.payer_id,
      decode(pm.payer_group, 'Medicaid', 'Medicaid', 'Non-Medicaid') payer_group,
      rank() over(partition by vsp.visit_id order by decode(pm.payer_group , 'Medicaid', 0, 1), vsp.visit_segment_number, vsp.payer_number) rnk 
    from ud_master.visit v
    join ud_master.visit_segment_payer vsp on vsp.visit_id = v.visit_id 
    join goreliks1.payer_mapping pm on pm.network = 'GP1' and pm.payer_id = vsp.payer_id
    where v.admission_date_time between timestamp '2016-01-01 00:00:00' and timestamp '2016-12-31 23:59:59' 
    and patient_id = 1419632
  )
  where rnk = 1
)
group by patient_id 
having count(distinct payer_group) > 1;

select * from tst_payer_stat
order by length(payers) desc;

select
  count(1) cnt,
  count(distinct patient_id||'\'||secondary_nbr_type_id),
  count(distinct patient_id||'\'||secondary_nbr_id),
  count(distinct secondary_nbr_type_id||'\'||secondary_number)
from ud_master.patient_secondary_number;

select
  psn.secondary_nbr_type_id, psn.secondary_number,
  count(distinct patient_id),
  listagg(patient_id, ',') within group(order by secondary_nbr_id)
from ud_master.patient_secondary_number psn
group by secondary_nbr_type_id, secondary_number
having count(distinct patient_id) > 1;

select psn.*, p.name 
from ud_master.patient_secondary_number psn
join ud_master.patient p on p.patient_id = psn.patient_id 
where secondary_nbr_type_id = 17 and secondary_number = '880357';



