CREATE OR REPLACE VIEW v_tr001_detail_epic AS
SELECT
  SUBSTR(patient_name, 1, INSTR(patient_name, ',')-1) last_name,
  SUBSTR(patient_name, INSTR(patient_name, ',')+1) first_name,
  patient_dob,
  add_line_1,
  add_line_2,
  city,
  zip,
  state,
  pat_home_phone,
  pat_work_phone
  prim_care_provider,	 
  hospitalization_facility,	 
  mrn,
  mrn_empi empi,
  admission_dt,	 
  discharge_dt, 
  follow_up_visit_id,	 
  follow_up_dt,
  follow_up_facility,
  followup_department,
  followupProvName follow_up_provider_name,
  followupProvType follow_up_provider_type,
  followupProvSpeciality follow_up_provider_speciality,
  payor1,
  payor2,
  payor3,
  CASE WHEN thirtyday_followup <> '0' THEN 'Y' END follow_up_30_days,	 
  CASE WHEN sevenday_followup <> '0' THEN 'Y' END follow_up_7_days,
  payorpatid,
  pat_id
FROM dsrip_report_tr001_epic
WHERE report_period_start_dt = NVL(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER'),(SELECT MAX(report_period_start_dt) FROM dsrip_report_tr001_epic)) 
ORDER BY discharge_dt, last_name, first_name;
