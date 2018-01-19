EXEC dbm.drop_tables('MAP_DIAGNOSE_CODES');

CREATE TABLE map_diagnose_codes
(
   icd10_code   VARCHAR2(100 BYTE),
   icd9_code    VARCHAR2(100 BYTE),
   CONSTRAINT map_diagnose_codes_pk PRIMARY KEY (icd10_code, icd9_code)
) ORGANIZATION INDEX;

GRANT SELECT ON map_diagnose_codes TO PUBLIC;