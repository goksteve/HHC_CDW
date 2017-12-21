ALTER SESSION ENABLE PARALLEL DML;
ALTER SESSION ENABLE PARALLEL DDL;
ALTER SESSION SET CURRENT_SCHEMA=pt005;

set timi on

ALTER TABLE fact_prescriptions TRUNCATE PARTITION FOR (TRUNC(SYSDATE,'YEAR'));

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

prompt Re-loading the table REF_DRUG_NAMES ...

TRUNCATE TABLE ref_drug_names;

INSERT --+ APPEND PARALLEL(16)
INTO ref_drug_names
WITH
  nm AS
  (
    SELECT --+ materialize
      DISTINCT drug_name 
    FROM fact_prescriptions
  )
SELECT --+ ordered
  DISTINCT n.drug_name, c.criterion_id 
FROM nm n
JOIN meta_conditions c
  ON c.condition_type_cd = 'MED' AND c.include_exclude_ind = 'I' AND c.comparison_operator = 'LIKE' AND n.drug_name LIKE c.value; 

COMMIT;

prompt Re-loading the table REF_DRUG_DESCRIPTIONS ...

TRUNCATE TABLE ref_drug_descriptions;

INSERT --+ APPEND PARALLEL(16)
INTO ref_drug_descriptions
WITH
  dscr as
  (
    SELECT --+ materialize
      DISTINCT drug_description 
    FROM fact_prescriptions
    WHERE drug_description NOT LIKE 'catalyst 5 wheechair dimension%'
  )
  SELECT
    d.drug_description, c.criterion_id
  FROM dscr d
  JOIN meta_conditions c
    ON c.condition_type_cd = 'MED' AND include_exclude_ind = 'I' AND c.comparison_operator = 'LIKE' AND d.drug_description LIKE c.value
UNION
  SELECT
    d.drug_description, c.criterion_id 
  FROM dscr d
  JOIN meta_conditions c
    ON c.condition_type_cd = 'MED' AND c.comparison_operator = '=' AND c.value = d.drug_description AND c.include_exclude_ind = 'I'
MINUS -- Exclude from the Drug Type 33 all the Medications listed in the Metadata List #35 
  SELECT value, 33
  FROM meta_conditions
  WHERE criterion_id = 35;

COMMIT;
