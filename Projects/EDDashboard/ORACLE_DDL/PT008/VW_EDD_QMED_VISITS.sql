CREATE OR REPLACE VIEW vw_edd_qmed_visits AS
SELECT
 -- 09-Nov-2017, OK: used ROW_NUMBER()
 -- 23-Oct-2017, OK: added "QMED" to the view name and used EDD_QMED_DIMENSIONS
 -- 08-Jun-2017, OK: created
 -- 26-Jun-2017, OK: added column VISIT_KEY
  facility_key,
  visit_number,
  t0 AS arrival_dt,
  esi_key,
  patient_name,
  patient_gender_cd,
  patient_dob,
  CASE
    WHEN age_group_id IN (-1, 1) AND TRUNC(MONTHS_BETWEEN(t0, patient_dob)/12) >= 55 THEN 3
    WHEN age_group_id = -1 AND TRUNC(MONTHS_BETWEEN(t0, patient_dob)/12) < 18 THEN 2 
    ELSE age_group_id
  END patient_age_group_id,
  patient_mrn,
  patient_complaint,
  chief_complaint,
  first_nurse_key,
  second_nurse_key,
  first_provider_key,
  second_provider_key,
  first_attending_key,
  second_attending_key,
  diagnosis_key,
  disposition_id,
  t1 AS register_dt,
  t2 AS triage_dt,
  t3 AS first_provider_assignment_dt,
  t4 AS disposition_dt,
  t5 AS exit_dt,
  NVL2(t1, 1, 0) + NVL2(t2, 2, 0) + NVL2(t3, 4, 0) + NVL2(t4, 8, 0) + NVL2(t5, 16, 0) + 
  CASE
    WHEN t3 > t2 AND
    (
      esi_key = 1 AND (t3-t2) <= 1/1440 -- one minute
      OR esi_key = 2 AND (t3-t2) < 1/48 -- half an hour
      OR esi_key = 3 AND (t3-t2) < 1/12 -- 2 hours
      OR esi_key = 4 AND (t3-t2) < 1/6  -- 4 hours
      OR esi_key = 5 AND (t3-t2) < 1    -- 1 day
    )
    THEN 32
    ELSE 0
  END progress_ind,
  CASE WHEN t2 > t0 THEN (t2-t0)*1440 END arrival_to_triage,
  CASE WHEN t3 > t0 THEN (t3-t0)*1440 END arrival_to_first_provider,
  CASE WHEN t4 > t0 THEN (t4-t0)*1440 END arrival_to_disposition,
  CASE WHEN t5 > t0 THEN (t5-t0)*1440 END arrival_to_exit,
  CASE WHEN t3 > t2 THEN (t3-t2)*1440 END triage_to_first_provider,
  CASE WHEN t4 > t2 THEN (t4-t2)*1440 END triage_to_disposition,
  CASE WHEN t5 > t2 THEN (t5-t2)*1440 END triage_to_exit,
  CASE WHEN t4 > t3 THEN (t4-t3)*1440 END first_provider_to_disposition,
  CASE WHEN t5 > t3 THEN (t5-t3)*1440 END first_provider_to_exit,
  CASE WHEN t5 > t4 THEN (t5-t4)*1440 END disposition_to_exit,
  dwell, -- 'Minutes of Dwell (OK: unreliable)'
  'QMED' source,
  load_dt
FROM
(
  SELECT --+ use_hash(pv)
    pv.FacilityKey AS facility_key,
    pvc.VisitNumber AS visit_number,
    pvc.ESIKey AS esi_key,
    pv.PatientName AS patient_name,
    NVL(pv.sex, 'U') AS patient_gender_cd,
    TO_DATE(pv.dob, 'YYYYMMDD') patient_dob,
    DECODE(pvc.AdultPedsKey, -1, CASE WHEN pvc.TriageAdultPedsKey IN (1, 2) THEN pvc.TriageAdultPedsKey ELSE -1 END, pvc.AdultPedsKey) age_group_id,
    pv.mrn AS patient_mrn,
    pv.PatientComplaint AS patient_complaint,
    pv.ChiefComplaint AS chief_complaint,
    pvc.FirstNurseKey AS first_nurse_key,
    pvc.CurrentNurseKey AS second_nurse_key,
    pvc.FirstProviderKey AS first_provider_key,
    pvc.CurrentProviderKey AS second_provider_key,
    pvc.FirstAttendingKey AS first_attending_key,
    pvc.CurrentAttendingKey AS second_attending_key,
    pvc.DiagnosisKey AS diagnosis_key,
    pvc.DispositionKey disposition_id,
    NVL
    (
      t1.date_,
      LEAST
      (
        NVL(t2.date_, DATE '9999-12-31'),
        NVL(t3.date_, DATE '9999-12-31'),
        NVL(t4.date_, DATE '9999-12-31'),
        NVL(t5.date_, DATE '9999-12-31')
      )
    ) t0,
    t1.date_ t1,
    t2.date_ t2,
    t3.date_ t3,
    t4.date_ t4,
    t5.date_ t5,
    NVL(pvc.DwellingMinutes, 0) dwell,
    ROW_NUMBER() OVER(PARTITION BY pvc.PatientVisitKey ORDER BY pvc.load_dt DESC, pv.load_dt DESC) rnum,
    pvc.load_dt
  FROM eddashboard.edd_stg_PatientVisitCorporate pvc
  LEFT JOIN eddashboard.edd_stg_PatientVisit_info pv ON pv.PatientVisitKey = pvc.PatientVisitKey
--  LEFT JOIN edd_qmed_dispositions d ON d.DispositionKey = pvc.DispositionKey
  LEFT JOIN edd_dim_time t1 ON t1.DimTimeKey = pvc.EDVisitOpenDTKey
  LEFT JOIN edd_dim_time t2 on t2.DimTimeKey = pvc.TriageDTKey
  LEFT JOIN edd_dim_time t3 on t3.DimTimeKey = pvc.FirstProviderAssignmentDTKey
  LEFT JOIN edd_dim_time t4 on t4.DimTimeKey = pvc.DispositionDTKey
  LEFT JOIN edd_dim_time t5 on t5.DimTimeKey = pvc.PtExitDTKey
  WHERE pvc.load_dt > TO_DATE(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER'), 'YYYY-MM-DD HH24:MI:SS') 
)
WHERE rnum = 1;

GRANT SELECT ON vw_edd_visits TO PUBLIC;