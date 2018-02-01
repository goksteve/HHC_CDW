INSERT /*+ PARALLEL(8) APPEMD */
INTO DSRIP_TR017_DIAB_MON_CDW_STAGE
(
  network,
  FACILITY_ID,
  FACILITY_NAME,
  PATIENT_ID,
  PAT_LNAME,
  PAT_FNAME,
  MRN,
  BIRTHDATE,
  AGE,
  PCP,
  VISIT_ID,
  EVENT_ID,
  VISIT_TYPE_ID,
  VISIT_TYPE,
  ADMISSION_DATE_TIME,
  DISCHARGE_DATE_TIME,
  PAYER_ID,
  PLAN_ID,
  PLAN_NAME,
  RESULT_DATE,
  TEST_ID,
  TEST_DESC,
  RESULT_VALUE,
  COMB_IND,
  A1C_IND,
  LDL_IND,
  TEST_TYPE
);
WITH
  get_dates AS
  (
    SELECT
      SUBSTR(ORA_DATABASE_NAME, 1, 3) AS network,
      ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'), -24) LAST_24_MON,
      ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'), -12) LAST_12_MON,
      TRUNC(SYSDATE, 'MONTH') AS FIRST_DAY_CUR_MON, ---current _month_first_day
      TRUNC(SYSDATE, 'MONTH') - 1 AS LAST_DAY_PREV_MONTH,
      ADD_MONTHS(TRUNC((TRUNC(SYSDATE, 'MONTH') - 1), 'YEAR'), 12) - 1 AS LAST_DAY_MEASUR_YEAR
    FROM DUAL
  ),
  res as
  (
    SELECT /*+ materialize */
      dt.network,
      pe.facility_id,
      v.patient_id,
      v.visit_id,
      v.visit_type_id,
      v.admission_date_time,
      v.discharge_date_time,
      v.financial_class_id AS plan_id,
      rr.event_id,
      DECODE(mc.criterion_id, 4, 'A1C', 'LDL') test_type,
      ee.date_time AS result_date,
      rr.data_element_id AS test_id,
      mc.data_element_name AS test_desc,
      CASE
       WHEN mc.criterion_id = 10 THEN rr.value
       WHEN SUBSTR(rr.VALUE, 1, 1) <> '0'
        AND REGEXP_COUNT(rr.VALUE, '\.', 1) <= 1
        AND LENGTH(rr.VALUE) <= 38
        AND REGEXP_REPLACE(REGEXP_REPLACE(rr.VALUE, '[^[:digit:].]'), '\.$') <= 50
       THEN REGEXP_REPLACE(REGEXP_REPLACE(rr.VALUE, '[^[:digit:].]'), '\.$')
      END result_value,
      ROW_NUMBER() OVER(PARTITION BY v.patient_id, mc.criterion_id ORDER BY ee.date_time DESC) rnum,
      COUNT(DISTINCT mc.criterion_id) OVER(PARTITION BY v.patient_id) rslt_cnt 
    FROM get_dates dt 
    JOIN meta_conditions mc
      ON mc.network = dt.network
     AND mc.criterion_id IN (4, 10)
     AND mc.condition_type_cd = 'EI'
     AND mc.include_exclude_ind = 'I'
    JOIN ud_master.result rr
      ON rr.rr.data_element_id = mc.data_element_id
     AND rr.value IS NOT NULL
    JOIN ud_master.event ee
      ON ee.visit_id = rr.visit_id AND ee.event_id = rr.event_id
     AND ee.date_time BETWEEN dt.last_24_mon AND dt.first_day_cur_mon
    JOIN ud_master.proc_event pe
      ON pe.visit_id = ee.visit_id and pe.event_id = ee.event_id
   JOIN ud_master.visit v
      ON v.visit_id = ee.visit_id
     AND v.visit_status_id NOT IN (8, 9, 10, 11) --REMOVE ( cancelled,closed cancelled,no show,closed no show)
     AND v.visit_type_id NOT IN (8, 5, 7, -1) -- REMOVE(LIFECARE,REFFERAL,HISTORICAL,UNKNOWN)
  ),
  payers AS
  (
    SELECT
      v.visit_id,
      sp.payer_id,
      ROW_NUMBER() OVER(PARTITION BY v.visit_id ORDER BY sp.visit_segment_number, sp.payer_number) AS payer_num
    FROM
    (
      SELECT DISTINCT visit_id 
      FROM res
    ) v
    JOIN ud_master.visit_segment_payer sp ON sp.visit_id = v.visit_id 
  )
