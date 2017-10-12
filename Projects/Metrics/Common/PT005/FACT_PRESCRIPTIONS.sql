DROP TABLE fact_prescriptions PURGE;

CREATE TABLE fact_prescriptions
(
  network,
  facility_id,
  patient_id,
  mrn,
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
) COMPRESS BASIC PARALLEL 8;
