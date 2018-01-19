CREATE OR REPLACE VIEW v_etl_map_diagnose_codes AS 
SELECT
  -- 18-JAN-2018, OK: created
  DISTINCT icd10_code, icd9_code
FROM problem_cmv
PIVOT
(
  MAX(code) as code
  FOR coding_scheme_id IN (5 AS icd9, 10 AS icd10)
) pv
WHERE icd9_code IS NOT NULL AND icd10_code IS NOT NULL; 
