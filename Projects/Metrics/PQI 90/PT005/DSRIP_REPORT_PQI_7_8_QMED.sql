exec dbm.drop_tables('DSRIP_REPORT_PQI_7_8_QMED');

CREATE TABLE dsrip_report_pqi_7_8_qmed
(
  REPORT_PERIOD_START_DT    DATE,
  NETWORK                   CHAR(3),
  LAST_NAME                 VARCHAR2(107),
  FIRST_NAME                VARCHAR2(107),
  DOB                       DATE,
  STREETADR                 VARCHAR2(75),
  APT_SUITE                 VARCHAR2(75),
  CITY                      VARCHAR2(50),
  STATE                     VARCHAR2(15),
  ZIPCODE                   VARCHAR2(10),
  COUNTRY                   VARCHAR2(50),
  HOME_PHONE                VARCHAR2(40),
  DAY_PHONE                 VARCHAR2(40),
  PRIM_CARE_PROVIDER        VARCHAR2(60),
  HOSPITALIZATION_FACILITY  VARCHAR2(100),
  MRN                       VARCHAR2(40),
  VISIT_ID                  NUMBER(12) NOT NULL,
  VISIT_NUMBER              VARCHAR2(40),
  ADMISSION_DT              DATE,
  DISCHARGE_DT              DATE,
  HYPERTENSION_CODE         VARCHAR2(100),
  HEART_FAILURE_CODE        VARCHAR2(100),
  FIN_CLASS                 VARCHAR2(100),
  PAYER_GROUP               VARCHAR2(256),
  PAYER                     VARCHAR2(256),
  CONSTRAINT dsrip_report_pqi_7_8_qmed_pk PRIMARY KEY(report_period_start_dt, network, visit_id) USING INDEX COMPRESS
) COMPRESS BASIC;
