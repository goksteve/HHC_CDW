ALTER SESSION ENABLE PARALLEL DML;
ALTER SESSION ENABLE PARALLEL DDL;
ALTER SESSION SET CURRENT_SCHEMA=pt005;

set timi on

TRUNCATE TABLE fact_prescriptions;

ALTER TABLE fact_prescriptions TRUNCATE PARTITION FOR (DATE '2017-11-17');

INSERT --+ APPEND PARALLEL(16)
INTO fact_prescriptions
SELECT
  network,
  facility_id,
  patient_id,
  medical_record_number,
  NVL(order_time, DATE '2010-01-01') AS order_dt,
  LOWER(procedure_name) AS drug_name,
  LOWER(derived_product_name) AS drug_description,
  rx_quantity,
  dosage,
  frequency,
  rx_dc_time as rx_dc_dt, 
  rx_exp_date as rx_exp_dt
FROM pt008.prescription_detail
WHERE order_time >= TRUNC(SYSDATE,'YEAR');

COMMIT;

TRUNCATE TABLE ref_drug_names;

INSERT --+ APPEND PARALLEL(16)
INTO ref_drug_names
WITH
  nm AS
  (
    SELECT --+ materialize
      DISTINCT drug_name 
    FROM fact_prescriptions
  ), 
  cnd AS
  (
    SELECT --+ materialize
      DISTINCT
      cnd.value,
      cr.criterion_id drug_type_id
    FROM meta_criteria cr 
    JOIN meta_conditions cnd ON cnd.criterion_id = cr.criterion_id
    WHERE cr.criterion_cd LIKE 'MEDICATIONS%' OR cr.criterion_cd LIKE 'SUPPLY%'
  )
SELECT --+ ordered
  DISTINCT n.drug_name, c.drug_type_id 
FROM nm n
JOIN cnd c ON n.drug_name LIKE c.value; 

COMMIT;

TRUNCATE TABLE ref_drug_descriptions;

INSERT --+ APPEND PARALLEL(16)
INTO ref_drug_descriptions
WITH
  dscr as
  (
    SELECT --+ materialize
      DISTINCT drug_description 
    FROM fact_prescriptions
  ),
  cnd AS
  (
    SELECT --+ materialize
      DISTINCT
      cnd.value,
      cr.criterion_id drug_type_id
    FROM meta_criteria cr 
    JOIN meta_conditions cnd ON cnd.criterion_id = cr.criterion_id
    WHERE cr.criterion_cd LIKE 'MEDICATIONS%' OR cr.criterion_cd LIKE 'SUPPLY%'
  )
SELECT --+ ordered
  DISTINCT d.drug_description, c.drug_type_id 
FROM dscr d
JOIN cnd c ON d.drug_description LIKE c.value; 

COMMIT;
