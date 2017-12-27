CREATE OR REPLACE VIEW v_tr016_detail_epic AS
SELECT
 -- 2017-12-27, OK: created
  t.report_period_start_dt,
  t.mrn_empi,
  t.network,
  t.facility_name,
  t.location_id,
  t.location_name,
  t.pat_name patient_name,
  t.location_mrn medical_record_number,
  t.birth_date,
  t.age_years age,
  t.address_line_1 street_address,
  t.address_line_2 apt_suite,
  zc.city_mixed_case city,
  t.address_state state,
  t.address_zip zip_code,
  t.antipsychotic_medication_name medication,
  t.antipsychotic_med_order_dt,
  t.pcp_general_name prim_care_provider,
  t.last_primary_care_visit_dt,
  t.encounter_type visit_type,
  t.contactdate admission_dt,
  t.hospital_discharge_date hospital_discharge_dt,
  t.inspayor1 payer_1,
  t.inspayor1 payer_2,
  t.inspayor1 payer_3,
  t.hemoglobin_result_time hemoglobin_test_dt,
  t.hemoglobin_result_value hemoglobin_value,
  DECODE(t.numerator_flag_hemoglobin_test, 1, 'Y', 'N') screened
FROM dsrip_report_tr016_epic t
LEFT JOIN cdw.ref_zip_codes zc ON zc.zip_code = t.address_zip
WHERE t.report_period_start_dt = NVL
(
  SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER'), 
  (SELECT MAX(report_period_start_dt) FROM dsrip_report_tr016)
)
ORDER BY patient_name;
