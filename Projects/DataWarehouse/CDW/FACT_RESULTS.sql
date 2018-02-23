exec dbm.drop_tables('FACT_RESULTS');

CREATE TABLE fact_results
(
  network                        VARCHAR2(3 BYTE),
  visit_id                       NUMBER(12) NOT NULL,
  event_id                       NUMBER(15) NOT NULL,
  result_report_number           NUMBER(12) NOT NULL,
  multi_field_occurrence_number  NUMBER(3) NOT NULL,
  item_number                    NUMBER(3) NOT NULL,
  result_dt                      DATE NOT NULL,
  result_dtnum                   NUMBER(8) AS (TO_NUMBER(TO_CHAR(result_dt,'YYYYMMDD'))),
  patient_key                    NUMBER(12) NOT NULL,
  proc_facility_key              NUMBER(12) NOT NULL,
  proc_key                       NUMBER(12),
  event_status_id                NUMBER(12),
  event_type_id                  NUMBER(12),
  data_element_id                VARCHAR2(25 BYTE) NOT NULL,
  result_value                   VARCHAR2(1023 BYTE),
  decode_source_id               VARCHAR2(40 BYTE),
  decoded_value                  VARCHAR2(1300 BYTE),
  load_dt                        DATE DEFAULT TRUNC(SYSDATE)
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

GRANT SELECT ON fact_results TO PUBLIC;

CREATE UNIQUE INDEX pk_fact_results ON fact_results(event_id, result_report_number, multi_field_occurrence_number, item_number, visit_id, network)
 LOCAL PARALLEL 32;       

ALTER INDEX pk_fact_results NOPARALLEL;

ALTER TABLE fact_results ADD CONSTRAINT pk_fact_results
PRIMARY KEY(event_id, result_report_number, multi_field_occurrence_number, item_number, visit_id, network)
USING INDEX pk_fact_results;
