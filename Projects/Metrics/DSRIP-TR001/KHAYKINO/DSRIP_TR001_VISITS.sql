DROP TABLE dsrip_tr001_visits PURGE;

CREATE TABLE dsrip_tr001_visits
(
  report_period_start_dt     DATE NOT NULL,
  network                    VARCHAR2(3) NOT NULL,
  facility_id                NUMBER(12) NOT NULL,
  patient_id                 NUMBER(12) NOT NULL,
  patient_name               VARCHAR2(100),
  patient_dob                DATE,
  prim_care_provider         VARCHAR2(60),
  visit_id                   NUMBER(12),
  visit_number               VARCHAR2(40),
  mrn                        VARCHAR2(40),
  admission_dt               DATE,
  discharge_dt               DATE,
  visit_type_cd              CHAR(2),
  fin_class                  VARCHAR2(100),
  attending_emp_provider_id  NUMBER(12),
  resident_emp_provider_id   NUMBER(12),
  CONSTRAINT pk_tr001_visits PRIMARY KEY(visit_id)
) COMPRESS BASIC;
