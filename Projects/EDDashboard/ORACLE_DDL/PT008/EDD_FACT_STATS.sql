exec dbm.drop_tables('EDD_FACT_STATS,ERR_EDD_FACT_STATS');

CREATE TABLE edd_fact_stats
(
  visit_start_dt                 DATE,
  facility_key                   NUMBER(10),
  esi_key                        NUMBER(10),
  patient_age_group_id           NUMBER(10),
  patient_gender_cd              CHAR(1),
  disposition_key                NUMBER(10),
  progress_ind                   NUMBER(2),
  num_of_visits                  NUMBER(10),
  arrival_to_triage              NUMBER(10),
  arrival_to_first_provider      NUMBER(10),
  arrival_to_disposition         NUMBER(10),
  arrival_to_exit                NUMBER(10),
  triage_to_first_provider       NUMBER(10),
  triage_to_disposition          NUMBER(10),
  triage_to_exit                 NUMBER(10),
  first_provider_to_disposition  NUMBER(10),
  first_provider_to_exit         NUMBER(10),
  disposition_to_exit            NUMBER(10),
  dwell                          NUMBER
) COMPRESS BASIC;

GRANT SELECT ON edd_fact_stats TO PUBLIC;

ALTER TABLE edd_fact_stats ADD CONSTRAINT pk_edd_fact_stats PRIMARY KEY(visit_start_dt, facility_key, esi_key, patient_age_group_id, patient_gender_cd, disposition_key, progress_ind) USING INDEX COMPRESS;
ALTER TABLE edd_fact_stats ADD CONSTRAINT chk_edd_stats_gender_code CHECK(patient_gender_cd IN ('M','F','U'));
ALTER TABLE edd_fact_stats ADD CONSTRAINT chk_edd_stats_progress CHECK(progress_ind BETWEEN 1 AND 63);

CREATE BITMAP INDEX bidx_edd_fact_stats_facility ON edd_fact_stats(facility_key);
CREATE BITMAP INDEX bidx_edd_fact_stats_age ON edd_fact_stats(patient_age_group_id);
CREATE BITMAP INDEX bidx_edd_fact_stats_gender ON edd_fact_stats(patient_gender_cd);
CREATE BITMAP INDEX bidx_edd_fact_stats_progress ON edd_fact_stats(progress_ind);
CREATE BITMAP INDEX bidx_edd_fact_stats_esi ON edd_fact_stats(esi_key);
CREATE BITMAP INDEX bidx_edd_fact_stats_disp ON edd_fact_stats(disposition_key);

ALTER TABLE edd_fact_stats ADD CONSTRAINT fk_edd_stats_date FOREIGN KEY(visit_start_dt) REFERENCES edd_dim_time(date_);
ALTER TABLE edd_fact_stats ADD CONSTRAINT fk_edd_stats_facility FOREIGN KEY(facility_key) REFERENCES edd_dim_facilities;
ALTER TABLE edd_fact_stats ADD CONSTRAINT fk_edd_stats_esi FOREIGN KEY(esi_key) REFERENCES edd_dim_esi;
ALTER TABLE edd_fact_stats ADD CONSTRAINT fk_edd_stats_age FOREIGN KEY(patient_age_group_id) REFERENCES edd_dim_age_groups;
ALTER TABLE edd_fact_stats ADD CONSTRAINT fk_edd_stats_disposition FOREIGN KEY(disposition_key) REFERENCES edd_dim_dispositions;

EXEC DBMS_ERRLOG.CREATE_ERROR_LOG('EDD_FACT_STATS','ERR_EDD_FACT_STATS');

ALTER TABLE err_edd_fact_stats ADD entry_ts TIMESTAMP DEFAULT SYSTIMESTAMP;

GRANT SELECT ON err_edd_fact_stats TO PUBLIC;