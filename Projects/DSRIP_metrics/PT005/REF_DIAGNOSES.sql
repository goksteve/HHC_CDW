DROP TABLE tst_ok_stg_diagnoses PURGE;
DROP TABLE tst_ok_ref_diagnoses PURGE;

CREATE TABLE tst_ok_stg_diagnoses
(
  network_cd        CHAR(3),
  coding_scheme_cd  VARCHAR2(10),
  code              VARCHAR2(20),
  description       VARCHAR2(255)
) COMPRESS BASIC;

CREATE TABLE tst_ok_ref_diagnoses
(
  coding_scheme_cd  VARCHAR2(10) CONSTRAINT chk_diag_coding_scheme CHECK(coding_scheme_cd IN ('ICD-9', 'ICD-10')),
  code              VARCHAR2(20),
  description       VARCHAR2(255) NOT NULL,
  source_network    CHAR(3) NOT NULL,
  CONSTRAINT pk_tst_ok_ref_diagnoses PRIMARY KEY(coding_scheme_cd, code)
) ORGANIZATION INDEX;

CREATE OR REPLACE VIEW vw_tst_ok_diagnoses AS
SELECT
  coding_scheme_cd, code,
  MAX(description) KEEP (DENSE_RANK FIRST ORDER BY network_cd) description,
  MIN(network_cd) source_network
FROM tst_ok_stg_diagnoses
GROUP BY coding_scheme_cd, code;
