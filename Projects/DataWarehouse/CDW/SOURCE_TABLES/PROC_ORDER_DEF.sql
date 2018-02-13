CREATE TABLE proc_order_def
(
  network                CHAR(3 BYTE) NOT NULL,
  visit_id               NUMBER(12) NOT NULL,
  order_span_id          NUMBER(12) NOT NULL,
  order_span_state_id    NUMBER(30) NOT NULL,
  order_definition_id    VARCHAR2(25 BYTE) NOT NULL,
  proc_order_nbr         NUMBER(12) NOT NULL,
  frequency              VARCHAR2(2048 BYTE),
  dosage                 VARCHAR2(2048 BYTE),
  prn_24hr_dosage        VARCHAR2(25 BYTE),
  orig_proc_order_nbr    NUMBER(12),
  autz_reqd_flag         VARCHAR2(5 BYTE),
  order_autz_status_id   NUMBER(12),
  autz_approval_nbr      VARCHAR2(25 BYTE),
  transport_destination  VARCHAR2(20 BYTE)
) 
COMPRESS BASIC
PARTITION BY LIST(network)
SUBPARTITION BY HASH(visit_id) SUBPARTITIONS 16
(
  PARTITION cbn VALUES('CBN'),
  PARTITION gp1 VALUES('GP1'),
  PARTITION gp2 VALUES('GP2'),
  PARTITION nbn VALUES('NBN'),
  PARTITION nbx VALUES('NBX'),
  PARTITION qhn VALUES('QHN'),
  PARTITION sbn VALUES('SBN'),
  PARTITION smn VALUES('SMN')
);

CREATE UNIQUE INDEX pk_proc_order_def
ON proc_order_def(order_span_id, order_span_state_id, order_definition_id, proc_order_nbr, visit_id, network) LOCAL PARALLEL 32;

ALTER INDEX pk_proc_order_def NOPARALLEL;

ALTER TABLE proc_order_def ADD CONSTRAINT pk_proc_order_def
 PRIMARY KEY(order_span_id, order_span_state_id, order_definition_id, proc_order_nbr, visit_id, network)
 USING INDEX pk_proc_order_def;
