exec dbm.drop_tables('DSRIP_PQI_7_8_VISITS');

CREATE TABLE dsrip_pqi_7_8_visits
(
  report_period_start_dt     DATE NOT NULL,
  facility_id                NUMBER(12) NOT NULL,
  patient_id                 NUMBER(12) NOT NULL,
  mrn                        VARCHAR2(40 BYTE),
  patient_name               VARCHAR2(100 BYTE),
  patient_dob                DATE,
  prim_care_provider         VARCHAR2(60 BYTE),
  visit_id                   NUMBER(12) CONSTRAINT dsrip_pqi_7_8_visits_pk PRIMARY KEY,
  visit_number               VARCHAR2(40 BYTE),
  admission_dt               DATE,
  discharge_dt               DATE,
  fin_class                  VARCHAR2(100 BYTE),
  attending_emp_provider_id  NUMBER(12),
  resident_emp_provider_id   NUMBER(12),
  hypertension_code          VARCHAR2(100 BYTE),
  heart_failure_code         VARCHAR2(100 BYTE)
) COMPRESS BASIC;
