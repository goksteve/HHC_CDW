prompt Populating table REF_ICD10_DIAGNOSES

alter session enable parallel dml;

INSERT --+ parallel(8)
INTO ref_icd10_diagnoses
WITH
  lvl1 AS
  (
    SELECT --+ materialize
      REGEXP_SUBSTR(icd_level, '[A-Z0-9\-]*') icd10_code, description AS diagnosys, load_date AS load_dt
    FROM pt009.icd_level1
  ),
  lvl2 AS
  (
    SELECT --+ materialize
      *
    FROM
    (
      SELECT
        REGEXP_SUBSTR(icd_level2, '[A-Z0-9\-]*') icd10_code, description AS diagnosys, load_date AS load_dt
      FROM pt009.icd_level2
    )
    WHERE icd10_code NOT IN
    (
      'X92','X93','X94','X95','X96','X97','X98','X99',
      'Y00','Y01','Y02','Y03','Y04','Y07','Y08'
    )
  ),
  lvl3 AS
  (
    SELECT --+ materialize
      REGEXP_SUBSTR(icd_level, '[A-Z0-9\-]*') icd10_code, description AS diagnosys, load_date AS load_dt
    FROM pt009.icd_level3
  ),
  lvl4 AS
  (
    SELECT --+ materialize
      *
    FROM
    (
      SELECT
        REGEXP_SUBSTR(dcode, '[A-Z0-9\-]*') icd10_code,
        short_description AS diagnosys, long_description AS description, load_date AS load_dt
      FROM pt009.icd_code_all
    )
    WHERE icd10_code NOT IN
    (
      'A09','A33','A34','A35','A46','A55','A57','A58','A64','A65','A70','A78','A86','A89','A90','A91','A94','A99',
      'B03','B04','B09','B20','B20','B49','B54','B59','B64','B72','B75','B79','B80','B86','B89','B91','B92',
      'C01','C07','C12','C19','C20','C23','C33','C37','C52','C55','C58','C61','C73',
      'D34','D45','D62','D65','D66','D67','D71','D77',
      'E02','E15','E35','E40','E41','E42','E43','E45','E46','E52','E54','E58','E59','E60','E65','E68',
      'F04','F05','F09','F21','F22','F23','F24','F28','F29','F39','F42','F53','F54','F59',
      'F66','F69','F70','F71','F72','F73','F78','F79','F82','F88','F89','F99',
      'G01','G02','G07','G08','G09','G10','G14','G20','G26','G35','G53','G55','G59','G63','G64','G92','G94',
      'H22','H28','H32','H36','H42',
      'I00','I10','I32','I38','I39','I41','I43','I52','I76','I81','I96',
      'J13','J14','J17','J22','J36','J40','J42','J60','J61','J64','J65','J80','J82','J90','J99','J00',
      'K23','K30','K36','K37','K67','K77','K87',
      'L00','L14','L22','L26','L42','L45','L52','L54','L62','L80','L83','L84','L86','L88','L99',
      'N08','N10','N12','N16','N19','N22','N23','N29','N33','N37','N51','N61','N62','N63','N72','N74','N86','N96',
      'O68','O76','O80','O82','O85','O94',
      'P09','P09','P53','P60','P84','P84','P90','P95',
      'Q02',
      'R05','R12','R17','R21','R32','R34','R37','R42','R51','R52','R54','R55','R58','R61','R64','R75','R81'
    )
  )
  SELECT
    'Unknown-1' AS icd10_code, 'Unknown' AS diagnosys, 'Unknown' AS description,
    1 AS class_level, NULL AS parent_code, SYSDATE AS load_dt
  FROM dual
UNION ALL
  SELECT 'Unknown-2', 'Unknown', 'Unknown', 2, 'Unknown-1', SYSDATE FROM dual
UNION ALL
  SELECT 'Unknown-3', 'Unknown', 'Unknown', 3, 'Unknown-2', SYSDATE FROM dual
UNION ALL
  SELECT icd10_code, diagnosys, NULL, 1, NULL, load_dt FROM lvl1
UNION ALL
  SELECT l2.icd10_code, l2.diagnosys, NULL, 2, l1.icd10_code, l2.load_dt
  FROM lvl2 l2
  JOIN lvl1 l1
    ON REGEXP_SUBSTR(l1.icd10_code, '^[^-]*') <= REGEXP_SUBSTR(l2.icd10_code, '^[^-]*')
   AND REGEXP_SUBSTR(l1.icd10_code, '[^-]*$') >= REGEXP_SUBSTR(l2.icd10_code, '[^-]*$')
UNION ALL
  SELECT l3.icd10_code, l3.diagnosys, NULL, 3, NVL(l2.icd10_code, 'Unknown'), l3.load_dt
  FROM lvl3 l3
  LEFT JOIN lvl2 l2
    ON REGEXP_SUBSTR(l2.icd10_code, '^[^-]*') <= REGEXP_SUBSTR(l3.icd10_code, '^[^-]*')
   AND REGEXP_SUBSTR(l2.icd10_code, '[^-]*$') >= REGEXP_SUBSTR(l3.icd10_code, '[^-]*$')
  WHERE (l3.icd10_code NOT IN ('C7A','C7B') OR l2.icd10_code <> 'C76-C80' )
  AND (l3.icd10_code <> 'D3A' OR l2.icd10_code <> 'D37-D48')
UNION ALL
  SELECT l4.icd10_code, l4.diagnosys, l4.description, 4, NVL(l3.icd10_code, 'Unknown'), l4.load_dt
  FROM lvl4 l4
  LEFT JOIN lvl3 l3 ON l4.icd10_code LIKE l3.icd10_code||'%'
  WHERE l4.icd10_code IS NOT NULL;

COMMIT;
