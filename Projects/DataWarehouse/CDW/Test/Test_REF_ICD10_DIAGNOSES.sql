select q.class_level, q.icd10_code, q.diagnosys, q.parent_code, p.diagnosys parent_diagnosys
from
(
  select t.*, count(1) over(partition by icd10_code) cnt
  from ref_icd10_diagnoses t
) q
join ref_icd10_diagnoses p on p.class_level = q.parent_level and p.icd10_code = q.parent_code
where q.cnt > 1
order by q.icd10_code, q.class_level, q.parent_code;

select * from ref_icd10_diagnoses where icd10_code = 'S21';