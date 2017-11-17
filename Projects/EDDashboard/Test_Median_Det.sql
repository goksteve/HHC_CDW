SELECT
  facility_key,
  visit_number,
  t0 AS arrival_dt,
  esi_key,
  patient_name,
  patient_dob,
  disposition_id,
  t1 AS register_dt,
  t2 AS triage_dt,
  t3 AS first_provider_assignment_dt,
  t4 AS disposition_dt,
  t5 AS exit_dt,
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
  load_dt
FROM
(
  SELECT --+ use_hash(pv)
    pv.FacilityKey AS facility_key,
    pvc.VisitNumber AS visit_number,
    pvc.ESIKey AS esi_key,
    pv.PatientName AS patient_name,
    TO_DATE(pv.dob, 'YYYYMMDD') patient_dob,
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
  LEFT JOIN edd_dim_time t1 ON t1.DimTimeKey = pvc.EDVisitOpenDTKey
  LEFT JOIN edd_dim_time t2 on t2.DimTimeKey = pvc.TriageDTKey
  LEFT JOIN edd_dim_time t3 on t3.DimTimeKey = pvc.FirstProviderAssignmentDTKey
  LEFT JOIN edd_dim_time t4 on t4.DimTimeKey = pvc.DispositionDTKey
  LEFT JOIN edd_dim_time t5 on t5.DimTimeKey = pvc.PtExitDTKey
  where pvc.FacilityKey = 1 and pvc.VisitNumber = '1000141-21'
)
WHERE rnum = 1;
