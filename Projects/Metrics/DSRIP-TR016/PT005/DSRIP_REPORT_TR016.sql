DROP TABLE dsrip_report_tr016 PURGE;

CREATE TABLE dsrip_report_tr016
(
  report_period_start_dt        DATE NOT NULL,
  patient_gid                   VARCHAR2(44 BYTE),
  network                       VARCHAR2(3 BYTE),
  facility_id                   NUMBER,
  facility_name                 VARCHAR2(100 BYTE),
  patient_id                    NUMBER,
  patient_name                  VARCHAR2(100 BYTE),
  medical_record_number         VARCHAR2(512 BYTE),
  birthdate                     DATE,
  age                           NUMBER,
  street_address                VARCHAR2(1024 BYTE),
  apt_suite                     VARCHAR2(1024 BYTE),
  city                          VARCHAR2(50 BYTE),
  state                         VARCHAR2(50 BYTE),
  zip_code                      VARCHAR2(50 BYTE),
  prim_care_provider            VARCHAR2(60 BYTE),
  last_pcp_visit_dt             DATE,
  bh_diag_code                  VARCHAR2(30 BYTE),
  bh_diagnosis                  VARCHAR2(2048 BYTE),
  medication                    VARCHAR2(512 BYTE),
  visit_id                      NUMBER(12),
  visit_number                  VARCHAR2(40 BYTE),
  visit_type_id                 NUMBER(12),
  visit_type                    VARCHAR2(50 BYTE),
  admission_dt                  DATE,
  discharge_dt                  DATE,
  payer_group                   VARCHAR2(2048 BYTE),
  payer_id                      NUMBER(12),
  payer_name                    VARCHAR2(150 BYTE),
  test_type_id                  NUMBER(6),
  result_dt                     DATE,
  data_element_name	            VARCHAR2(120 BYTE),
  result_value                  VARCHAR2(1023 BYTE)
);

GRANT SELECT ON dsrip_report_tr016 TO PUBLIC;
