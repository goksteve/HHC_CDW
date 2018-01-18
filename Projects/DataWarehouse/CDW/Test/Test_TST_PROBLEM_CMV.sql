select *
from
(
  select * 
  from
  (
    select
      t.network,
      to_char(year_dt, 'YYYY') year,
      cnt,
      icd9_nulls,
      icd10_nulls,
      round(icd9_nulls/cnt, 2) icd9_null_pct,
      round(icd10_nulls/cnt, 2) icd10_null_pct
    from tst_problem_cmv t
  )
  unpivot 
  (
    num_rows for metric in 
    (
      cnt as 'Total',
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