whenever sqlerror exit 1
alter session force parallel dml;
alter session force parallel ddl;

exec dbm.drop_tables('STG_ICD_CODES,STG_MAP_ICD_CODES,TST_PROBLEM_CMV');

set timi on

prompt Creating table STG_ICD_CODES ... 
create table stg_icd_codes
(
  coding_scheme, code, description, cnt,
  constraint stg_icd_codes_pk primary key(coding_scheme, code)
) organization index compress parallel 4
as select
  coding_scheme, code,
  min(description) keep(dense_rank first order by cnt desc) description,
  max(cnt) cnt
from
(
  select 
    DECODE(coding_scheme_id, 5, 'ICD-9', 'ICD-10-CM') coding_scheme, code,
    description,
    count(1) cnt
  from ud_master.problem_cmv
  where coding_scheme_id in (5, 10)
  group by coding_scheme_id, code, description
)
group by coding_scheme, code;

prompt Creating table STG_MAP_ICD_CODES ... 
create table stg_map_icd_codes
(
  icd10_code, icd9_code, cnt,
  constraint stg_map_icd_codes_pk primary key
  (
    icd10_code, icd9_code
  )
) organization index compress parallel 4 as
select
  icd10_code, icd9_code, count(1) cnt
from
(
  select patient_id, problem_number, coding_scheme_id, code
  from ud_master.problem_cmv
)
pivot
(
  max(code) as code
  for coding_scheme_id in (5 as icd9, 10 as icd10)
)
where icd10_code is not null and icd9_code is not null
group by icd10_code, icd9_code;

prompt Creating table TST_PROBLEM_CMV ...
create table tst_problem_cmv parallel 4 as
select
  year_dt,
  count(1) cnt,
  count(case when icd9_code is null then 1 end) icd9_nulls,
  count(case when icd10_code is null then 1 end) icd10_nulls
from
(
  select trunc(pr.onset_date, 'YEAR') year_dt, cmv.patient_id, cmv.problem_number, cmv.coding_scheme_id, cmv.code
  from ud_master.problem pr 
  join ud_master.problem_cmv cmv
  on cmv.patient_id = pr.patient_id and cmv.problem_number = pr.problem_number 
  where pr.onset_date >= date '2008-01-01' and cmv.coding_scheme_id in (5, 10)
) 
pivot
(
  max(code) as code
  for coding_scheme_id in (5 as icd9, 10 as icd10)
)
group by year_dt;

exit