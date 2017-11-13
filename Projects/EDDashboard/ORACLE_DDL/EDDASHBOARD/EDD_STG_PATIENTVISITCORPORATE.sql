drop table edd_stg_patientvisitcorporate purge;

CREATE TABLE edd_stg_patientvisitcorporate
(
  FactPatientVisitCorporateKey  NUMBER(10) NOT NULL,
  VisitNumber                   VARCHAR2(100) NOT NULL,
  MiniRegToTriageMinutes        NUMBER(10),
  TriageToProviderMinutes       NUMBER(10),
  ProviderToDispositionMinutes  NUMBER(10),
  DispositionToExitMinutes      NUMBER(10),
  WaitingForTriageMinutes       NUMBER(10),
  WaitingForProviderMinutes     NUMBER(10),
  InTreatmentMinutes            NUMBER(10),
  DwellingMinutes               NUMBER(10),
  MiniRegToNowMinutes           NUMBER(10),
  InEDNow                       NUMBER(10),
  InEDToday                     NUMBER(10),
  Arrived                       NUMBER(10),
  LeftPriorToTriage             NUMBER(10),
  Triaged                       NUMBER(10),
  SeenByProvider                NUMBER(10),
  LeftWithoutBeingSeen          NUMBER(10),
  SeenAndReleased               NUMBER(10),
  InpatientAdmissionsFromED     NUMBER(10),
  ProviderToExitDischarged      NUMBER(10),
  ProviderToExitAdmitted        NUMBER(10),
  LeftAMAAfterSeeingProvider    NUMBER(10),
  ElopedAfterSeeingProvider     NUMBER(10),
  DoorToFirstProvider           NUMBER(10),
  DoorToExitDischarged          NUMBER(10),
  DoorToExitAdmitted            NUMBER(10),
  FacilityKey                   NUMBER(10) NOT NULL,
  ESIKey                        NUMBER(10) NOT NULL,
  AdmissionLocationKey          NUMBER(10),
  DestinationKey                NUMBER(10),
  CurrentEventStateKey          NUMBER(10),
  PatientKey                    NUMBER(10) NOT NULL,
  FirstNurseKey                 NUMBER(10),
  FirstAttendingKey             NUMBER(10),
  FirstProviderKey              NUMBER(10),
  CurrentNurseKey               NUMBER(10),
  CurrentAttendingKey           NUMBER(10),
  CurrentProviderKey            NUMBER(10),
  StatusKey                     NUMBER(10) NOT NULL,
  UserKey                       NUMBER(10) NOT NULL,
  DiagnosisKey                  NUMBER(10) NOT NULL,
  DispositionKey                NUMBER(10) NOT NULL,
  ChiefComplaintKey             NUMBER(10) NOT NULL,
  EDVisitOpenDTKey              NUMBER(10) NOT NULL,
  PatientArrivalDTKey           NUMBER(10) NOT NULL,
  TriageDTKey                   NUMBER(10) NOT NULL,
  DesignationDTKey              NUMBER(10) NOT NULL,
  FirstProviderAssignmentDTKey  NUMBER(10) NOT NULL,
  CurrentProviderAssignmentDTKey NUMBER(10) NOT NULL,
  DispositionDTKey              NUMBER(10) NOT NULL,
  PtExitDTKey                   NUMBER(10) NOT NULL,
  ClinicCodeKey                 NUMBER(10) NOT NULL,
  PatientVisitKey               NUMBER(10) NOT NULL,
  AdultPedsKey                  NUMBER(10) NOT NULL,
  TriageAdultPedsKey            NUMBER(10) NOT NULL,
  NotLeftWithoutBeingSeen       NUMBER(10),
  TransferredToOtherHospital    NUMBER(10),
  ArrivalTo1stProviderDischarged NUMBER(10),
  ArrivalTo1stProviderAdmitted  NUMBER(10),
  ArrivalToDispositionAdmitted  NUMBER(10),
  ArrivalToDispositionDischarged NUMBER(10),
  TriageToExitDischarged        NUMBER(10),
  TriageToExitAdmitted          NUMBER(10),
  load_dt                       DATE DEFAULT SYSDATE NOT NULL
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

CREATE INDEX idx_PatientVisitCorp_load_dt ON edd_STG_PatientVisitCorporate(lastprocesseddate);
