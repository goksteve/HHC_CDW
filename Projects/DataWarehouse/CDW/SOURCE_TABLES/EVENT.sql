EXEC dbm.drop_tables('EVENT,ERR_EVENT');

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
ALTER TABLE event ADD CONSTRAINT chk_event_dt CHECK(date_time >= DATE '2014-01-01') PARALLEL 32;

GRANT SELECT ON event TO PUBLIC;

CREATE OR REPLACE TRIGGER tr_insert_event
FOR INSERT OR UPDATE ON event
COMPOUND TRIGGER
  BEFORE STATEMENT IS
  BEGIN
    dwm.init_max_cids('EVENT');
  END BEFORE STATEMENT;

  AFTER EACH ROW IS
  BEGIN
    dwm.max_cids(:new.network) := GREATEST(dwm.max_cids(:new.network), :new.cid);
  END AFTER EACH ROW;

  AFTER STATEMENT IS
  BEGIN
    dwm.record_max_cids('EVENT');
  END AFTER STATEMENT;
END tr_insert_event;
/

exec DBMS_ERRLOG.CREATE_ERROR_LOG('EVENT','ERR_EVENT');
ALTER TABLE err_event ADD entry_ts TIMESTAMP DEFAULT SYSTIMESTAMP;

-- Indexes on Vishnu's staging tables:
create index idx_event_cbn_cid on event_cbn(cid) parallel 32;
alter index idx_event_cbn_cid noparallel;

create index idx_event_gp1_cid on event_gp1(cid) parallel 32;
alter index idx_event_gp1_cid noparallel;

create index idx_event_gp2_cid on event_gp2(cid) parallel 32;
alter index idx_event_gp2_cid noparallel;

create index idx_event_nbn_cid on event_nbn(cid) parallel 32;
alter index idx_event_nbn_cid noparallel;

create index idx_event_nbx_cid on event_nbx(cid) parallel 32;
alter index idx_event_nbx_cid noparallel;

create index idx_event_sbn_cid on event_sbn(cid) parallel 32;
alter index idx_event_sbn_cid noparallel;

create index idx_event_smn_cid on event_smn(cid) parallel 32;
alter index idx_event_smn_cid noparallel;

create index idx_event_qhn_cid on event_qhn(cid) parallel 32;
alter index idx_event_qhn_cid noparallel;
