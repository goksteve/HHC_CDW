CREATE TABLE new_proc_order_def
(
  network                CHAR(3 BYTE) NOT NULL,
  VISIT_ID               NUMBER(12) NOT NULL,
  ORDER_SPAN_ID          NUMBER(12) NOT NULL,
  ORDER_SPAN_STATE_ID    NUMBER(12) NOT NULL,
  ORDER_DEFINITION_ID    VARCHAR2(25 BYTE) NOT NULL,
  PROC_ORDER_NBR         NUMBER(12) NOT NULL,
  FREQUENCY              VARCHAR2(2048 BYTE),
  DOSAGE                 VARCHAR2(2048 BYTE),
  PRN_24HR_DOSAGE        VARCHAR2(25 BYTE),
  ORIG_PROC_ORDER_NBR    NUMBER(12),
  AUTZ_REQD_FLAG         VARCHAR2(5 BYTE),
  ORDER_AUTZ_STATUS_ID   NUMBER(12),
  AUTZ_APPROVAL_NBR      VARCHAR2(25 BYTE),
  TRANSPORT_DESTINATION  VARCHAR2(20 BYTE)
)
COMPRESS BASIC PARALLEL 16
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

alter table new_proc_order_def modify ORDER_SPAN_STATE_ID number(30);

INSERT --+ APPEND PARALLEL(16)
INTO new_proc_order_def
SELECT network, visit_id, order_span_id, order_span_state_id, order_definition_id, proc_order_nbr, frequency, dosage, prn_24hr_dosage, orig_proc_order_nbr, autz_reqd_flag, order_autz_status_id, autz_approval_nbr, transport_destination
FROM proc_order_def;

ALTER TABLE proc_order_def ADD CONSTRAINT pk_proc_order_def
 PRIMARY KEY(visit_id, order_span_id, order_span_state_id, order_definition_id, proc_order_nbr, network)
 USING INDEX pk_proc_order_def;
