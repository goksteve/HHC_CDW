select r.coding_scheme, count(1) total_cnt, count(m.icd10_code) map_cnt
from ref_diagnoses r
left join map_icd10_icd9 m on m.icd10_code = r.code
where r.coding_scheme = 'ICD-10-CM'
group by r.coding_scheme
union all
select r.coding_scheme, count(1) total_cnt, count(m.icd10_code) map_cnt
from ref_diagnoses r
left join map_icd9_icd10 m on m.icd9_code = r.code
where r.coding_scheme = 'ICD-9'
group by r.coding_scheme;

select
  r.code r_code, r.description r_description,
  d.icd10_code, d.description icd10_description
from
(
  select r.code, r.description
  from ref_diagnoses r
  where r.coding_scheme = 'ICD-10-CM'
) r
full join ref_icd10_diagnoses d
  on d.icd10_code = r.code
where r.code is null or d.icd10_code is null
order by nvl(r.code, d.icd10_code);

select * from ref_diagnoses
where code in ('I10','I11.9','I12.9','I13.10')
or (description like 'Hypertensive%' and coding_scheme = 'ICD-10-CM')
order by code 
;

