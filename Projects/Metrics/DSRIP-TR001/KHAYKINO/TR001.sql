set timing on

prompt Setting report start date
EXEC dbms_session.set_identifier(ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'), -2));
SELECT SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER') FROM dual;

DROP TABLE tr001_visits PURGE;
 
prompt Creating table TR001_VISITS ...
CREATE TABLE tr001_visits COMPRESS BASIC AS
SELECT
  SUBSTR(db.name, 1, 3) network,
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
  FROM ud_master.visit v
  JOIN ud_master.visit_type vt ON vt.visit_type_id = v.visit_type_id AND vt.abbreviation IN ('IP','OP','CP')
  JOIN ud_master.active_problem ap ON ap.visit_id = v.visit_id
  JOIN ud_master.result_field rf ON rf.data_element_id = ap.data_element_id
  JOIN ud_master.problem prob ON prob.patient_id = ap.patient_id AND prob.problem_number = ap.problem_number
  JOIN ud_master.problem_icd_diagnosis pid ON pid.patient_id = prob.patient_id AND pid.problem_number = ap.problem_number
  JOIN ref_hedis_value_sets vs ON vs.code = pid.icd_diagnosis_code AND vs.value_set_name = 'Mental Illness'
  WHERE v.discharge_date_time >= SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER')
  AND v.discharge_date_time < LAST_DAY(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER'))+1
  UNION
  SELECT
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
  FROM ud_master.visit v
  JOIN ud_master.visit_type vt ON vt.visit_type_id = v.visit_type_id AND vt.abbreviation IN ('OP','CP')
  JOIN ud_master.visit_segment_visit_location vl ON vl.visit_id = v.visit_id
  JOIN hhc_custom.hhc_location_dimension ld ON ld.location_id = vl.location_id
  JOIN hhc_custom.hhc_clinic_codes cc ON cc.code = ld.clinic_code AND cc.service = 'Mental Health'
  WHERE v.admission_date_time >= SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER')
) q
CROSS JOIN v$database db
JOIN hhc_custom.hhc_patient_dimension p ON p.patient_id = q.patient_id
JOIN ud_master.financial_class fc ON fc.financial_class_id = q.financial_class_id;

DROP TABLE TR001_PAYERS PURGE;

prompt Creating table TR001_PAYERS ... 
CREATE TABLE tr001_payers
(
  network, visit_id, payer_id, payer_rank,
  CONSTRAINT pk_tr001_payers PRIMARY KEY(network, visit_id, payer_id)
) ORGANIZATION INDEX AS
SELECT
  v.network,
  v.visit_id,
  vsp.payer_id,
  MIN(vsp.payer_number) payer_rank
FROM tr001_visits v
JOIN ud_master.visit_segment_payer vsp ON vsp.visit_id = v.visit_id
GROUP BY v.network, v.visit_id, vsp.payer_id;

DROP TABLE TR001_PROVIDERS PURGE;

prompt Creating table TR001_PROVIDERS ... 
CREATE TABLE tr001_providers
(
  network, visit_id, provider_id,
  CONSTRAINT pk_tr001_providers PRIMARY KEY(network, visit_id, provider_id)
) ORGANIZATION INDEX AS
SELECT network, visit_id, attending_emp_provider_id AS provider_id
FROM tr001_visits
WHERE attending_emp_provider_id IS NOT NULL
UNION 
SELECT network, visit_id, resident_emp_provider_id AS provider_id
FROM tr001_visits
WHERE resident_emp_provider_id IS NOT NULL
UNION
SELECT --+ noparallel index(pea) 
  v.network, v.visit_id, pea.emp_provider_id AS provider_id
FROM tr001_visits v
JOIN ud_master.proc_event_archive pea ON pea.visit_id = v.visit_id AND pea.emp_provider_id IS NOT NULL;

DROP TABLE TR001_DIAGNOSES PURGE;

prompt Creating table TR001_DIAGNOSES ...
CREATE TABLE tr001_diagnoses
(
  network, visit_id, coding_scheme_cd, icd_cd, is_primary,
  CONSTRAINT pk_tr001_diagnoses PRIMARY KEY(network, visit_id, coding_scheme_cd, icd_cd)
) ORGANIZATION INDEX AS
SELECT
  network, visit_id, coding_scheme_cd, icd_cd,
  MAX(is_primary) is_primary
FROM
(
  SELECT
    v.network,
    v.visit_id,
    DECODE(pid.coding_scheme_id, 5, 'ICD-9', 'ICD-10') coding_scheme_cd,
    pid.code icd_cd,
    rf.name diag_comment,
    CASE WHEN rf.name IN ('ICD-10 CM', 'ICD-9 Diagnosis', 'ICD-9 Procedure') OR UPPER(rf.name) LIKE '%PRIMARY%' THEN 'Y' ELSE 'N' END is_primary
  FROM tr001_visits v
  JOIN ud_master.active_problem ap ON ap.visit_id = v.visit_id
  JOIN ud_master.result_field rf ON rf.data_element_id = ap.data_element_id
  JOIN ud_master.problem_cmv pid ON pid.patient_id = ap.patient_id AND pid.problem_number = ap.problem_number AND pid.coding_scheme_id IN (5, 10)
)
GROUP BY network, visit_id, coding_scheme_cd, icd_cd;
