CREATE OR REPLACE VIEW v_pqi_7_detail_cdw AS
SELECT
  report_period_start_dt,
  network,
  last_name,
  first_name,
  dob,
  streetadr,
  apt_suite,
  city,
  state,
  zipcode,
  country,
  home_phone,
  day_phone,
  prim_care_provider,
  hospitalization_facility,
  mrn,
  visit_id,
  visit_number,
  admission_dt,
  discharge_dt,
  hypertension_code,
  fin_class,
  payer_group,
  payer
FROM dsrip_report_pqi_7_8_qmed rpt
WHERE report_period_start_dt = NVL(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER'), (SELECT MAX(report_period_start_dt) FROM dsrip_report_pqi_7_8_qmed)) 
ORDER BY last_name, first_name, discharge_dt;
