CREATE OR REPLACE VIEW v_fact_visits AS
SELECT
  vi.network,
  vi.visit_id,
  p.patient_key,
  f.facility_key,
  d1.first_department_key,
  d2.last_department_key,
  pr1.provider_key attending_provider_key,
  pr2.provider_key resident_provider_key,
  pr3.provider_key admitting_provider_key,
  pr4.provider_key visit_emp_provider_key,
  vi.admission_date_time AS admission_dt,
  patient_age_at_admission,
  discharge_dt,
  visit_number,
  initial_visit_type_id,
  final_visit_type_id,
  visit_status_id,
  visit_activation_time,
  discharge_type_key,
  financial_class_id,
  physician_service_id,
  first_payer_key,
  source,
  load_date,
  loaded_by,
  'QCPR' source
FROM
(
  SELECT
    v.network, v.visit_id, v.visit_number, v.patient_id, v.facility_id,
    vs.admitting_emp_provider_id, vs.emp_provider_id,
    vl.location_id,
    LAST_VALUE(vl.location_id) OVER
    (
      PARTITION BY v.network, v.visit_id ORDER BY vl.visit_segment_number DESC, vl.location_id DESC
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) last_loc_id,
    ROW_NUMBER() OVER(PARTITION BY v.network, v.visit_id ORDER BY vl.visit_segment_number, vl.location_id) loc_rnum
  FROM visit v
  LEFT JOIN visit_segment vs
    ON vs.network = v.network AND vs.visit_id = v.visit_id AND vs.visit_segment_number = 1
  LEFT JOIN visit_segment_visit_location vl
    ON vl.network = v.network AND vl.visit_id = v.visit_id
) vi
JOIN dim_patients p
  ON p.network = vi.network AND p.patient_id = vi.patient_id
JOIN dim_hc_facilities f
  ON f.network = vi.network AND f.facility_id = vi.facility_id
LEFT JOIN dim_hc_departments d1
  ON d1.network = vi.network AND d1.location_id = vi.location_id 
LEFT JOIN dim_hc_departments d2
  ON d2.network = vi.network AND d2.location_id = vi.last_loc_id
LEFT JOIN dim_providers p1 
WHERE vi.loc_rnum = 1;
  
LEFT JOIN facility f1 ON f1.facility_id =ivst.facility_id AND f1.network=ivst.network
LEFT JOIN facility f2 ON f2.facility_id=v.facility_id AND f2.network=v.network
LEFT JOIN dim_hc_facilities fclty1 ON fclty1.facility_name=f1.name
LEFT JOIN dim_hc_facilities fclty2 ON fclty2.facility_name=f2.name
JOIN dim_patients ptnt ON ptnt.patient_id=v.patient_id AND ptnt.network=v.network AND current_flag=1
LEFT JOIN dim_providers prvdr1 ON prvdr1.provider_id=v.attending_emp_provider_id AND prvdr1.network=v.network
LEFT JOIN dim_providers prvdr2 ON prvdr2.provider_id=v.resident_emp_provider_id AND prvdr2.network=v.network
--JOIN dim_providers prvdr1 ON prvdr3.provider_id=v.attending_emp_provider_id AND prvdr3.network=v.network
--JOIN dim_providers prvdr1 ON prvdr4.provider_id=v.attending_emp_provider_id AND prvdr4.network=v.network
LEFT JOIN visit_segment_payer vsp ON vsp.visit_id=v.visit_id AND vsp.network=v.network AND vsp.visit_segment_number=1 AND payer_number=1
LEFT JOIN dim_payers dp on dp.payer_id=vsp.payer_id AND dp.network=vsp.network
WHERE v.visit_id=20792125 and v.network='CBN';
