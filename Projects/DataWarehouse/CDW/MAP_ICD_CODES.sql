alter session force parallel dml;
alter session enable parallel ddl;

exec dbm.drop_tables('');

create table stg_icd10_codes parallel 16 as
select code, description, count(1) cnt
from problem_cmv
where coding_scheme = 10
group by code, description;

create table map_patient_icd_codes parallel 16 as
select *
from problem_cmv
pivot
(
  max(code) as code,
  max(description) as description
  for coding_scheme_id in (5 as icd9, 10 as icd10)
); 

ALTER TABLE map_patient_icd_codes ADD CONSTRAINT map_patient_icd_codes_pk
PRIMARY KEY(network, patient_id, problem_number) USING INDEX
(
  CREATE UNIQUE INDEX map_patient_icd_codes_pk
  ON map_patient_icd_codes(network, patient_id, problem_number)
  PARALLEL 16 COMPRESS
);

create index idx_map_patient_icd10 on map_patient_icd_codes(icd10_code) parallel 16;

select * from map_patient_icd_codes
where icd10_code >= 'A03'
and icd10_code < 'A04';

select * from problem_cmv
where network = 'NBX'
AND patient_id = 35681;

