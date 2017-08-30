CREATE TABLE edd_stg_patientvisitcorporate
(
  FactPatientVisitCorporateKey NUMBER(10,0) NOT NULL,
  VisitNumber NVARCHAR2(100) NOT NULL,
  MiniRegToTriageMinutes NUMBER(10,0),
  TriageToProviderMinutes NUMBER(10,0),
  ProviderToDispositionMinutes NUMBER(10,0),
  DispositionToExitMinutes NUMBER(10,0),
  WaitingForTriageMinutes NUMBER(10,0),
  WaitingForProviderMinutes NUMBER(10,0),
  InTreatmentMinutes NUMBER(10,0),
  DwellingMinutes NUMBER(10,0),
  MiniRegToNowMinutes NUMBER(10,0),
  InEDNow NUMBER(10,0),
  InEDToday NUMBER(10,0),
  Arrived NUMBER(10,0),
  LeftPriorToTriage NUMBER(10,0),
  Triaged NUMBER(10,0),
  SeenByProvider NUMBER(10,0),
  LeftWithoutBeingSeen NUMBER(10,0),
  SeenAndReleased NUMBER(10,0),
  InpatientAdmissionsFromED NUMBER(10,0),
  ProviderToExitDischarged NUMBER(10,0),
  ProviderToExitAdmitted NUMBER(10,0),
  LeftAMAAfterSeeingProvider NUMBER(10,0),
  ElopedAfterSeeingProvider NUMBER(10,0),
  DoorToFirstProvider NUMBER(10,0),
  DoorToExitDischarged NUMBER(10,0),
  DoorToExitAdmitted NUMBER(10,0),
  FacilityKey NUMBER(10,0) NOT NULL,
  ESIKey NUMBER(10,0) NOT NULL,
  AdmissionLocationKey NUMBER(10,0),
  DestinationKey NUMBER(10,0),
  CurrentEventStateKey NUMBER(10,0),
  PatientKey NUMBER(10,0) NOT NULL,
  FirstNurseKey NUMBER(10,0),
  FirstAttendingKey NUMBER(10,0),
  FirstProviderKey NUMBER(10,0),
  CurrentNurseKey NUMBER(10,0),
  CurrentAttendingKey NUMBER(10,0),
  CurrentProviderKey NUMBER(10,0),
  StatusKey NUMBER(10,0) NOT NULL,
  UserKey NUMBER(10,0) NOT NULL,
  DiagnosisKey NUMBER(10,0) NOT NULL,
  DispositionKey NUMBER(10,0) NOT NULL,
  ChiefComplaintKey NUMBER(10,0) NOT NULL,
  EDVisitOpenDTKey NUMBER(10,0) NOT NULL,
  PatientArrivalDTKey NUMBER(10,0) NOT NULL,
  TriageDTKey NUMBER(10,0) NOT NULL,
  DesignationDTKey NUMBER(10,0) NOT NULL,
  FirstProviderAssignmentDTKey NUMBER(10,0) NOT NULL,
  CurrentProviderAssignmentDTKey NUMBER(10,0) NOT NULL,
  DispositionDTKey NUMBER(10,0) NOT NULL,
  PtExitDTKey NUMBER(10,0) NOT NULL,
  ClinicCodeKey NUMBER(10,0) NOT NULL,
  PatientVisitKey NUMBER(10,0) NOT NULL,
  AdultPedsKey NUMBER(10,0) NOT NULL,
  TriageAdultPedsKey NUMBER(10,0) NOT NULL,
  NotLeftWithoutBeingSeen NUMBER(10,0),
  TransferredToOtherHospital NUMBER(10,0),
  ArrivalTo1stProviderDischarged NUMBER(10,0),
  ArrivalTo1stProviderAdmitted NUMBER(10,0),
  ArrivalToDispositionAdmitted NUMBER(10,0),
  ArrivalToDispositionDischarged NUMBER(10,0),
  TriageToExitDischarged NUMBER(10,0),
  TriageToExitAdmitted NUMBER(10,0)
) COMPRESS BASIC;

GRANT SELECT ON edd_stg_patientvisitcorporate TO PUBLIC;

