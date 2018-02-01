CREATE OR REPLACE VIEW v_pqi90_8_detail_cdw AS
SELECT
 -- 22-Jan-2018, OK: created
  CASE WHEN heart_failure_diagnoses IS NOT NULL THEN 1 END numerator_flag,
  report_period_start_dt,
  network,
  facility,
  last_name,
  first_name,
  dob,
  mrn,
  visit_number,
  admission_dt,
  discharge_dt,
  CASE WHEN heart_failure_diagnoses LIKE '%--%' THEN '"'||heart_failure_diagnoses||'"' ELSE heart_failure_diagnoses END heart_failure_diagnoses,
  fin_class,
  payer_type,
  payer_name,
  prim_care_provider,
  attending_provider
FROM dsrip_report_pqi90_78 rpt
WHERE report_period_start_dt = NVL(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER'), (SELECT MAX(report_period_start_dt) FROM dsrip_report_pqi90_78)) 
ORDER BY last_name, first_name, discharge_dt;
