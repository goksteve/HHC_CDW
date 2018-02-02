prompt Creating table REF_ICD10_DIAGNOSES

exec dbm.drop_tables('REF_ICD10_DIAGNOSES');

CREATE TABLE ref_icd10_diagnoses
(
  icd10_code   VARCHAR2(16) NOT NULL,
  diagnosys    VARCHAR2(512) NOT NULL,
  description  VARCHAR2(2048),
  class_level  NUMBER(1) NOT NULL CONSTRAINT ref_icd10_diag_chk CHECK(class_level BETWEEN 1 AND 4),
  parent_code  VARCHAR2(16),
  load_dt      DATE DEFAULT SYSDATE NOT NULL,
  CONSTRAINT ref_icd10_diag_pk PRIMARY KEY(icd10_code),
  CONSTRAINT ref_icd10_diag_fk_parent FOREIGN KEY(parent_code) REFERENCES ref_icd10_diagnoses
  DEFERRABLE INITIALLY DEFERRED
);
 
GRANT SELECT ON ref_icd10_diagnoses TO PUBLIC;