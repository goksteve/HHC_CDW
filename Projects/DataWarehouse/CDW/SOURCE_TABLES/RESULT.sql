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

CREATE BITMAP INDEX bmi_result_element_id
ON result(data_element_id, network)
LOCAL PARALLEL 32;

create index idx_result_cbn_cid on result_cbn(cid) parallel 32;
alter index idx_result_cbn_cid noparallel;

create index idx_result_gp1_cid on result_gp1(cid) parallel 32;
alter index idx_result_gp1_cid noparallel;

create index idx_result_gp2_cid on result_gp2(cid) parallel 32;
alter index idx_result_gp2_cid noparallel;

create index idx_result_nbn_cid on result_nbn(cid) parallel 32;
alter index idx_result_nbn_cid noparallel;

create index idx_result_nbx_cid on result_nbx(cid) parallel 32;
alter index idx_result_nbx_cid noparallel;

create index idx_result_qhn_cid on result_qhn(cid) parallel 32;
alter index idx_result_qhn_cid noparallel;

create index idx_result_sbn_cid on result_sbn(cid) parallel 32;
alter index idx_result_sbn_cid noparallel;

create index idx_result_smn_cid on result_smn(cid) parallel 32;
alter index idx_result_smn_cid noparallel;

drop index cidx_result_smn;
