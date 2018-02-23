EXEC dbm.drop_tables('FACT_VISIT_METRIC_RESULTS');

CREATE TABLE fact_visit_metric_results
(
  network	                  CHAR(3 BYTE),
  visit_id	                NUMBER(12),
  patient_key               NUMBER(12) NOT NULL,
  result_dt                 DATE NOT NULL,
  result_dtnum              NUMBER(8) AS (TO_NUMBER(TO_CHAR(result_dt, 'YYYYMMDD'))),
  a1c_final_orig_value	    VARCHAR2(1023 BYTE),
  a1c_final_calc_value	    NUMBER,
  bp_final_orig_value	      VARCHAR2(1023 BYTE),
  bp_final_calc_value	      NUMBER,
  glucose_final_orig_value	VARCHAR2(1023 BYTE),
  glucose_final_calc_value	NUMBER,
  ldl_final_orig_value	    VARCHAR2(1023 BYTE),
  ldl_final_calc_value	    NUMBER
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

GRANT SELECT ON fact_visit_metric_results TO PUBLIC;

CREATE UNIQUE INDEX pk_fact_visit_metric_results ON fact_visit_metric_results (visit_id, network) LOCAL PARALLEL 32;
ALTER INDEX pk_fact_visit_metric_results NOPARALLEL;

ALTER TABLE fact_visit_metric_results ADD CONSTRAINT pk_fact_visit_metric_results PRIMARY KEY (visit_id, network) USING INDEX pk_fact_visit_metric_results;