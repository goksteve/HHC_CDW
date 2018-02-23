CREATE OR REPLACE VIEW v_dsrip_report_tr002_023_qmed AS
WITH
  report_dates AS
  (
    SELECT --+ materialize
      NVL(TO_DATE(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER')), TRUNC(SYSDATE, 'MONTH')) report_dt,
      ADD_MONTHS(NVL(TO_DATE(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER')), TRUNC(SYSDATE, 'MONTH')), -24) start_dt
    FROM dual
  ),
  diab_diagnoses AS
  (
    SELECT --+ materialize 
      d.patient_key,
      d.onset_date,
      d.diag_code icd_code,
      d.problem_comments,
      mc.include_exclude_ind,
      ROW_NUMBER() OVER(PARTITION BY patient_key, include_exclude_ind ORDER BY d.onset_date DESC) rnum 
    FROM meta_conditions mc
    JOIN fact_patient_diagnoses d ON d.diag_code = mc.value 
    WHERE mc.criterion_id = 1
    AND d.status_id IN (0,6,7,8)
  ),
  pat_list AS
  (
    SELECT
      p.*,
      rd.*,
      v.visit_id,
      v.facility_key,
      v.admission_dt,
      v.discharge_dt,
      ROW_NUMBER() OVER(PARTITION BY p.network, p.patient_id ORDER BY v.admission_dt DESC) visit_rnum 
    FROM report_dates rd
    CROSS JOIN fact_visits v
    JOIN 
    (
      SELECT patient_key FROM diab_diagnoses WHERE include_exclude_ind = 'I'
      MINUS
      SELECT patient_key FROM diab_diagnoses WHERE include_exclude_ind = 'E'
    ) m
    ON m.patient_key = v.patient_key
    JOIN dim_patients p
      ON p.patient_key = m.patient_key 
     AND p.birthdate > ADD_MONTHS(rd.report_dt, -900)
     AND p.birthdate <= ADD_MONTHS(rd.report_dt, -216)
    WHERE v.admission_dt >= rd.start_dt AND v.admission_dt < rd.report_dt
  ) 
SELECT --+ parallel(32)
  pp.network,
  f.facility_name,
  pp.medical_record_number AS mrn,
  pp.name,
  pp.birthdate,
  pp.visit_id,
  pp.facility_key,
  pp.admission_dt,
  pp.discharge_dt,
  dd.onset_date,
  dd.icd_code,
  dd.problem_comments,
  r.a1c_final_orig_value,
  r.a1c_final_calc_value,
  CASE WHEN r.a1c_final_calc_value < 8 THEN 1 ELSE NULL END AS a1c_less_8,
  CASE WHEN r.a1c_final_calc_value >= 8 THEN 1 ELSE NULL END AS a1c_more_8,
  CASE WHEN r.a1c_final_calc_value >= 9 THEN 1 ELSE NULL END AS a1c_more_9,
  CASE WHEN (NVL(r.a1c_final_calc_value, 9)) >= 9 THEN 1 ELSE NULL END AS a1c_more_9_null,
  'DSRIP_TR002_023' AS dsrip_report,
  pp.report_dt,
  ROW_NUMBER() OVER(PARTITION BY pp.network, pp.patient_id ORDER BY r.result_dt DESC) result_rnum,
  TRUNC(SYSDATE) load_dt
FROM pat_list pp
JOIN diab_diagnoses dd
  ON dd.patient_key = pp.patient_key AND dd.rnum = 1
JOIN dim_hc_facilities f ON f.facility_key = pp.facility_key
LEFT JOIN fact_visit_metric_results r
  ON r.patient_key = pp.patient_key AND r.a1c_final_orig_value IS NOT NULL
WHERE pp.visit_rnum = 1;
