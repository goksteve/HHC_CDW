EXEC dbm.drop_tables('EVENT');

CREATE TABLE event
(
  network                   CHAR(3 BYTE) NOT NULL,
  visit_id                  NUMBER(12) NOT NULL,
  event_id                  NUMBER(15) NOT NULL,
  date_time                 DATE,
  event_status_id           NUMBER(12),
  event_type_id             NUMBER(12),
  patient_schedule_display  VARCHAR2(100 BYTE),
  cid                       NUMBER(14),
  event_interface_id        VARCHAR2(128 BYTE)
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

CREATE UNIQUE INDEX pk_event ON event(event_id, visit_id, network) LOCAL PARALLEL 32;
ALTER INDEX pk_event NOPARALLEL;

CREATE INDEX idx_event_cid ON event(cid, network) LOCAL PARALLEL 32;
ALTER INDEX idx_event_cid NOPARALLEL;

ALTER TABLE event ADD CONSTRAINT pk_event PRIMARY KEY(network, visit_id, event_id) USING INDEX pk_event;

GRANT SELECT ON event TO PUBLIC;
