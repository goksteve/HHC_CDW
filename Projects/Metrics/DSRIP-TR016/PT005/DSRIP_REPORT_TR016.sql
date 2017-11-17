DROP TABLE dsrip_report_tr016 PURGE;

CREATE TABLE dsrip_report_tr016
(
  report_period_start_dt        DATE NOT NULL,
  patient_gid                   VARCHAR2(44),
  network                       VARCHAR2(3),
  facility_id                   NUMBER,
  facility_name                 VARCHAR2(100),
  patient_id                    NUMBER,
  patient_name                  VARCHAR2(100),
  medical_record_number         VARCHAR2(512),
  birthdate                     DATE,
  age                           NUMBER,
  street_address                VARCHAR2(1024),
  apt_suite                     VARCHAR2(1024),
  city                          VARCHAR2(50),
  state                         VARCHAR2(50),
  zip_code                      VARCHAR2(50),
  medication                    VARCHAR2(512),
  visit_id                      NUMBER(12),
  visit_number                  VARCHAR2(40),
  visit_type_id                 NUMBER(12),
  visit_type                    VARCHAR2(50),
  admission_dt                  DATE,
  discharge_dt                  DATE,
  payer_group                   VARCHAR2(2048),
  payer_id                      NUMBER(12),
  payer_name                    VARCHAR2(150),
  test_type_id                  NUMBER(6),
  result_dt                     DATE,
  data_element_name	            VARCHAR2(120),
  result_value                  VARCHAR2(1023)
);

GRANT SELECT ON dsrip_report_tr016 TO PUBLIC;
