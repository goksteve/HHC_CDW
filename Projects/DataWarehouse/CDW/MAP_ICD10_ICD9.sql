create table map_icd10_icd9
(
   icd10_code constraint map_icd10_icd9 primary key,
   icd9_code not null
) organization index
as select
  icd10_code,
  min(icd9_code) keep(dense_rank first order by cnt desc) icd9_code
from
(
  select icd10_code, icd9_code, sum(cnt) cnt
  from stg_map_icd_codes
  group by icd10_code, icd9_code
)
group by icd10_code;