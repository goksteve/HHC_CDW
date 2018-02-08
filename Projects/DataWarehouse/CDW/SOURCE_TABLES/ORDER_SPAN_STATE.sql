CREATE TABLE order_span_state
(
  NETWORK              CHAR(3 BYTE) NOT NULL,
  VISIT_ID             NUMBER(12) NOT NULL,
  ORDER_SPAN_ID        NUMBER(12) NOT NULL,
  ORDER_SPAN_STATE_ID  NUMBER(12) NOT NULL,
  ORDER_EVENT_ID       NUMBER(12),
  START_DATE_TIME      DATE,
  ORDER_TYPE_ID        NUMBER(12),
  ORDER_ID             NUMBER(12),
  ORDER_INTERFACE_ID   NUMBER(12)
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

CREATE UNIQUE INDEX pk_order_span_state ON order_span_state(visit_id, order_span_id, order_span_state_id, network) LOCAL PARALLEL 32;
ALTER INDEX pk_order_span_state NOPARALLEL;

ALTER TABLE order_span_state ADD CONSTRAINT pk_order_span_state
 PRIMARY KEY (visit_id, order_span_id, order_span_state_id, network)
 USING INDEX pk_order_span_state;

