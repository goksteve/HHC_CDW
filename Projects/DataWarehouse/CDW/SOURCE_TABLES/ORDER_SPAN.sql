CREATE TABLE new_order_span
(
  NETWORK                   CHAR(3 BYTE) NOT NULL,
  VISIT_ID                  NUMBER(12) NOT NULL,
  ORDER_SPAN_ID             NUMBER(12) NOT NULL,
  ORDER_SPAN_STATUS_ID      NUMBER(12),
  CARE_PLAN_ORDER_FLAG      VARCHAR2(5 BYTE),
  ORIG_NEW_ORDER_EVENT_ID   NUMBER(12),
  MAIN_PROC_ID              NUMBER(12),
  MODIFIED_PROC_NAME        VARCHAR2(2048 BYTE),
  MAIN_BLOCK_DISPLAY        VARCHAR2(2048 BYTE),
  RESPONSIBLE_SHORT_NAME    VARCHAR2(50 BYTE),
  DRUG_INTERACTION_FLAG     VARCHAR2(5 BYTE),
  PRESCRIPTION_ORDER_FLAG   VARCHAR2(5 BYTE),
  CLIN_PATH_ORDER_FLAG      VARCHAR2(5 BYTE),
  RX_ID                     NUMBER(12)
) COMPRESS BASIC
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

CREATE UNIQUE INDEX pk_order_span ON order_span(visit_id, order_span_id, network) LOCAL PARALLEL 32;
ALTER INDEX pk_order_span NOPARALLEL;

ALTER TABLE order_span ADD CONSTRAINT pk_order_span PRIMARY KEY(visit_id, order_span_id, network) USING INDEX pk_order_span;