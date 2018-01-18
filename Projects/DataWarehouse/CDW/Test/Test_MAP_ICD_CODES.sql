select coding_scheme, count(1) cnt -- 10097, 21025
from stg_icd_codes
group by coding_scheme;

select count(1) from stg_map_icd_codes;

select *
from
(
  select icd10_code, icd9_code, cnt,
  count(1) over(partition by icd10_code) icd10_dup_cnt, 
  count(1) over(partition by icd9_code) icd9_dup_cnt 
  from stg_map_icd_codes
)
where icd10_dup_cnt > 1 and icd9_dup_cnt > 1
order by 1, 2;
-- DUP_CNT: ICD10 - 4,154, ICD9 - 15,107

select * from stg_icd_codes
where code like 'S62%'
order by 1, 2;
