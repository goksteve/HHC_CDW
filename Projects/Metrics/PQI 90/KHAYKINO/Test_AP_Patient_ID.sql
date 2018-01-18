alter session set current_schema = ud_master;

select --+ parallel(4)
  flag, count(1) cnt
from
(
  select 
    pr.patient_id, pr.problem_number,
    case
      when p.collapsed_into_patient_id is null then 'REGULAR'
      else 'COLLAPSED'
    end flag  
  from problem pr
  join patient p on p.patient_id = pr.patient_id
)
group by rollup(flag) order by flag nulls last;
-- ~ 1.5% of Problems are for "Collapsed" Patients

with det as
(
  select distinct
    v.visit_id, v.patient_id visit_patient, vp.collapsed_into_patient_id collapsed_visit_patient,
    ap.patient_id problem_patient, pp.collapsed_into_patient_id collapsed_problem_patient,
    case
      when ap.patient_id = vp.collapsed_into_patient_id then 'Collapse into AP Patient'
      when v.patient_id = pp.collapsed_into_patient_id then 'Collapse into Visit Patient'
      else 'Mismatch'
    end flag
  from visit v
  join patient vp on vp.patient_id = v.patient_id
  join active_problem ap on ap.visit_id = v.visit_id
  join patient pp on pp.patient_id = ap.patient_id
  where ap.patient_id <> v.patient_id
)
select --+ parallel(4)
--  * from det where flag = 'Mismatch'
  flag, count(1) cnt from det group by flag
;
/*
FLAG                            CNT
----------------------------  -------
Collapse into AP Patient	          9
Collapse into Visit Patient	   48,462
Mismatch	                        991
*/