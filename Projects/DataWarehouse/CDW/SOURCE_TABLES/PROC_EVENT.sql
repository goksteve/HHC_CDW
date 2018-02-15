exec dbm.drop_tables('PROC_EVENT');

CREATE TABLE new_proc_event
(
  network                         CHAR(3 BYTE) NOT NULL,
  visit_id                        NUMBER(12) NOT NULL,
  event_id                        NUMBER(15) NOT NULL,
  order_span_id                   NUMBER(12),
  order_span_state_id             NUMBER(30),
  proc_id                         NUMBER(12),
  orig_schedule_begin_date_time   DATE,
  orig_schedule_end_date_time     DATE,
  final_schedule_begin_date_time  DATE,
  final_schedule_end_date_time    DATE,
  abnormal_state_id               VARCHAR2(3 BYTE),
  modified_proc_name              VARCHAR2(2048 BYTE),
  facility_id                     NUMBER(12),
  priority_id                     NUMBER(12),
  corrected_flag                  VARCHAR2(5 BYTE),
  rx_flag                         VARCHAR2(5 BYTE),
  spec_recollect_flag             VARCHAR2(5 BYTE),
  complete_result_rpt             NUMBER(12),
  order_visit_id                  NUMBER(12),
  order_definition_id             VARCHAR2(25 BYTE),
  proc_order_nbr                  NUMBER(12),
  cid                             NUMBER DEFAULT TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')),
  orig_schedule_abs_string        VARCHAR2(250 BYTE),
  final_schedule_abs_string       VARCHAR2(250 BYTE)
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

CREATE UNIQUE INDEX pk_proc_event ON proc_event(event_id, visit_id, network) LOCAL PARALLEL 32;

ALTER INDEX pk_proc_event NOPARALLEL;

ALTER TABLE proc_event ADD CONSTRAINT pk_proc_event PRIMARY KEY(network, visit_id, event_id) USING INDEX pk_proc_event;
