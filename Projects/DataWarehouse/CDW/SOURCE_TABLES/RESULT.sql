drop table result purge;

CREATE TABLE result
(
  network                        CHAR(3 BYTE) NOT NULL,
  VISIT_ID                       NUMBER(12)     NOT NULL,
  EVENT_ID                       NUMBER(12)     NOT NULL,
  RESULT_REPORT_NUMBER           NUMBER(12)     NOT NULL,
  DATA_ELEMENT_ID                VARCHAR2(25 BYTE) NOT NULL,
  MULTI_FIELD_OCCURRENCE_NUMBER  NUMBER(3)      DEFAULT 1 NOT NULL,
  ITEM_NUMBER                    NUMBER(3)      DEFAULT 1 NOT NULL,
  VALUE                          VARCHAR2(1023 BYTE),
  ABNORMAL_STATE_ID              VARCHAR2(3 BYTE),
  USED                           CHAR(1 BYTE),
  CID                            NUMBER DEFAULT to_number(TO_CHAR(sysdate,'YYYYMMDDHH24MISS'))
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
