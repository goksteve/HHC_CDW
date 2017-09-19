create table dsrip_tr016_denominator parallel 2 as
select patient_id 
from ud_master.patient p
where p.birthdate between date '1952-01-01' and date '1998-12-31'
and lower(p.sex) <> 'unknown'
and p.birthdate is not null
and lower(p.name) not like 'test,%'
and lower(p.name) not like 'testing,%'
and lower(p.name) not like '%,test'
and lower(p.name) not like 'testggg,%'
and lower(p.name) not like '%,test%ccd'
and lower(p.name) not like 'test%ccd,%'
and lower(p.name) <> 'emergency,testone'
and lower(p.name) <> 'testtwo,testtwo'
intersect
select pr.patient_id -- take only those who were prescribed anti-psychotic medications in 2016
from meta_conditions lkp
join tst_prscr_2015_2016 pr 
  on pr.stop_dt > date '2016-01-01'
  and 
  (
    lower(pr.drug_name) like lkp.value
    or lower(pr.drug_description) like lkp.value
  )
where lkp.criterion_id = 34 -- Antipsychotic medications
minus
select patient_id -- exclude those who had diabetes in 2015
from tst_diabetic_patients
where start_dt < date '2016-01-01' and stop_dt > date '2015-12-31'
minus
select pr.patient_id -- exclude those who was prescribed diabetes medications in 2015
from meta_conditions lkp
join tst_prscr_2015_2016 partition(p_2015) pr
  on 
  (
    lower(pr.drug_name) like lkp.value
    or lower(pr.drug_description) like lkp.value
  )
where lkp.criterion_id = 33; -- 'MEDICATIONS:DIABETES'
