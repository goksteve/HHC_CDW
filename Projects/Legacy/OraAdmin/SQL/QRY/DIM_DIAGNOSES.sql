exec dbm.drop_tables('DIM_DIAGNOSES');

CREATE TABLE dim_Diagnoses
(
  DiagnosisKey NUMBER(10,0) CONSTRAINT pk_diagnoses PRIMARY KEY,
  Diagnosis NVARCHAR2(1000)
) ORGANIZATION INDEX;

GRANT SELECT ON DIM_Diagnoses TO PUBLIC;
