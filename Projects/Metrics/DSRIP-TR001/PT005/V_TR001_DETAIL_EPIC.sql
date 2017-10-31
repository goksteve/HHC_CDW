CREATE OR REPLACE VIEW v_tr001_detail_epic AS
SELECT
  SUBSTR(patient_name, 1, INSTR(patient_name, ',')-1) last_name,
  SUBSTR(patient_name, INSTR(patient_name, ',')+1) first_name,
  patient_dob,
  prim_care_provider,	 
  hospitalization_facility,	 
  mrn,
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
  NVL2(thirtyday_followup, 'Y', NULL) follow_up_30_days,	 
  NVL2(sevenday_followup, 'Y', NULL) follow_up_7_days,
  payorpatid,
  pat_id
FROM dsrip_report_tr001_epic
WHERE report_period_start_dt = (SELECT MAX(report_period_start_dt) FROM dsrip_report_tr001_epic) 
ORDER BY discharge_dt, last_name, first_name;
