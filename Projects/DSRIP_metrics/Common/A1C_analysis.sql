SELECT r.facility_id, r.facility_name, r.proc_id, r.proc_name, r.data_element_id, r.data_element_name, nvl2(pi.proc_id, 'Y', 'N') included, count(1) cntApostille
from nqmc_010537_results r
left join 
(
  select to_number(value) proc_id
  from meta_conditions
  where criterion_id = 4 and network = 'GP1' and condition_type_cd = 'PI' and logical_operator = 'OR' and comparison_operator = '=' and hint_ind = 'Y'
) pi on pi.proc_id = r.proc_id 
where r.proc_id not in
(
  select to_number(value)
  from meta_conditions
  where criterion_id = 4 and network = 'GP1' and condition_type_cd = 'PI' and logical_operator = 'AND' and comparison_operator = '<>' and hint_ind = 'N'
)
group by r.facility_id, r.facility_name, r.proc_id, r.proc_name, r.data_element_id, r.data_element_name, nvl2(pi.proc_id, 'Y', 'N')
order by r.proc_id, r.proc_name, r.data_element_id, r.data_element_name, included, r.facility_id, r.facility_name
;

create table nqmc_010537_result_totals compress basic parallel 2 as
SELECT
  v.facility_id,
  v.facility_name,
  pr.proc_id,
  pr.name AS proc_name,
  rf.data_element_id,
  rf.name AS data_element_name,
  count(1) cnt
FROM ud_master.result_field rf
JOIN ud_master.result r
  ON r.data_element_id = rf.data_element_id 
JOIN nqmc_010537_visits v
  ON v.visit_id = r.visit_id
JOIN ud_master.proc_event pe
  ON pe.visit_id = r.visit_id AND pe.event_id = r.event_id
JOIN ud_master.proc pr
  ON pr.proc_id = pe.proc_id
group by
  v.facility_id,
  v.facility_name,
  pr.proc_id,
  pr.name,
  rf.data_element_id,
  rf.name;
