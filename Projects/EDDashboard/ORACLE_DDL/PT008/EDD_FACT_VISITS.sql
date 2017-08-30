exec dbm.drop_tables('EDD_FACT_VISITS');

CREATE TABLE edd_fact_visits
(
  facility_key                  NUMBER(10),
  visit_number                  VARCHAR2(100),
  arrival_dt                    DATE NOT NULL,
  esi_key                       NUMBER(1) NOT NULL,
  patient_name                  VARCHAR2(100),
  patient_gender_cd             CHAR(1),
  patient_dob                   DATE,                 
  patient_age_group_id          NUMBER(10),
  patient_mrn                   VARCHAR2(20),
  patient_complaint             VARCHAR2(1000),
  chief_complaint               VARCHAR2(1000),
  first_nurse_key               NUMBER(10),
  second_nurse_key              NUMBER(10),
  first_provider_key            NUMBER(10),
  second_provider_key           NUMBER(10),
  first_attending_key           NUMBER(10),
  second_attending_key          NUMBER(10),
  diagnosis_key                 NUMBER(10),
  disposition_key               NUMBER(10) NOT NULL,
  register_dt                   DATE,
  triage_dt                     DATE,
  first_provider_assignment_dt  DATE,
  disposition_dt                DATE,
  exit_dt                       DATE,
  progress_ind                  NUMBER(2),
  arrival_to_triage             NUMBER(10),
  arrival_to_first_provider     NUMBER(10),
  arrival_to_disposition        NUMBER(10),
  arrival_to_exit               NUMBER(10),
  triage_to_first_provider      NUMBER(10),
  triage_to_disposition         NUMBER(10),
  triage_to_exit                NUMBER(10),
  first_provider_to_disposition NUMBER(10),
  first_provider_to_exit        NUMBER(10),
  disposition_to_exit           NUMBER(10),
  dwell                         NUMBER,
  CONSTRAINT pk_edd_fact_visits PRIMARY KEY(facility_key, visit_number)
) COMPRESS BASIC;

ALTER TABLE edd_fact_visits ADD CONSTRAINT fk_edd_visit_facility FOREIGN KEY(facility_key) REFERENCES edd_dim_facilities;
ALTER TABLE edd_fact_visits ADD CONSTRAINT fk_edd_visit_esi FOREIGN KEY(esi_key) REFERENCES edd_dim_esi;
ALTER TABLE edd_fact_visits ADD CONSTRAINT fk_edd_visit_disposition FOREIGN KEY(disposition_key) REFERENCES edd_dim_dispositions;

GRANT SELECT ON edd_fact_visits TO PUBLIC;

CREATE INDEX idx_edd_fact_visits_arrival ON edd_fact_visits(arrival_dt, esi_key);

CREATE BITMAP INDEX bidx_edd_fact_visits_facility ON edd_fact_visits(facility_key);
CREATE BITMAP INDEX bidx_edd_fact_visits_esi ON edd_fact_visits(esi_key);
CREATE BITMAP INDEX bidx_edd_fact_visit_dispos ON edd_fact_visits(disposition_key);

EXEC DBMS_ERRLOG.CREATE_ERROR_LOG('EDD_FACT_VISITS','ERR_EDD_FACT_VISITS');

ALTER TABLE err_edd_fact_visits ADD entry_ts TIMESTAMP DEFAULT SYSTIMESTAMP;

GRANT SELECT ON err_edd_fact_visits TO PUBLIC;