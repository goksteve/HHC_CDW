CREATE OR REPLACE VIEW v_dsrip_report_pqi_7_8_qmed AS
SELECT
 -- 10-JAN-2018, OK: Created
  report_period_start_dt,
  network,
  SUBSTR(patient_name, 1, name_comma-1) last_name,
  SUBSTR(patient_name, name_comma+2) first_name,
  patient_dob dob,
  streetadr, apt_suite, city, state, zipcode, country, home_phone, day_phone,
  prim_care_provider,
  facility_name hospitalization_facility,
  mrn,
  visit_id,
  visit_number,
  admission_dt,
  discharge_dt,
  hypertension_code,
  heart_failure_code,
  fin_class,
  Insurance_Type(REGEXP_SUBSTR(payer_info, '^[^\]*')) payer_group,
  REGEXP_SUBSTR(payer_info, '[^\]*$') payer
FROM
(
  SELECT
    report_period_start_dt,
    network, facility_id, facility_name, 
    patient_id, patient_name,
    INSTR(patient_name, ',') name_comma,
    patient_dob, mrn, prim_care_provider,
    streetadr, apt_suite, city, state, zipcode, country, home_phone, day_phone,
    visit_id, visit_number, visit_type_cd, fin_class, 
    TRUNC(admission_dt) admission_dt,
    TRUNC(discharge_dt) discharge_dt,
    hypertension_code,
    heart_failure_code,
    (
      SELECT
        MIN(pm.payer_group||'\'||pm.payer_name) KEEP (DENSE_RANK FIRST ORDER BY CASE WHEN pm.payer_group = 'Medicaid' THEN 1 ELSE 2 END, vp.payer_rank) 
      FROM dsrip_pqi_7_8_payers vp
      JOIN pt008.payer_mapping pm ON pm.payer_id = vp.payer_id
      WHERE vp.visit_id = q.visit_id AND pm.network = q.network
      GROUP BY vp.visit_id
    ) payer_info
  FROM
  ( 
    SELECT
      v.report_period_start_dt,
      v.network,
      v.facility_id,
      fd.facility_name,
      v.patient_id,
      CASE
        WHEN mdm.onmlast IS NOT NULL AND mdm.onmfirst IS NOT NULL THEN mdm.onmlast||', '||mdm.onmfirst
        ELSE v.patient_name
      END patient_name,
      NVL(TO_DATE(mdm.dob, 'YYYY-MM-DD'), v.patient_dob) patient_dob,
      NVL(v.mrn, mdm.mrn) mrn,
      mdm.streetadr, mdm.apt_suite, mdm.city, mdm.state, mdm.zipcode, mdm.country, mdm.home_phone, mdm.day_phone,
      NVL(TO_CHAR(mdm.eid), v.network||'_'||v.patient_id) patient_gid,
      v.prim_care_provider, 
      v.visit_id,
      v.visit_number,
      v.admission_dt,
      v.discharge_dt,
      v.visit_type_cd,
      v.fin_class,
      v.hypertension_code,
      v.heart_failure_code,
      ROW_NUMBER() OVER
      (
        PARTITION BY v.network, v.visit_id
        ORDER BY
        CASE
          WHEN SUBSTR(mdm.facility_name, 1, 2) = fd.facility_code AND mdm.mrn = v.mrn THEN 1
          WHEN SUBSTR(mdm.facility_name, 1, 2) = fd.facility_code THEN 2
          ELSE 3
        END, eid
      ) mdm_rnum
    FROM dsrip_pqi_7_8_visits v
    JOIN facility_dimension fd ON fd.network = v.network AND fd.facility_id = v.facility_id
    LEFT JOIN dconv.mdm_qcpr_pt_02122016 mdm
      ON mdm.network = v.network AND TO_NUMBER(mdm.patientid) = v.patient_id AND mdm.epic_flag = 'N' AND mdm.dc_flag IS NULL
  ) q
  WHERE q.mdm_rnum = 1 AND q.patient_dob <= ADD_MONTHS(q.discharge_dt, -18*12)
);