COMMENT ON COLUMN EDD_STG_PatientVisitCorporate.ProviderToExitDischarged IS 'ORIGINAL NAME: ProvidertoExitDischargedMinutes';
COMMENT ON COLUMN EDD_STG_PatientVisitCorporate.ProviderToExitAdmitted IS 'ORIGINAL NAME: ProvidertoExitAdmittedMinutes';
COMMENT ON COLUMN EDD_STG_PatientVisitCorporate.LeftAMAAfterSeeingProvider IS 'ORIGINAL NAME: PatientsLeftAMAAfterSeeingProvider';
COMMENT ON COLUMN EDD_STG_PatientVisitCorporate.ElopedAfterSeeingProvider IS 'ORIGINAL NAME: PatientsWhoElopedAfterSeeingProvider';
COMMENT ON COLUMN EDD_STG_PatientVisitCorporate.DoorToFirstProvider IS 'ORIGINAL NAME: DoortoFirstProvider';
COMMENT ON COLUMN EDD_STG_PatientVisitCorporate.DoorToExitDischarged IS 'ORIGINAL NAME: DoortoExitDischargedMinutes';
COMMENT ON COLUMN EDD_STG_PatientVisitCorporate.DoorToExitAdmitted IS 'ORIGINAL NAME: DoortoExitAdmittedMinutes';
COMMENT ON COLUMN EDD_STG_PatientVisitCorporate.TransferredToOtherHospital IS 'ORIGINAL NAME: PatientsTransferredOtherHosp';
COMMENT ON COLUMN EDD_STG_PatientVisitCorporate.ArrivalTo1stProviderDischarged IS 'ORIGINAL NAME: ArrivalToFirstProviderDischargedMinutes';
COMMENT ON COLUMN EDD_STG_PatientVisitCorporate.ArrivalTo1stProviderAdmitted IS 'ORIGINAL NAME: ArrivalToFirstProviderAdmittedMinutes';
COMMENT ON COLUMN EDD_STG_PatientVisitCorporate.ArrivalToDispositionAdmitted IS 'ORIGINAL NAME: ArrivalToDispositionAdmittedMinutes';
COMMENT ON COLUMN EDD_STG_PatientVisitCorporate.ArrivalToDispositionDischarged IS 'ORIGINAL NAME: ArrivalToDispositionDischargedMinutes';
COMMENT ON COLUMN EDD_STG_PatientVisitCorporate.InEDNow IS 'ORIGINAL NAME: PatientsInEDNow';
COMMENT ON COLUMN EDD_STG_PatientVisitCorporate.InEDToday IS 'ORIGINAL NAME: PatientsInEDToday';
COMMENT ON COLUMN EDD_STG_PatientVisitCorporate.Arrived IS 'ORIGINAL NAME: PatientsArrived';
COMMENT ON COLUMN EDD_STG_PatientVisitCorporate.LeftPriorToTriage IS 'ORIGINAL NAME: PatientsLeftPriorToTriage';
COMMENT ON COLUMN EDD_STG_PatientVisitCorporate.Triaged IS 'ORIGINAL NAME: PatientsTriaged';
COMMENT ON COLUMN EDD_STG_PatientVisitCorporate.SeenByProvider IS 'ORIGINAL NAME: PatientsSeenByProvider';
COMMENT ON COLUMN EDD_STG_PatientVisitCorporate.LeftWithoutBeingSeen IS 'ORIGINAL NAME: PatientsLWBS';
COMMENT ON COLUMN EDD_STG_PatientVisitCorporate.NotLeftWithoutBeingSeen IS 'ORIGINAL NAME: PatientsNotLWBS';
COMMENT ON COLUMN EDD_STG_PatientVisitCorporate.SeenAndReleased IS 'ORIGINAL NAME: PatientsSeenAndReleased';
COMMENT ON COLUMN EDD_STG_PatientVisitCorporate.TriageToExitDischarged IS 'ORIGINAL NAME: TriageToExitDischargedMinutes';
COMMENT ON COLUMN EDD_STG_PatientVisitCorporate.TriageToExitAdmitted IS 'ORIGINAL NAME: TriageToExitAdmittedMinutes';

ALTER TABLE edd_STG_PatientVisitCorporate ADD CONSTRAINT pk_edd_stg_PVCorp PRIMARY KEY(FactPatientVisitCorporateKey) DISABLE;
ALTER TABLE edd_STG_PatientVisitCorporate ADD CONSTRAINT uk1_edd_stg_PVCorp UNIQUE(FacilityKey, VisitNumber);
ALTER TABLE edd_STG_PatientVisitCorporate ADD CONSTRAINT uk2_edd_stg_PVCorp UNIQUE(PatientVisitKey);
