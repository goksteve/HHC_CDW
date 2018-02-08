CREATE TABLE stg_order_span_state
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
PARTITION BY HASH(visit_id) PARTITIONS 16;

INSERT --+ APPEND PARALLEL(16)
INTO cdw.stg_order_span_state
SELECT
  'NBX' network,
  visit_id,
  order_span_id,
  order_span_state_id,
  order_event_id,
  start_date_time,
  order_type_id,
  order_id,
  order_interface_id
FROM ud_master.order_span_state@nbxcdw01
WHERE order_span_state_id < 1000000000000;
 