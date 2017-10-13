prompt Populating table DSRIP_TR001_DIAGNOSES ...

TRUNCATE TABLE dsrip_tr001_diagnoses;

INSERT INTO dsrip_tr001_diagnoses
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
  FROM dsrip_tr001_visits v
  JOIN ud_master.active_problem ap ON ap.visit_id = v.visit_id
  JOIN ud_master.result_field rf ON rf.data_element_id = ap.data_element_id
  JOIN ud_master.problem_cmv pid ON pid.patient_id = ap.patient_id AND pid.problem_number = ap.problem_number AND pid.coding_scheme_id IN (5, 10)
)
GROUP BY network, visit_id, coding_scheme_cd, icd_cd;

COMMIT;