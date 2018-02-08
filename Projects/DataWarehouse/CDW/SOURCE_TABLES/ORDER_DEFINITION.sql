CREATE TABLE new_order_definition
(
  NETWORK                   CHAR(3 BYTE) NOT NULL,
  VISIT_ID                  NUMBER(12) NOT NULL,
  ORDER_SPAN_ID             NUMBER(12) NOT NULL,
  ORDER_SPAN_STATE_ID       NUMBER(12) NOT NULL,
  ORDER_DEFINITION_ID       VARCHAR2(25 BYTE) NOT NULL,
  PROC_ID                   NUMBER(12),
  BLOCK_DISPLAY             VARCHAR2(2048 BYTE),
  MISC_PROC_NAME            VARCHAR2(2048 BYTE),
  PRESCRIPTION_FLAG         VARCHAR2(5 BYTE),
  ORDER_START_TYPE          VARCHAR2(9 BYTE),
  SUB_PROC_ORDER_STATUS_ID  NUMBER(12)
) COMPRESS BASIC PARALLEL 16
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

CREATE UNIQUE INDEX pk_order_definition
ON order_definition(network, visit_id, order_span_id, order_span_state_id, order_definition_id)
LOCAL PARALLEL 16;

ALTER INDEX pk_order_definition NOPARALLEL;

ALTER TABLE order_definition ADD CONSTRAINT pk_order_definition
PRIMARY KEY(network, visit_id, order_span_id, order_span_state_id, order_definition_id)
USING INDEX pk_order_definition;
