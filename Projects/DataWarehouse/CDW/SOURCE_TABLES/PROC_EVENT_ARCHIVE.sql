CREATE TABLE proc_event_archive
(
  network                     CHAR(3 BYTE) NOT NULL,
  visit_id                    NUMBER(12) NOT NULL,
  event_id                    NUMBER(15) NOT NULL,
  archive_number              NUMBER(12) NOT NULL,
  archive_type_id             NUMBER(12),
  emp_provider_id             NUMBER(12),
  event_status_id             NUMBER(12),
  archive_time                DATE,
  arch_comment                VARCHAR2(2048 BYTE),
  result_report_nbr           NUMBER(12),
  review_comment              VARCHAR2(2048 BYTE),
  order_visit_id              NUMBER(12),
  spec_coll_time              DATE,
  spec_coll_emp_provider_id   NUMBER(12),
  off_line_doc_time           DATE,
  off_line_emp_provider_id    NUMBER(12),
  spec_receiving_area_id      NUMBER(12),
  spec_auto_accept_flg        VARCHAR2(17 BYTE),
  cid                         NUMBER DEFAULT TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS')),
  device_id                   NUMBER(12),
  scheduled_abs_time_type_id  NUMBER(12),
  scheduled_abs_time          DATE,
  context_visit_id            NUMBER(12),
  scheduled_abs_end_time      DATE,
  scheduled_abs_string        VARCHAR2(250 BYTE)
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

CREATE UNIQUE INDEX pk_proc_event_archive ON proc_event_archive(event_id, visit_id, archive_number, network) LOCAL PARALLEL 32;
ALTER INDEX pk_proc_event_archive NOPARALLEL;

CREATE INDEX idx_proc_event_archive_cid ON proc_event_archive(cid, network) LOCAL PARALLEL 32;
ALTER INDEX idx_proc_event_archive_cid NOPARALLEL;

ALTER TABLE proc_event_archive ADD CONSTRAINT pk_proc_event_archive
 PRIMARY KEY(network, visit_id, event_id, archive_number) USING INDEX pk_proc_event_archive;
