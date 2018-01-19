CREATE OR REPLACE VIEW v_etl_ref_diagnoses AS 
SELECT
 -- 18-JAN-2018, OK: created
  coding_scheme,
  code,
  MIN(description) KEEP(DENSE_RANK FIRST ORDER BY cnt DESC) description 
FROM
(
  SELECT 
    DECODE(coding_scheme_id, 5, 'ICD-9', 'ICD-10') coding_scheme, code,
    description,
    COUNT(1) cnt
  FROM problem_cmv
  WHERE coding_scheme_id IN (5, 10)
  GROUP BY coding_scheme_id, code, description
)
GROUP BY coding_scheme, code; 
