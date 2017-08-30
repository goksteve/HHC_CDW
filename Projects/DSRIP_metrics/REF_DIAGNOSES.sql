create table ref_diagnoses
(
  coding_scheme_id, code, description,
  constraint pk_ref_diagnoses_icd_codes primary key(coding_scheme_id, code) 
) organization index
as select coding_scheme_id, code, description
from
(
  select coding_scheme_id, code, description, rank() over(partition by coding_scheme_id, code order by description) rnk
  from
  (
    select distinct coding_scheme_id, code, description 
    from ud_master.problem_cmv
  )
)
where rnk = 1;

grant select on ref_diagnoses to public;