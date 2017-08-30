drop table tst_visit_diagnoses purge;

CREATE TABLE tst_visit_diagnoses
(
  network, facility_id, patient_id, 
  visit_id, admission_dt, discharge_dt,
  visit_type_cd, provider_id, 
  problem_num, problem_description, diagnosis_icd_cd,
  data_element, is_primary_diagnosis,
  CONSTRAINT pk_tst_diagnoses primary key(visit_id, diagnosis_icd_cd)
) PARALLEL 4 COMPRESS AS
SELECT
  SUBSTR(ORA_DATABASE_NAME, 1, 3) network, 
  facility_id, patient_id, 
  visit_id, admission_dt, discharge_dt,
  visit_type_cd, provider_id, 
  problem_num, problem_description, diagnosis_icd_cd,
  data_element, is_primary_diagnosis
FROM
(
  SELECT 
    v.facility_id,
    v.patient_id,
    v.visit_id,
    v.admission_date_time admission_dt, 
    v.discharge_date_time discharge_dt,
    vt.abbreviation visit_type_cd,
    NVL(v.attending_emp_provider_id, v.resident_emp_provider_id) provider_id,
    prob.problem_number problem_num,
    prob.problem_description,
    NVL(pid.icd_diagnosis_code, 'Unknown') diagnosis_icd_cd,
    rf.name data_element,
    CASE WHEN rf.name IN ('ICD-10 CM', 'ICD-9 Diagnosis', 'ICD-9 Procedure') OR UPPER(rf.name) LIKE '%PRIMARY%' THEN 'Y' ELSE 'N' END is_primary_diagnosis,
    RANK() OVER
    (
      PARTITION BY v.visit_id, pid.icd_diagnosis_code
      ORDER BY
       CASE WHEN rf.name IN ('ICD-10 CM', 'ICD-9 Diagnosis', 'ICD-9 Procedure') OR UPPER(rf.name) LIKE '%PRIMARY%' THEN 'Y' ELSE 'N' END desc,
       ap.event_id, ap.result_report_number, ap.data_element_id, ap.item_number
    ) rnk
  FROM
    (
      SELECT 
        NVL
        (
          TO_DATE(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER')),
          ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'),-2)
        ) report_month
      FROM dual
    ) d
  JOIN ud_master.visit v ON v.discharge_date_time >= d.report_month
  JOIN ud_master.visit_type vt ON vt.visit_type_id = v.visit_type_id AND vt.abbreviation IN ('IP','OP','CP')
  JOIN ud_master.active_problem ap ON ap.visit_id = v.visit_id
  JOIN ud_master.result_field rf ON rf.data_element_id = ap.data_element_id
  JOIN ud_master.problem prob ON prob.patient_id = ap.patient_id AND prob.problem_number = ap.problem_number
  LEFT JOIN ud_master.problem_icd_diagnosis pid ON pid.patient_id = prob.patient_id AND pid.problem_number = ap.problem_number
) WHERE rnk = 1;

create index idx_tst_visit_diag_patient on tst_visit_diagnoses(patient_id);
