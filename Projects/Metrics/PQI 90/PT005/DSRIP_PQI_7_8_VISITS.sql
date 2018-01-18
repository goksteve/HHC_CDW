CREATE TABLE dsrip_pqi_7_8_visits
(
  network                    CHAR(3),
  report_period_start_dt     DATE,
  facility_id                NUMBER(12),
  patient_id                 NUMBER(12),
  patient_name               VARCHAR2(100 BYTE),
  patient_dob                DATE,
  prim_care_provider         VARCHAR2(60 BYTE),
  visit_id                   NUMBER(12)         NOT NULL,
  visit_number               VARCHAR2(40 BYTE),
  mrn                        VARCHAR2(40 BYTE),
  admission_dt               DATE,
  discharge_dt               DATE,
  visit_type_cd              CHAR(2 BYTE),
  fin_class                  VARCHAR2(100 BYTE),
  attending_emp_provider_id  NUMBER(12),
  resident_emp_provider_id   NUMBER(12),
  hypertension_code          VARCHAR2(100 BYTE),
  heart_failure_code         VARCHAR2(100 BYTE),
  CONSTRAINT dsrip_pqi_7_8_visits_pk PRIMARY KEY(network, visit_id) USING INDEX COMPRESS
) COMPRESS BASIC;
