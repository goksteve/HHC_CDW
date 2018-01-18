create table map_icd9_icd10
(
   icd9_code constraint map_icd9_icd10 primary key,
   icd10_code not null
) organization index
as select
  icd9_code,
  min(icd10_code) keep(dense_rank first order by cnt desc) icd10_code
from
(
  select icd10_code, icd9_code, sum(cnt) cnt
  from stg_map_icd_codes
  group by icd10_code, icd9_code
)
group by icd9_code;