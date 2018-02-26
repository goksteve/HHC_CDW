exec dbm.drop_tables('RESULT');

CREATE TABLE result
(
  network                        CHAR(3 BYTE) NOT NULL,
  visit_id                       NUMBER(12) NOT NULL,
  event_id                       NUMBER(12) NOT NULL,
  result_report_number           NUMBER(12) NOT NULL,
  data_element_id                VARCHAR2(25 BYTE) NOT NULL,
  multi_field_occurrence_number  NUMBER(3) DEFAULT 1 NOT NULL,
  item_number                    NUMBER(3) DEFAULT 1 NOT NULL,
  value                          VARCHAR2(1023 BYTE),
  abnormal_state_id              VARCHAR2(3 BYTE),
  used                           CHAR(1 BYTE),
  cid                            NUMBER DEFAULT to_number(TO_CHAR(sysdate,'YYYYMMDDHH24MISS'))
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

CREATE UNIQUE INDEX pk_result
ON result(visit_id, data_element_id, event_id, result_report_number, multi_field_occurrence_number, item_number, network)
LOCAL PARALLEL 32;

ALTER INDEX pk_result NOPARALLEL;

ALTER TABLE result ADD CONSTRAINT pk_result
 PRIMARY KEY(network, visit_id, event_id, data_element_id, result_report_number, multi_field_occurrence_number, item_number)
 USING INDEX pk_result;

CREATE INDEX idx_result_cid ON result(cid, network) LOCAL PARALLEL 32;
ALTER INDEX idx_result_cid NOPARALLEL;

CREATE OR REPLACE TRIGGER tr_insert_result
FOR INSERT OR UPDATE ON result
COMPOUND TRIGGER
  BEFORE STATEMENT IS
  BEGIN
    dwm.init_max_cids('RESULT');
  END BEFORE STATEMENT;

  AFTER EACH ROW IS
  BEGIN
    dwm.max_cids(:new.network) := GREATEST(dwm.max_cids(:new.network), :new.cid);
  END AFTER EACH ROW;

  AFTER STATEMENT IS
  BEGIN
    dwm.record_max_cids('RESULT');
  END AFTER STATEMENT;
END tr_insert_result;
/
