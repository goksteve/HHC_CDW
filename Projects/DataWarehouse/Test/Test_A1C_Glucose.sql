-- Q#1:
with det as
(
  SELECT 
    r.network, 
    f.facility_name facility,
    p.patient_id, 
    p.name, p.birthdate,
    r.visit_id, r.visit_number, r.visit_type_id, r.visit_type, 
    r.admission_dt, r.discharge_dt, 
    r.test_type_id, r.event_id, r.result_dt, 
    r.data_element_id, r.data_element_name, r.result_value
  from fact_test_results r
  join dim_medical_facilities f on f.network = r.network and f.facility_id = r.facility_id
  join dim_patient_records p on p.network = r.network and p.patient_id = r.patient_id and p.current_flag = 1
  where r.test_type_id in (4, 23)
)
--select /*+ parallel(16) */ * from det order by network, facility, name, birthdate, visit_id, event_id;
select /*+ parallel(16) */ * from
(
  select
    decode(grouping(network), 1, 'Total', network) network,
    decode(grouping(test_type_id), 1, 0, test_type_id) test_type_id,
    trunc(result_dt, 'MONTH') mon,
    count(1) cnt
  from det
  group by cube(network, test_type_id, trunc(result_dt, 'MONTH')) 
)
pivot
(
  max(cnt)
  for (network, test_type_id) in 
  (
    ('CBN', 4) cbn_a1c, 
    ('CBN', 23) cbn_glucose, 
    ('GP1', 4) gp1_a1c, 
    ('GP1', 23) gp1_glucose, 
    ('GP2', 4) gp2_a1c, 
    ('GP2', 23) gp2_glucose, 
    ('NBN', 4) nbn_a1c, 
    ('NBN', 23) nbn_glucose, 
    ('NBX', 4) nbx_a1c, 
    ('NBX', 23) nbx_glucose, 
    ('SMN', 4) smn_a1c,
    ('SMN', 23) smn_glucose,
    ('Total', 0) total
  )
)
order by mon nulls last;

-- Q#2:
select count(1) cnt from v_tr016_detail;

select * from v_tr016_detail
order by network, visit_id, result_dt
;

-- Q#3:
select * from v_tr016_summary;