SELECT
  res.network,
  SUBSTR(pp.name, 1, INSTR(pp.name, ',', 1) - 1) AS pat_lname,
  SUBSTR(pp.name, INSTR(pp.name, ',') + 1) AS pat_fname,
  NVL(psn.secondary_number, pp.medical_record_number) AS mrn
FROM res
JOIN ud_master.patient pp
  ON pp.patient_id = res.patient_id
 AND LOWER(pp.name) NOT LIKE 'test,%'
 AND LOWER(pp.name) NOT LIKE 'testing,%'
 AND LOWER(pp.name) NOT LIKE '%,test'
 AND LOWER(pp.name) NOT LIKE 'testggg,%'
 AND LOWER(pp.name) NOT LIKE '%,test%ccd'
 AND LOWER(pp.name) NOT LIKE 'test%ccd,%'
 AND LOWER(pp.name) <> 'emergency,testone'
 AND LOWER(pp.name) <> 'testtwo,testtwo'
LEFT JOIN ud_master.financial_class fc ON fc.financial_class_id = res.plan_id
LEFT JOIN ud_master.visit_type vt ON vt.visit_type_id = res.visit_type_id
LEFT JOIN payers pr ON pr.visit_id = r.visit_id AND pr.payer_num = 1
LEFT JOIN hhc_custom.hhc_patient_dimension hh ON hh.patient_id = rr.patient_id
LEFT JOIn ud_master.patient_secondary_number psn
  ON psn.patient_id = res.patient_id
 AND psn.secondary_nbr_type_id =
  CASE
    WHEN (res.network = 'GP1' AND res.facility_id = 1) THEN 13
    WHEN (res.network = 'GP1' AND res.facility_id IN (2, 4)) THEN 11
    WHEN (res.network = 'GP1' AND res.facility_id = 3) THEN 12
    WHEN (res.network = 'CBN' AND res.facility_id = 4) THEN 12
    WHEN (res.network = 'CBN' AND res.facility_id = 5) THEN 13
    WHEN (res.network = 'NBN' AND res.facility_id = 2) THEN 9
    WHEN (res.network = 'NBX' AND res.facility_id = 2) THEN 11
    WHEN (res.network = 'QHN' AND res.facility_id = 2) THEN 11
    WHEN (res.network = 'SBN' AND res.facility_id = 1) THEN 11
    WHEN (res.network = 'SMN' AND res.facility_id = 2) THEN 11
    WHEN (res.network = 'SMN' AND res.facility_id = 7) THEN 13
  END
WHERE res.rnum = 1;

-- Добавь эти колонки:  
  --    AB.FACILITY_NAME -- это добавишь в PT005 из Dimension table
  AB.BIRTHDATE,
  AB.AGE,
  AB.PCP,
  AB.VISIT_ID,
  AB.EVENT_ID,
  AB.VISIT_TYPE_ID,
  vt.name AS VISIT_TYPE,
  AB.ADMISSION_DATE_TIME,
  AB.DISCHARGE_DATE_TIME,
  AB.PAYER_ID,
  AB.PLAN_ID,
  fc.NAME AS PLAN_NAME,
  AB.RESULT_DATE,
  AB.TEST_ID,
  AB.TEST_DESC,
  AB.RESULT_VALUE,
  CASE WHEN PP.PATIENT_ID > 0 THEN 1 ELSE NULL END AS COMB_IND 
  A1C_ID,
  LDL_IND,
  TEST_TYPE
