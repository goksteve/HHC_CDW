ALTER SESSION ENABLE PARALLEL DML;
ALTER SESSION ENABLE PARALLEL DDL;
ALTER SESSION SET STAR_TRANSFORMATION_ENABLED=TRUE;

set timing on

DROP TABLE tr016_a1c_glucose_lvl PURGE;
DROP TABLE tr016_payers PURGE;

prompt Creating table TR016_A1C_GLUCOSE_LVL ... 
CREATE TABLE tr016_a1c_glucose_lvl COMPRESS BASIC PARALLEL 8 AS
SELECT  --+ ordered full(r) use_hash(e) use_hash(v) materialize
  DISTINCT
  db.network,
  v.facility_id,
  v.patient_id,
  v.visit_id,
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
JOIN ud_master.result_field rf ON rf.data_element_id = r.data_element_id;

prompt Creating table TR016_PAYERS ... 
CREATE TABLE tr016_payers
(
  network, visit_id, payer_id, payer_rank,
  CONSTRAINT pk_tr016_payers PRIMARY KEY(network, visit_id, payer_id)
) ORGANIZATION INDEX AS
SELECT
  v.network,
  v.visit_id,
  vsp.payer_id,
  MIN(vsp.payer_number) payer_rank
FROM 
(
  SELECT DISTINCT network, visit_id
  FROM tr016_a1c_glucose_lvl
) v
JOIN ud_master.visit_segment_payer vsp ON vsp.visit_id = v.visit_id
GROUP BY v.network, v.visit_id, vsp.payer_id;