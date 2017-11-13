CREATE OR REPLACE VIEW vw_edd_epic_visits AS
SELECT
 -- 03-Nov-2017, OK: added LOAD_DT
 -- 20-Oct-2017, OK: created
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
  patient_mrn,
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
    THEN 32 -- on-time bit
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
  'EPIC' source,
  load_dt
FROM
(
  SELECT
    DECODE(v.location_id, 1500, 4, 1100, 6, 2400, 11, -1) AS facility_key,
    v.pat_csn||'_'||v.rn AS visit_number,
    NVL(REGEXP_REPLACE(v.acuity_name, '[^0-9]', ''), 5) esi_key,
    v.pat_name AS patient_name,
    SUBSTR(v.patient_sex, 1, 1) AS patient_gender_cd,
    CAST(v.birth_date AS DATE) AS patient_dob,
    v.age_at_arrival,
    v.mrn AS patient_mrn,
    v.ed_disposition_c AS disposition_id,
    CAST
    (
      LEAST
      (
        NVL(v.arrived_time, TIMESTAMP '9999-12-31 23:59:59'),
        NVL(v.triage_time, TIMESTAMP '9999-12-31 23:59:59'),
        NVL(v.first_provider_assignment_time, TIMESTAMP '9999-12-31 23:59:59'),
        NVL(v.disposition_time, TIMESTAMP '9999-12-31 23:59:59'),
        NVL(v.ed_departure_time, TIMESTAMP '9999-12-31 23:59:59')
      )
      AS DATE 
    ) t0,
    CAST(v.arrived_time AS DATE) t1,
    CAST(v.triage_time AS DATE) t2,
    CAST(v.first_provider_assignment_time AS DATE) t3,
    CAST(v.disposition_time AS DATE) t4,
    CAST(v.ed_departure_time AS DATE) t5,
    v.load_dt,
    ROW_NUMBER() OVER(PARTITION BY v.location_id, v.pat_csn, v.rn ORDER BY load_dt DESC) rnum
  FROM epic_ed_dashboard.edd_stg_epic_visits v
  WHERE v.load_dt > TO_DATE(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER'), 'YYYY-MM-DD HH24:MI:SS')
)
WHERE rnum = 1;
