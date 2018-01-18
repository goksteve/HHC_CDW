set timi on
set feed on

prompt - Populating table DSRIP_PQI_7_8_VISITS ...
INSERT /*+ parallel(4) */ INTO dsrip_pqi_7_8_visits
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
      SELECT DISTINCT cmv.code
      FROM ud_master.active_problem ap
      JOIN ud_master.problem prob ON prob.patient_id = ap.patient_id AND prob.problem_number = ap.problem_number
      JOIN ud_master.problem_cmv cmv ON cmv.patient_id = prob.patient_id AND cmv.problem_number = ap.problem_number AND cmv.coding_scheme_id = 10
      JOIN meta_conditions meta ON meta.value = cmv.code AND meta.criterion_id = 38
      WHERE ap.visit_id = v.visit_id
      ORDER BY cmv.code
    ),
    ', '
  ) hypertension_codes, 
  concat_v2_set
  (
    CURSOR
    (
      SELECT DISTINCT cmv.code
      FROM ud_master.active_problem ap
      JOIN ud_master.problem prob ON prob.patient_id = ap.patient_id AND prob.problem_number = ap.problem_number
      JOIN ud_master.problem_cmv cmv ON cmv.patient_id = prob.patient_id AND cmv.problem_number = ap.problem_number AND cmv.coding_scheme_id = 10
      JOIN meta_conditions meta ON meta.value = cmv.code AND meta.criterion_id = 39
      WHERE ap.visit_id = v.visit_id
      ORDER BY cmv.code
    ),
    ', '
  ) heart_failure_codes  
FROM dt
JOIN ud_master.visit v ON v.discharge_date_time >= dt.begin_dt AND v.discharge_date_time < dt.end_dt
JOIN ud_master.visit_type vt ON vt.visit_type_id = v.visit_type_id AND vt.abbreviation = 'IP'
JOIN hhc_custom.hhc_patient_dimension p ON p.patient_id = v.patient_id
JOIN ud_master.financial_class fc ON fc.financial_class_id = v.financial_class_id;

set feed off
set timi off

COMMIT;
