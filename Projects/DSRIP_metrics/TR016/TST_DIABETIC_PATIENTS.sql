DROP TABLE TST_DIABETIC_PATIENTS PURGE;

CREATE TABLE tst_diabetic_patients PARALLEL 4 COMPRESS BASIC AS
SELECT 
  d.patient_id,
  MIN(NVL(p.start_date, p.onset_date)) start_dt,
  MAX(NVL(p.stop_date, DATE '9999-12-31')) stop_dt
FROM meta_conditions lkp
JOIN ud_master.problem_cmv d
  ON d.coding_scheme_id = DECODE(lkp.qualifier, 'ICD9', 5, 10)  
 AND d.code = lkp.value
JOIN ud_master.problem p
  ON p.patient_id = d.patient_id
 AND p.problem_number = d.problem_number
WHERE lkp.criterion_id = 6 -- 'DIAGNOSIS:DIABETES'
AND p.status_id IN (0, 6, 7, 8)
GROUP BY d.patient_id;

alter table tst_diabetic_patients add constraint pk_tst_diabetic_patients
 primary key(patient_id);
 
EXEC DBMS_STATS.GATHER_TABLE_STATS('KHAYKINO', 'TST_DIABETIC_PATIENTS');