CREATE OR REPLACE VIEW v_dsrip_report_pqi90_78 AS
WITH
  dt AS
  (
    SELECT --+ materialize
      mon AS report_period_start_dt,
      ADD_MONTHS(mon, -1) begin_dt,
      mon end_dt
    FROM
    (
      SELECT TRUNC(NVL(TO_DATE(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER')), SYSDATE), 'MONTH') mon
      FROM dual
    )
  )
SELECT
  dt.report_period_start_dt,
  v.network,
  v.facility_id,
  v.patient_id,
  REGEXP_SUBSTR(v.visit_number, '^[^-]*') mrn,
  p.patient patient_name,
  TRUNC(p.birthdate) patient_dob,
  p.prim_care_provider,
  v.visit_id,
  v.visit_number,
  v.admission_date_time admission_dt,
  v.discharge_date_time discharge_dt,
  fc.name fin_class,
  v.attending_emp_provider_id,
  v.resident_emp_provider_id,
  concat_v2_set
  (
    CURSOR
    (
      SELECT --+ ordered
        DISTINCT cmv.code||': '||cmv.description
      FROM active_problem ap
      JOIN meta_conditions meta ON meta.criterion_id = 38
      JOIN problem_cmv cmv ON cmv.network = ap.network AND cmv.patient_id = ap.patient_id
       AND cmv.problem_number = ap.problem_number
       AND cmv.coding_scheme_id = 10 AND cmv.code = meta.value
      WHERE ap.network = v.network AND ap.visit_id = v.visit_id
      ORDER BY 1
    ),
    CHR(10)
  ) hypertension_codes, 
  concat_v2_set
  (
    CURSOR
    (
      SELECT --+ ordered
        DISTINCT cmv.code||': '||cmv.description
      FROM active_problem ap
      JOIN meta_conditions meta ON meta.criterion_id = 39
      JOIN problem_cmv cmv ON cmv.network = ap.network AND cmv.patient_id = ap.patient_id
       AND cmv.problem_number = ap.problem_number
       AND cmv.coding_scheme_id = 10 AND cmv.code = meta.value
      WHERE ap.network = v.network AND ap.visit_id = v.visit_id
      ORDER BY 1
    ),
    CHR(10)
  ) heart_failure_codes,
  concat_v2_set
  (
    CURSOR
    (
      SELECT --+ ordered
        DISTINCT cmv.code||': '||cmv.description
      FROM active_problem ap
      JOIN problem_cmv cmv ON cmv.network = ap.network AND cmv.patient_id = ap.patient_id
       AND cmv.problem_number = ap.problem_number
       AND cmv.coding_scheme_id = 10 AND cmv.code IN ('I12.9','I13.10')
      WHERE ap.network = v.network AND ap.visit_id = v.visit_id
      ORDER BY 1
    ),
    CHR(10)
  ) exclusion_codes
FROM dt
JOIN visit v ON v.discharge_date_time >= dt.begin_dt AND v.discharge_date_time < dt.end_dt AND v.visit_type_id = 1
JOIN hhc_patient_dimension p ON p.network = v.network AND p.patient_id = v.patient_id
JOIN financial_class fc ON fc.network = v.network AND fc.financial_class_id = v.financial_class_id
WHERE p.birthdate < ADD_MONTHS(v.admission_date_time, -18*12);
