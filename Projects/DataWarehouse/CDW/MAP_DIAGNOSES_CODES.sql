EXEC dbm.drop_tables('MAP_DIAGNOSES_CODES');

CREATE TABLE map_diagnoses_codes
(
   icd10_code   VARCHAR2(100 BYTE),
   icd9_code    VARCHAR2(100 BYTE),
   CONSTRAINT map_diagnose_codes_pk PRIMARY KEY (icd10_code, icd9_code)
) ORGANIZATION INDEX;

GRANT SELECT ON map_diagnoses_codes TO PUBLIC;