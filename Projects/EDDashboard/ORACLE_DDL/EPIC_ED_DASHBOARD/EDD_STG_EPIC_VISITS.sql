CREATE TABLE edd_stg_epic_visits
(
  RN                              NUMBER(10),
  PAT_NAME                        VARCHAR2(250 BYTE),
  MRN                             VARCHAR2(50 BYTE),
  EMPI_NUMBER                     VARCHAR2(50 BYTE),
  BIRTH_DATE                      TIMESTAMP(3),
  AGE_AT_ARRIVAL                  NUMBER(10),
  PATIENT_SEX                     VARCHAR2(50 BYTE),
  PAT_CSN                         VARCHAR2(50 BYTE),
  LOCATION_ID                     VARCHAR2(50 BYTE),
  LOCATION_NAME                   VARCHAR2(250 BYTE),
  DEPARTMENT_ID                   VARCHAR2(50 BYTE),
  DEPARTMENT_NAME                 VARCHAR2(250 BYTE),
  ACUITY_NAME                     VARCHAR2(250 BYTE),
  ED_DISPOSITION_C                NUMBER(10),
  ED_DISPOSITION_NAME             VARCHAR2(50 BYTE),
  DISCH_DISP_C                    NUMBER(10),
  DISCHARGE_DISPO_NAME            VARCHAR2(250 BYTE),
  ARRIVED_TIME                    TIMESTAMP(3),
  TRIAGE_TIME                     TIMESTAMP(3),
  FIRST_PROVIDER_ASSIGNMENT_TIME  TIMESTAMP(3),
  DISPOSITION_TIME                TIMESTAMP(3),
  ED_DEPARTURE_TIME               TIMESTAMP(3),
  LOAD_DT                         DATE          DEFAULT sysdate               NOT NULL
)
COMPRESS BASIC 
PARTITION BY RANGE (LOAD_DT) INTERVAL(INTERVAL '1' DAY)
(
  PARTITION P_ORIGINAL VALUES LESS THAN (TO_DATE(' 2017-11-03 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
    COMPRESS BASIC  
);

GRANT SELECT ON edd_stg_epic_visits TO pt008;