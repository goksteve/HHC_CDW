create table ref_diagnoses
(
  coding_scheme,
  code,
  description,
  constraint ref_diagnoses_pk primary key(coding_scheme, code)
) organization index compress overflow
partition by list(coding_scheme)
(
  partition icd10 values ('ICD-10-CM'),
  partition icd9 values ('ICD-9')
)
as select
  coding_scheme,
  code,
  min(description) keep(dense_rank first order by cnt desc) description 
from
(
  select coding_scheme, code, description, sum(cnt) cnt
  from stg_icd_codes
  group by coding_scheme, code, description
)
group by coding_scheme, code; 
