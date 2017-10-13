prompt Populating DSRIP_TR001_VISITS ...

INSERT --+ parallel(4) 
INTO dsrip_tr001_visits
WITH
  dt AS
  (
    SELECT --+ materialize
      network,
      mon AS report_period_start_dt,
      ADD_MONTHS(mon, -2) begin_dt,
      ADD_MONTHS(mon, -1) end_dt
    FROM
    (
      SELECT
        SUBSTR(name, 1, 3) network,
        TRUNC(NVL(TO_DATE(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER')), SYSDATE), 'MONTH') mon
      FROM v$database
    )
  )
SELECT
  q.report_period_start_dt,
  q.network,
  q.facility_id,
  q.patient_id,
  p.patient patient_name,
  TRUNC(p.birthdate) patient_dob,
  p.prim_care_provider,
  q.visit_id,
  q.visit_number,
  REGEXP_SUBSTR(q.visit_number, '^[^-]*') mrn,
  q.admission_dt,
  q.discharge_dt,
  q.visit_type_cd,
  fc.name fin_class,
  q.attending_emp_provider_id,
  q.resident_emp_provider_id
FROM
(
  SELECT
    dt.report_period_start_dt,
    dt.network,
    v.facility_id,
    v.patient_id,
    v.visit_id,
    v.visit_number,
    vt.abbreviation visit_type_cd,
    v.financial_class_id,
    v.admission_date_time admission_dt,
    v.discharge_date_time discharge_dt,
    v.attending_emp_provider_id,
    v.resident_emp_provider_id
  FROM dt
  JOIN ud_master.visit v
    ON v.discharge_date_time >= dt.begin_dt
--   AND v.discharge_date_time < dt.end_dt -- this condition is commented-out because we need 'OP' and 'CP' Visits up to the current date 
  JOIN ud_master.visit_type vt ON vt.visit_type_id = v.visit_type_id AND vt.abbreviation IN ('IP','OP','CP')
  JOIN ud_master.active_problem ap ON ap.visit_id = v.visit_id
  JOIN ud_master.result_field rf ON rf.data_element_id = ap.data_element_id
  JOIN ud_master.problem prob ON prob.patient_id = ap.patient_id AND prob.problem_number = ap.problem_number
  JOIN ud_master.problem_icd_diagnosis pid ON pid.patient_id = prob.patient_id AND pid.problem_number = ap.problem_number
  JOIN ref_hedis_value_sets vs ON vs.code = pid.icd_diagnosis_code AND vs.value_set_name = 'Mental Illness'
 UNION
  SELECT
    dt.report_period_start_dt,
    dt.network,
    v.facility_id, 
    v.patient_id,
    v.visit_id,
    v.visit_number,
    vt.abbreviation visit_type_cd, 
    v.financial_class_id,
    v.admission_date_time admission_dt,
    v.discharge_date_time discharge_dt,
    v.attending_emp_provider_id,
    v.resident_emp_provider_id
  FROM dt
  JOIN ud_master.visit v ON v.admission_date_time >= dt.begin_dt  
  JOIN ud_master.visit_type vt ON vt.visit_type_id = v.visit_type_id AND vt.abbreviation IN ('OP','CP')
  JOIN ud_master.visit_segment_visit_location vl ON vl.visit_id = v.visit_id
  JOIN hhc_custom.hhc_location_dimension ld ON ld.location_id = vl.location_id
  JOIN hhc_custom.hhc_clinic_codes cc ON cc.code = ld.clinic_code AND cc.service = 'Mental Health'
) q
JOIN hhc_custom.hhc_patient_dimension p ON p.patient_id = q.patient_id
JOIN ud_master.financial_class fc ON fc.financial_class_id = q.financial_class_id;

COMMIT;