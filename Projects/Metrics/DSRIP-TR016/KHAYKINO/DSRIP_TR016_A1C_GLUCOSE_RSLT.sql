DROP TABLE dsrip_tr016_a1c_glucose_rslt PURGE;

CREATE TABLE dsrip_tr016_a1c_glucose_rslt
(
  facility_id        NUMBER(12) NOT NULL,
  patient_id         NUMBER(12) NOT NULL,
  visit_id           NUMBER(12) NOT NULL,
  visit_number       VARCHAR(40),
  visit_type_id      NUMBER(12),
  visit_type         VARCHAR2(50),
  admission_dt       DATE,
  discharge_dt       DATE,
  test_type_id       NUMBER(6) NOT NULL,
  event_id           NUMBER(12) NOT NULL,
  result_dt          DATE NOT NULL,
  data_element_id    VARCHAR2(25) NOT NULL,
  data_element_name  VARCHAR2(120) NOT NULL,
  result_value       VARCHAR2(1023) NOT NULL,
  CONSTRAINT pk_dsrip_tr016_a1cglcs_rslt PRIMARY KEY(patient_id)
) COMPRESS BASIC ;

GRANT SELECT ON dsrip_tr016_a1c_glucose_rslt TO PUBLIC;