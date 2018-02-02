exec dbm.drop_tables('REF_DIAGNOSES');

CREATE TABLE ref_diagnoses
(
  coding_scheme   VARCHAR2(10 BYTE),
  code            VARCHAR2(100 BYTE),
  description     VARCHAR2(2000 BYTE),
  CONSTRAINT ref_diagnoses_pk PRIMARY KEY(coding_scheme, code)
) ORGANIZATION INDEX COMPRESS OVERFLOW
PARTITION BY LIST(coding_scheme)
(
  PARTITION icd10 VALUES ('ICD-10'),
  PARTITION icd9 VALUES ('ICD-9')
);

GRANT SELECT ON ref_diagnoses TO PUBLIC;
