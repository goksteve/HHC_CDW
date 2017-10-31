DROP TABLE dsrip_report_tr001_qmed PURGE;

CREATE TABLE dsrip_report_tr001_qmed
(
  report_period_start_dt    DATE,
  network                   VARCHAR2(3),
  last_name                 VARCHAR2(107 CHAR),
  first_name                VARCHAR2(107 CHAR),
  dob                       DATE,
  prim_care_provider        VARCHAR2(60 BYTE),
  visit_id                  NUMBER(12),
  hospitalization_facility  VARCHAR2(100 BYTE),
  mrn                       VARCHAR2(30 CHAR),
  visit_number              VARCHAR2(40 BYTE),
  admission_dt              DATE,
  discharge_dt              DATE,
  follow_up_visit_id        NUMBER,
  follow_up_facility        VARCHAR2(100 BYTE),
  follow_up_visit_number    VARCHAR2(40 BYTE),
  follow_up_dt              DATE,
  bh_provider_info          VARCHAR2(4000 BYTE),
  payer                     VARCHAR2(2199 CHAR),
  payer_group               VARCHAR2(4000 CHAR),
  fin_class                 VARCHAR2(100 BYTE),
  follow_up_30_days         CHAR(1 CHAR),
  follow_up_7_days          CHAR(1 CHAR),
  CONSTRAINT pk_dsrip_report_tr001 PRIMARY KEY(report_period_start_dt, network, visit_id)
) COMPRESS BASIC;

GRANT SELECT ON dsrip_report_tr001_qmed TO PT009; 