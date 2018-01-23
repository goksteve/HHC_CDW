CREATE OR REPLACE VIEW v_etl_map_diagnoses_codes AS 
SELECT
  -- 18-JAN-2018, OK: created
  DISTINCT icd10_code, icd9_code
FROM
(
  SELECT network, patient_id, problem_number, coding_scheme_id, code
  FROM problem_cmv
  WHERE coding_scheme_id IN (5, 10)
)
PIVOT
(
  MAX(code) as code
  FOR coding_scheme_id IN (5 AS icd9, 10 AS icd10)
) pv
WHERE icd9_code IS NOT NULL AND icd10_code IS NOT NULL; 
