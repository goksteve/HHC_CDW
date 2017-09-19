prompt Copying DIAGNOSES data from &1

exec xl.begin_action('Copying DIAGNOSES data from &1')

COPY FROM khaykino/Window#07@&1.DW01 APPEND tst_ok_stg_diagnoses USING -
SELECT SUBSTR(db.name, 1, 3) network_cd, q.coding_scheme_cd, q.code, q.description -
FROM -
( -
  SELECT DISTINCT -
    DECODE(coding_scheme_id, 5, 'ICD-9', 'ICD-10') coding_scheme_cd, -
    code, description -
  FROM ud_master.problem_cmv -
  WHERE coding_scheme_id IN (5, 10) -
) q -
CROSS JOIN v$database db;

exec xl.end_action;