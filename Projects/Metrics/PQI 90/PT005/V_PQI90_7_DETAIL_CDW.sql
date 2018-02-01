CREATE OR REPLACE VIEW v_pqi90_7_detail_cdw AS
SELECT
 -- 22-Jan-2018, OK: created
  CASE WHEN hypertension_diagnoses IS NOT NULL AND exclusion_diagnoses IS NULL THEN 1 END numerator_flag, 
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
  CASE WHEN hypertension_diagnoses LIKE '%--%' THEN '"'||hypertension_diagnoses||'"' ELSE hypertension_diagnoses END hypertension_diagnoses,
  CASE WHEN exclusion_diagnoses LIKE '%--%' THEN '"'||exclusion_diagnoses||'"' ELSE exclusion_diagnoses END exclusion_diagnoses,
  fin_class,
  payer_type,
  payer_name,
  prim_care_provider,
  attending_provider
FROM dsrip_report_pqi90_78 rpt
WHERE report_period_start_dt = NVL(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER'), (SELECT MAX(report_period_start_dt) FROM dsrip_report_pqi90_78)) 
ORDER BY last_name, first_name, discharge_dt;
