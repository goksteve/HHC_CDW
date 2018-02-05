exec dwm.refresh_data('MAP_DIAGNOSES_CODES');

insert into ref_diagnoses values('ICD-10', 'OK', 'Test'); 

select --+ parallel(32)
  *
from v_ref_diagnoses;

select * from problem_cmv
where coding_scheme_id = 10 and code in ('C40.82','V33.0xxD');