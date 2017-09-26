drop table tst_ok_tr001_visits purge;

CREATE TABLE tst_ok_tr001_visits
(
  NETWORK                    VARCHAR2(3 BYTE),
  FACILITY_ID                NUMBER(12),
  PATIENT_ID                 NUMBER(12),
  PATIENT_NAME               VARCHAR2(100 BYTE),
  PATIENT_DOB                DATE,
  PRIM_CARE_PROVIDER         VARCHAR2(60 BYTE),
  VISIT_ID                   NUMBER(12),
  VISIT_NUMBER               VARCHAR2(40 BYTE),
  MRN                        varchar2(30),
  ADMISSION_DT               DATE,
  DISCHARGE_DT               DATE,
  VISIT_TYPE_CD              CHAR(2 BYTE),
  FIN_CLASS                  VARCHAR2(100 BYTE),
  CONSTRAINT pk_tr001_visits PRIMARY KEY(network, visit_id)
) COMPRESS BASIC;
