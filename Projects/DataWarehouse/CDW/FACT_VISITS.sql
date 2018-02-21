exec dbm.drop_tables('FACT_VISITS');

CREATE TABLE fact_visits
(
  network	                CHAR(3 BYTE),
  visit_id	              NUMBER(12),
  patient_key	            NUMBER(12),
  facility_key	          NUMBER(12),
  first_department_key	  NUMBER(12),
  last_department_key	    NUMBER(12),
  attending_provider_key	NUMBER(12),
  resident_provider_key	  NUMBER(12),
  admitting_provider_key	NUMBER(12),
  visit_emp_provider_key	NUMBER(12),
  admission_dt	          DATE,
  admission_dtnum         NUMBER(15) AS (TO_NUMBER(TO_CHAR(admission_dt, 'YYYYMMDD'))),
  discharge_dt	          DATE,
  visit_number	          VARCHAR2(50 BYTE),
  initial_visit_type_id	  NUMBER(12),
  final_visit_type_id	    NUMBER(12),
  visit_status_id	        NUMBER(12),
  visit_activation_time	  DATE,
  discharge_type_key	    NUMBER(12),
  financial_class_id	    NUMBER(12),
  physician_service_id	  VARCHAR2(12 BYTE),
  first_payer_key         NUMBER(12),
  source	                VARCHAR2(64 BYTE) DEFAULT 'QCPR',
  load_date	              DATE DEFAULT SYSDATE,
  loaded_by               VARCHAR2(30) DEFAULT SYS_CONTEXT('USERENV','OS_USER')
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

GRANT SELECT ON fact_visits TO PUBLIC;

CREATE UNIQUE INDEX pk_fact_visits ON fact_visits(visit_id, network) LOCAL PARALLEL 16;
ALTER INDEX pk_fact_visits NOPARALLEL;

ALTER TABLE fact_visits ADD CONSTRAINT pk_fact_visits PRIMARY KEY(visit_id, network) USING INDEX pk_fact_visits;
