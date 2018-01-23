exec dbm.drop_tables('DSRIP_REPORT_PQI90_78');

CREATE TABLE dsrip_report_pqi90_78
(
  report_period_start_dt  DATE,
  network                 CHAR(3 BYTE),
  facility                VARCHAR2(100 BYTE),
  last_name               VARCHAR2(40 BYTE),
  first_name              VARCHAR2(40 BYTE),
  dob                     DATE,
  mrn                     VARCHAR2(40 BYTE),
  visit_id                NUMBER(12),
  visit_number            VARCHAR2(40 BYTE),
  admission_dt            DATE,
  discharge_dt            DATE,
  fin_class               VARCHAR2(100 BYTE),
  payer_type              VARCHAR2(1000 BYTE),
  payer_name              VARCHAR2(150 BYTE),
  prim_care_provider      VARCHAR2(60 BYTE),
  attending_provider      VARCHAR2(60 BYTE),
  resident_provider       VARCHAR2(60 BYTE),
  hypertension_diagnoses  VARCHAR2(2000),
  heart_failure_diagnoses VARCHAR2(2000),
  exclusion_diagnoses     VARCHAR2(2000),
  CONSTRAINT dsrip_report_pqi90_78_PK PRIMARY KEY(report_period_start_dt, network, visit_id) USING INDEX COMPRESS
) COMPRESS BASIC;
