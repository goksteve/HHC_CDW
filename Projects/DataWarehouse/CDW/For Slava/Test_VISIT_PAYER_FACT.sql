WITH
  dis_tmp AS
  (
    SELECT DISTINCT
      sv.network,
      sv.visit_id,
      sv.visit_number,
      sv.visit_segment_number,
      sv.visit_type_id,
      vtype.name AS visit_type_name,
      sv.visit_status_id,
      vis.name AS visit_status_name,
      sv.visit_activation_time,
      sv.employer_id AS visit_employer_id,
      sv.patient_id,
      sv.patient_type_id,
      sv.facility_id,
      sv.last_location_id,
      sv.attending_emp_provider_id,
      sv.free_text_employer,
      sv.free_text_occupation,
      sv.occupation_id,
      sv.resident_emp_provider_id,
      sv.admitting_emp_provider_id,
      sv.emp_provider_id,
      sv.last_location AS visit_last_location,
      sv.diagnosis AS visit_diagnosis,
      sv.visit_service_type_id,
      vst.name AS visit_service_type_name,
      visit_source_id,
      visit_source_string,
      NVL(sv.admission_date_time, DATE '2099-01-01') AS admission_date_time,
      sv.discharge_date_time,
      sv.discharge_type_id,
      dis.name AS discharge_type_name,
      sv.financial_class_id,
      fc.name AS financial_class_name,
      sv.physician_service_id,
      sv.visit_subtype_id,
      ss.name AS visit_subtype_name,
      sv.payer_id,
      sv.payer_number,
      sv.payer_string,
      sv.pay_position,
      sv.plan_number,
      sv.relationship_id,
      ac.name AS relationship_desc
    FROM stg_visit_payer sv -- 115M
    LEFT JOIN care_provider_relationship ac
      ON ac.relationship_id = sv.relationship_id AND ac.network = sv.network
    LEFT JOIN visit_subtype ss
      ON sv.visit_subtype_id = ss.visit_subtype_id AND sv.visit_type_id = ss.visit_type_id AND sv.network = ss.network
    LEFT JOIN financial_class fc
      ON sv.financial_class_id = fc.financial_class_id AND sv.network = fc.network
    LEFT JOIN discharge_type dis
      ON sv.discharge_type_id = dis.discharge_type_id
     AND sv.visit_type_id = dis.visit_type_id
     AND sv.network = dis.network
    LEFT JOIN visit_service_type vst
      ON sv.visit_service_type_id = vst.visit_service_type_id
     AND sv.visit_type_id = vst.visit_type_id
     AND sv.facility_id = vst.facility_id
     AND sv.network = vst.network
    LEFT JOIN visit_status vis
      ON sv.visit_status_id = vis.visit_status_id AND sv.network = vis.network
    LEFT JOIN visit_type vtype ON sv.visit_type_id = vtype.visit_type_id AND sv.network = vtype.network
    WHERE sv.admission_date_time IS NOT NULL
  )
SELECT /*+ noPARALLEL */
  dis_tmp.network,
  fact_visit_key_seq.NEXTVAL AS visit_key,
  pat.patient_key,
  NVL(l.location_key, 999999999999) location_key,
  NVL(prov2.provider_key, 999999999999) AS attending_provider_key,
  NVL(prov3.provider_key, 999999999999) resident_provider_key,
  NVL(prov4.provider_key, 999999999999) admitting_provider_key,
  NVL(prov1.provider_key, 999999999999) visit_emp_provider_key,
  NVL(f.facility_key, 999999999999) facility_key,
  NVL(dt.datenum, 20660101) datenum,
  dis_tmp.visit_id,
  dis_tmp.visit_number,
  dis_tmp.visit_segment_number,
  dis_tmp.visit_type_id,
  dis_tmp.visit_type_name,
  dis_tmp.visit_status_id,
  dis_tmp.visit_status_name,
  dis_tmp.visit_activation_time,
  -- dis_tmp.patient_id,
  -- dis_tmp.patient_type_id,
  -- dis_tmp.facility_id,
  --  dis_tmp.last_location_id,
  --  dis_tmp.attending_emp_provider_id,
  dis_tmp.free_text_employer,
  dis_tmp.free_text_occupation,
  dis_tmp.occupation_id,
  -- dis_tmp.resident_emp_provider_id,
  -- dis_tmp.admitting_emp_provider_id,
  -- dis_tmp.emp_provider_id,
  dis_tmp.visit_employer_id,
  dis_tmp.visit_last_location,
  dis_tmp.visit_diagnosis,
  dis_tmp.visit_service_type_id,
  dis_tmp.visit_service_type_name,
  dis_tmp.visit_source_id,
  dis_tmp.visit_source_string,
  dis_tmp.admission_date_time,
  dis_tmp.discharge_date_time,
  dis_tmp.discharge_type_id,
  dis_tmp.discharge_type_name,
  dis_tmp.financial_class_id,
  dis_tmp.financial_class_name,
  dis_tmp.physician_service_id,
  dis_tmp.visit_subtype_id,
  dis_tmp.visit_subtype_name,
  dis_tmp.payer_id,
  dis_tmp.payer_number,
  dis_tmp.payer_string,
  dis_tmp.pay_position,
  dis_tmp.plan_number,
  dis_tmp.relationship_id,
  dis_tmp.relationship_desc
FROM dis_tmp
JOIN dim_patient pat
  ON pat.network = dis_tmp.network AND pat.patient_id = dis_tmp.patient_id AND pat.current_flag = 1
----- EMP_prov-------
LEFT JOIN dim_provider prov1
  ON dis_tmp.emp_provider_id = prov1.provider_id AND dis_tmp.network = prov1.network AND prov1.current_flag = 1
--- Attending ----
LEFT JOIN dim_provider prov2
  ON dis_tmp.attending_emp_provider_id = prov2.provider_id AND dis_tmp.network = prov2.network AND prov2.current_flag = 1
--- Resident ---
LEFT JOIN dim_provider prov3
  ON dis_tmp.resident_emp_provider_id = prov3.provider_id AND dis_tmp.network = prov3.network AND prov3.current_flag = 1
  -- Admitting ---
LEFT JOIN dim_provider prov4
  ON dis_tmp.admitting_emp_provider_id = prov4.provider_id AND dis_tmp.network = prov4.network AND prov4.current_flag = 1
LEFT JOIN dim_location l
  ON dis_tmp.last_location_id = l.location_id AND dis_tmp.network = l.network AND l.current_flag = 1
LEFT JOIN dim_facility f
  ON dis_tmp.facility_id = f.facility_id AND dis_tmp.network = f.network
LEFT JOIN dim_date_time dt
  ON TRUNC(dis_tmp.admission_date_time) = dt.days_in_date;
