ALTER SESSION ENABLE PARALLEL DML;
ALTER SESSION ENABLE PARALLEL DDL;
ALTER SESSION SET STAR_TRANSFORMATION_ENABLED=TRUE;

set timing on

DROP TABLE tr016_a1c_glucose_lvl PURGE;

CREATE TABLE tr016_a1c_glucose_lvl COMPRESS BASIC PARALLEL 8 AS
SELECT
  DISTINCT
  db.network,
  v.facility_id,
  v.patient_id,
  v.visit_id,
  e.date_time AS event_dt
FROM
(
  SELECT
    SUBSTR(name, 1, 3) network,
    ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'),-12) start_dt
  FROM v$database
) db
JOIN meta_conditions mc ON mc.network = db.network AND mc.criterion_id IN (4, 23) -- A1C and Glucose Level procedures
JOIN ud_master.result r ON r.data_element_id = mc.value
JOIN ud_master.event e ON e.visit_id = r.visit_id AND e.event_id = r.event_id AND e.date_time >= db.start_dt
JOIN ud_master.visit v ON v.visit_id = r.visit_id;
