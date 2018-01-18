exec dbm.drop_tables('STG_ICD_CODES,STG_MAP_ICD_CODES,TST_PROBLEM_CMV');

prompt Creating table STG_ICD_CODES ... 
CREATE TABLE stg_icd_codes
(
  network         CHAR(3),
  coding_scheme   VARCHAR2(9),
  code            VARCHAR2(100),
  description     VARCHAR2(2048),
  cnt             NUMBER(10),
  CONSTRAINT stg_icd_codes_pk PRIMARY KEY(network, coding_scheme, code)
) ORGANIZATION INDEX COMPRESS OVERFLOW;

prompt Creating table STG_MAP_ICD_CODES ... 
CREATE TABLE stg_map_icd_codes
(
  network         CHAR(3),
  icd10_code      VARCHAR2(100),
  icd9_code       VARCHAR2(100),
  cnt             NUMBER(10),
  CONSTRAINT stg_map_icd_codes_pk PRIMARY KEY
  (
    network, icd10_code, icd9_code
  )
) ORGANIZATION INDEX COMPRESS;

prompt Creating table TST_PROBLEM_CMV ...
CREATE TABLE tst_problem_cmv
(
  network     CHAR(3),
  year_dt     DATE,
  cnt         NUMBER(10),
  icd9_nulls  NUMBER(10),
  icd10_nulls NUMBER(10)
);

exit