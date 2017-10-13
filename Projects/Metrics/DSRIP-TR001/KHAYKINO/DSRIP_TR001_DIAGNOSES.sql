DROP TABLE dsrip_tr001_diagnoses PURGE;

CREATE TABLE dsrip_tr001_diagnoses
(
  network           VARCHAR2(3) NOT NULL,
  visit_id          NUMBER(12),
  coding_scheme_cd  VARCHAR2(6),
  icd_cd            VARCHAR2(100),
  is_primary        CHAR(1), 
  CONSTRAINT pk_tr001_diagnoses PRIMARY KEY(visit_id, coding_scheme_cd, icd_cd)
) ORGANIZATION INDEX;