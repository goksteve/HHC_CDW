CREATE TABLE edd_stg_patientvisit_info
(
  PatientVisitKey   NUMBER(10) NOT NULL,
  FacilityKey       NUMBER(10) NOT NULL,
  VisitNumber       VARCHAR2(1000 CHAR) NOT NULL,
  ChiefComplaint    VARCHAR2(1000 CHAR),
  PatientComplaint  VARCHAR2(1000 CHAR),
  MRN               VARCHAR2(1000 CHAR),
  PatientName       VARCHAR2(1000 CHAR),
  sex               VARCHAR2(1000 CHAR),
  dob               VARCHAR2(1000 CHAR),
  CONSTRAINT pk_edd_stg_patientvisit_info PRIMARY KEY (PatientVisitKey)
) COMPRESS BASIC;

ALTER TABLE edd_stg_patientvisit_info ADD CONSTRAINT uk_edd_stg_pv_info UNIQUE(FacilityKey, VisitNumber);

GRANT SELECT ON edd_stg_patientvisit_info TO PUBLIC;
