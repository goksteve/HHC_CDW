alter session enable parallel dml;
alter session enable parallel ddl;

CREATE TABLE map_icd_codes PARALLEL 16 AS
select *
from problem_cmv
pivot
(
  max(code) as code,
  max(description) as description
  for coding_scheme_id in (5 as icd9, 10 as icd10)
); 
