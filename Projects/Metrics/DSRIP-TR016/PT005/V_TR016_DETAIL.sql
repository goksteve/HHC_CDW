CREATE OR REPLACE VIEW v_tr016_detail AS
SELECT
  report_period_start_dt,
  patient_gid,
  network,
  facility_id,
  facility_name,
  patient_id,
  patient_name,
  medical_record_number,
  birthdate,
  age,
  street_address,
  apt_suite,
  city,
  state,
  zip_code,
  medication,
  prim_care_provider,
  last_pcp_visit_dt,
  visit_id,
  visit_number,
  visit_type_id,
  visit_type,
  admission_dt,
  discharge_dt,
  payer_group,
  payer_id,
  payer_name,
  test_type_id,
  result_dt,
  data_element_name,
  result_value,
  NVL2(result_dt, 'Y', 'N') screened
FROM dsrip_report_tr016 t
WHERE report_period_start_dt = NVL
(
  SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER'),
  (SELECT MAX(report_period_start_dt) FROM dsrip_report_tr016)
)
ORDER BY patient_name;
