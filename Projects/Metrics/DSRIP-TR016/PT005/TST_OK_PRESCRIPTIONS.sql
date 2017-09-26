ALTER SESSION ENABLE PARALLEL DML;
ALTER SESSION ENABLE PARALLEL DDL;

set timi on

DROP TABLE tst_ok_prescriptions PURGE;

CREATE TABLE tst_ok_prescriptions
(
  network,
  patient_id,
  order_dt,
  drug_name,
  drug_description,
  rx_quantity,
  dosage,
  frequency,
  rx_dc_dt, 
  rx_exp_dt
)
PARTITION BY RANGE(order_dt) INTERVAL (INTERVAL '1' YEAR)
SUBPARTITION BY LIST(network)
SUBPARTITION TEMPLATE
(
  SUBPARTITION cbn VALUES ('CBN'),
  SUBPARTITION gp1 VALUES ('GP1'),
  SUBPARTITION gp2 VALUES ('GP2'),
  SUBPARTITION nbn VALUES ('NBN'),
  SUBPARTITION nbx VALUES ('NBX'),
  SUBPARTITION qhn VALUES ('QHN'),
  SUBPARTITION sbn VALUES ('SBN'),
  SUBPARTITION smn VALUES ('SMN')
)
(
  PARTITION old_data VALUES LESS THAN (DATE '2010-01-01') 
) COMPRESS BASIC PARALLEL 8
AS SELECT
  network,
  patient_id,
  NVL(order_time, DATE '2010-01-01') AS order_dt,
  LOWER(procedure_name) AS drug_name,
  LOWER(derived_product_name) AS drug_description,
  rx_quantity,
  dosage,
  frequency,
  rx_dc_time as rx_dc_dt, 
  rx_exp_date as rx_exp_dt
FROM prescription_detail_dimension;
