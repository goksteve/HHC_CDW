--CREATE OR REPLACE VIEW vw_edd_visits AS
SELECT
 -- 19-Jul-2017, OK: created
  facility_key,
  visit_number,
  t0 arrival_dt,
  esi_key,
  patient_name,
  patient_gender_cd,
  patient_dob,
  CASE
    WHEN patient_dob > t0 THEN
      CASE
        WHEN TRUNC(MONTHS_BETWEEN(t0, patient_dob)/12) >= 55 THEN 3
        WHEN TRUNC(MONTHS_BETWEEN(t0, patient_dob)/12) < 18 THEN 2 
        ELSE 1
      END
    WHEN age_at_arrival IS NOT NULL THEN
      CASE
        WHEN age_at_arrival >= 55 THEN 3
        WHEN age_at_arrival < 18 THEN 2
        ELSE 1
      END
    ELSE -1
  END patient_age_group_id,
  patient_mrn,/*
  patient_complaint,
  chief_complaint,
  first_nurse_key,
  second_nurse_key,
  first_provider_key,
  second_provider_key,
  first_attending_key,
  second_attending_key,
  diagnosis_key,*/
--  disposition_key,
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
  CASE WHEN t5 > t4 THEN (t5-t4)*1440 END disposition_to_exit
FROM
(
  SELECT
    DECODE
    (
      location_id,
      1500, 4,
      1100, 6,
      2400, 11
    ) AS facility_key,
    pat_csn || DECODE(rn, 2, '_2') AS visit_number,
    NVL(REGEXP_REPLACE(acuity_name, '[^0-9]', ''), 5) esi_key,
    pat_name AS patient_name,
    SUBSTR(patient_sex, 1, 1) AS patient_gender_cd,
    birth_date AS patient_dob,
    age_at_arrival,
    mrn AS patient_mrn,/*
    pv.PatientComplaint AS patient_complaint,
    pv.ChiefComplaint AS chief_complaint,
    pvc.FirstNurseKey AS first_nurse_key,
    pvc.CurrentNurseKey AS second_nurse_key,
    pvc.FirstProviderKey AS first_provider_key,
    pvc.CurrentProviderKey AS second_provider_key,
    pvc.FirstAttendingKey AS first_attending_key,
    pvc.CurrentAttendingKey AS second_attending_key,
    pvc.DiagnosisKey AS diagnosis_key,*/
--    pvc.DispositionKey disposition_key,
    LEAST
    (
      NVL(arrived_time, DATE '9999-12-31'),
      NVL(triage_time, DATE '9999-12-31'),
      NVL(first_provider_assignment_time, DATE '9999-12-31'),
      NVL(disposition_time, DATE '9999-12-31'),
      NVL(ed_departure_time, DATE '9999-12-31')
    ) t0,
    CAST(arrived_time AS DATE) t1,
    CAST(triage_time AS DATE) t2,
    CAST(first_provider_assignment_time AS DATE) t3,
    CAST(disposition_time AS DATE) t4,
    CAST(ed_departure_time AS DATE) t5
  FROM edd_stg_epic_visits
);

GRANT SELECT ON vw_edd_visits TO PUBLIC;