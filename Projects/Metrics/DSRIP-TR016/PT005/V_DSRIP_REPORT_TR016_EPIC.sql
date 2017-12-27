CREATE OR REPLACE VIEW v_dsrip_report_tr016_epic AS
SELECT
 -- 2017-12-26, OK: created
  TRUNC(s.etl_load_date, 'MONTH') AS report_period_start_dt,
  CASE RTRIM(s.parent_location_name)
    WHEN 'HOME HEALTH' THEN 'HHC' 
    WHEN 'CONEY ISLAND' THEN 'SBN'
    ELSE 'QHN'
  END network,
  RTRIM(s.parent_location_name) facility_name,
  s.location_id,
  s.location_name,
  s.mrn_empi,
  s.location_mrn,
  s.pat_name,
  s.birth_date,
  s.age_years,
  s.address_line_1,
  s.address_line_2,
  s.address_state,
  s.address_zip,
  s.home_phone,
  s.last_primary_care_visit_dt,
  s.last_primary_care_vst_dep_nm,
  s.pcp_general_name,
  s.contactdate,
  s.hospital_discharge_date,
  s.encounter_type,
  s.inspayor1,
  s.inspayor2,
  s.inspayor3,
  s.icd10_codes,
  s.antipsychotic_med_order_dt,
  s.antipsychotic_medication_name,
  s.hemoglobin_order_time,
  s.hemoglobin_result_time,
  s.hemoglobin_result_value,
  s.numerator_flag_hemoglobin_test,
  s.last_behav_health_visit_dt,
  s.last_behav_health_visit_dep_nm
FROM epic_clarity.dsrip_diab_scrn_epic s
WHERE etl_load_date = 
( -- Take the latest dataset loaded in the report month:
  SELECT MAX(etl_load_date)
  FROM
  (
    SELECT
      TRUNC(NVL(TO_DATE(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER')), SYSDATE), 'MONTH') report_dt
    FROM dual 
  ) dt 
  JOIN epic_clarity.dsrip_diab_scrn_epic src
    ON src.etl_load_date >= dt.report_dt AND src.etl_load_date < ADD_MONTHS(dt.report_dt, 1)   
);
