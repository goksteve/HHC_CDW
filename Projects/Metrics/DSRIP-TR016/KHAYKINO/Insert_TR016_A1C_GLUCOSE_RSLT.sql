prompt Poputing table DSRIP_TR016_A1C_GLUCOSE_RSLT ... 
ALTER SESSION ENABLE PARALLEL DML;

TRUNCATE TABLE DSRIP_TR016_A1C_GLUCOSE_RSLT;

INSERT --+ parallel(8) 
INTO dsrip_tr016_a1c_glucose_rslt
SELECT  --+ ordered full(r) use_hash(e) use_hash(v)
  DISTINCT
  db.network,
  v.facility_id,
  v.patient_id,
  v.visit_id,
  v.visit_number,
  v.visit_type_id,
  vt.name visit_type,
  v.admission_date_time admission_dt,
  v.discharge_date_time discharge_dt,
  mc.criterion_id test_type_id,
  e.event_id,
  e.date_time AS result_dt,
  r.data_element_id,
  rf.name data_element_name,
  r.value result_value
FROM
(
  SELECT
    SUBSTR(name, 1, 3) network,
    NVL(TO_DATE(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER')), TRUNC(SYSDATE, 'MONTH')) report_dt,
    ADD_MONTHS(NVL(TO_DATE(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER')), TRUNC(SYSDATE, 'MONTH')), -12) year_back_dt
  FROM v$database
) db
JOIN meta_conditions mc ON mc.network = db.network AND mc.criterion_id IN (4, 23) -- A1C and Glucose Level results
JOIN ud_master.result r ON r.data_element_id = mc.value
JOIN ud_master.event e ON e.visit_id = r.visit_id AND e.event_id = r.event_id
 AND e.date_time >= db.year_back_dt AND e.date_time < db.report_dt 
JOIN ud_master.visit v ON v.visit_id = r.visit_id
JOIN ud_master.visit_type vt ON vt.visit_type_id = v.visit_type_id
JOIN ud_master.result_field rf ON rf.data_element_id = r.data_element_id;

COMMIT;