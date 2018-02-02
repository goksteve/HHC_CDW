CREATE OR REPLACE VIEW v_ref_diagnoses AS 
SELECT
 -- 02-FEB-2018, OK: created
  NVL(src.coding_scheme, tgt.coding_scheme) coding_scheme,
  NVL(src.code, tgt.code) code,
  src.description,
  NVL2(src.description, 'N', 'Y') delete_flag
FROM
(
  SELECT
    coding_scheme,
    code,
    MIN(description) KEEP(DENSE_RANK FIRST ORDER BY cnt DESC) description 
  FROM
  (
    SELECT 
      DECODE(coding_scheme_id, 5, 'ICD-9', 'ICD-10') coding_scheme,
      code, description,
      COUNT(1) cnt
    FROM problem_cmv
    WHERE coding_scheme_id IN (5, 10)
    GROUP BY coding_scheme_id, code, description
  )
  GROUP BY coding_scheme, code
) src
FULL JOIN ref_diagnoses tgt
  ON tgt.coding_scheme = src.coding_scheme AND tgt.code = src.code; 
