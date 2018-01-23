select count(1) cnt, count(distinct icd10_code) icd10_uniq, count(distinct icd9_code) icd9_uniq
from map_diagnose_codes;
-- 36999	30640	11834

select coding_scheme, count(1) 
from ref_diagnoses
group by coding_scheme;
/*
CODING_SCHEME	COUNT(1)
------------- -------
ICD-9	          13012
ICD-10	        33463
*/

alter session force parallel dml;
alter session force parallel ddl;

drop table tst_ok_map_codes purge;

create table tst_ok_map_codes parallel 16 as
SELECT
  icd10_code, icd9_code, count(1) cnt
FROM
(
  select network, patient_id, problem_number, coding_scheme_id, code
  from problem_cmv
)
PIVOT
(
  MAX(code) as code
  FOR coding_scheme_id IN (5 AS icd9, 10 AS icd10)
) pv
group by icd10_code, icd9_code; 

select
   count(1) cnt,
   sum(cnt) total,
   count(icd10_code) icd10_cnt,
   count(distinct icd10_code) icd10_uniq,
   count(icd9_code) icd9_cnt,
   count(distinct icd9_code) icd9_uniq,
   count(case when icd10_code is not null and icd9_code is not null then 1 end) map_cnt,
   sum(case when icd10_code is not null and icd9_code is not null then cnt end) map_sum
from tst_ok_map_codes;

select coding_scheme, count(1)
from ref_diagnoses
group by coding_scheme;
/*
CODING_SCHEME	COUNT(1)
------------- --------
ICD-10	        33463
ICD-9	          13012
*/

drop table tst_ok_problem_cmv purge;

create table tst_ok_problem_cmv parallel 16 compress basic as
select
  onset_year, network,
  count(1) problem_cnt,
  count(case when icd9_cnt = 0 then 1 end) icd9_nulls,
  count(case when icd10_cnt = 0 then 1 end) icd10_nulls
from
(
  select cmv.network, cmv.patient_id, cmv.problem_number, trunc(p.onset_date, 'YEAR') onset_year, cmv.coding_scheme_id
  from problem_cmv cmv
  join problem p on p.network = cmv.network and p.patient_id = cmv.patient_id and p.problem_number = cmv.problem_number
  where cmv.coding_scheme_id in (5, 10) and p.onset_date >= date '2008-01-01'
)
pivot
(
  count(1) cnt
  for coding_scheme_id in (5 as icd9, 10 as icd10)
)
group by onset_year, network;

select *
from
(
  select * 
  from
  (
    select
      t.network,
      to_char(onset_year, 'YYYY') year,
      problem_cnt,
      icd9_nulls,
      icd10_nulls,
      round(icd9_nulls/problem_cnt, 2) icd9_null_pct,
      round(icd10_nulls/problem_cnt, 2) icd10_null_pct
    from tst_ok_problem_cmv t
  )
  unpivot 
  (
    num_rows for metric in 
    (
      problem_cnt as 'Total',
      icd9_nulls as 'ICD-9 NULLs',
      icd9_null_pct as 'ICD-9 NULL %',
      icd10_nulls as 'ICD-10 NULLs',
      icd10_null_pct as 'ICD-10 NULL %'
    )
  )
)
pivot
(
  max(num_rows) for network in 
  (
    'CBN' as cbn,
    'GP1' as gp1,
    'GP2' as gp2,
    'NBN' as nbn,
    'NBX' as nbx,
    'QHN' as qhn,
    'SBN' as sbn,
    'SMN' as smn
  )
)
order by 1, 2 desc;

