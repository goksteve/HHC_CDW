CREATE OR REPLACE VIEW v_dsrip_report_tr001_qmed AS
SELECT
  report_period_start_dt,
  network,
  SUBSTR(patient_name, 1, name_comma-1) last_name,
  SUBSTR(patient_name, name_comma+2) first_name,
  patient_dob dob,
  prim_care_provider,
  visit_id,
  hospitalization_facility,
  mrn,
  visit_number,
  admission_dt,
  discharge_dt,
  follow_up_visit_id,
  follow_up_facility,
  follow_up_visit_number,
  follow_up_dt,
  bh_provider_info,
  REGEXP_SUBSTR(payer_info, '[^\]*$') payer,
  Insurance_Type(REGEXP_SUBSTR(payer_info, '^[^\]*')) payer_group,
  follow_up_fin_class fin_class,
  follow_up_30_days,
  follow_up_7_days
FROM
(
  SELECT
    dt.report_period_start_dt,
    q.network,
    q.patient_name,
    INSTR(q.patient_name, ',') name_comma,
    TRUNC(q.patient_dob) patient_dob,
    q.mrn,
    q.visit_id,
    q.visit_number,
    q.prim_care_provider,
    q.facility_name hospitalization_facility,
    q.admission_dt,
    q.discharge_dt,
    q.follow_up_visit_id,
    q.follow_up_visit_number,
    q.follow_up_dt,
    q.follow_up_facility,
    (
      SELECT MIN(pd.provider_name||' - '||pd.physician_service_name) KEEP (DENSE_RANK FIRST ORDER BY CASE WHEN UPPER(pd.physician_service_name) LIKE '%PSYCH%' THEN 1 WHEN pd.physician_service_name IS NOT NULL THEN 2 ELSE 3 END)
      FROM dsrip_tr001_providers pr
      JOIN provider_dimension pd ON pd.provider_id = pr.provider_id
      WHERE pr.visit_id = q.follow_up_visit_id
      GROUP BY pr.visit_id
    ) bh_provider_info,
    (
      SELECT
        MIN(pm.payer_group||'\'||pm.payer_name) KEEP (DENSE_RANK FIRST ORDER BY CASE WHEN pm.payer_group = 'Medicaid' THEN 1 ELSE 2 END, vp.payer_rank) 
      FROM dsrip_tr001_payers vp
      JOIN pt008.payer_mapping pm ON pm.payer_id = vp.payer_id
      WHERE vp.visit_id = q.visit_id AND pm.network = q.network
      GROUP BY vp.visit_id
    ) payer_info,
    q.follow_up_fin_class,
    CASE WHEN q.follow_up_dt < q.discharge_dt+30 THEN 'Y' END follow_up_30_days,
    CASE WHEN q.follow_up_dt < q.discharge_dt+7 THEN 'Y' END follow_up_7_days
  FROM
  (
    SELECT
      TRUNC(NVL(TO_DATE(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER')), SYSDATE), 'MONTH') report_period_start_dt
    FROM dual 
  ) dt
  JOIN
  (
    SELECT
      network, facility_id, facility_name, 
      patient_id, patient_name,
      patient_dob, mrn, prim_care_provider,
      visit_id, visit_number, visit_type_cd, fin_class, 
      TRUNC(admission_dt) admission_dt,
      TRUNC(discharge_dt) discharge_dt,
      LEAD(TRUNC(re_admission_dt) IGNORE NULLS) OVER(PARTITION BY patient_gid ORDER BY admission_dt) re_admission_dt,
      LEAD(TRUNC(follow_up_dt) IGNORE NULLS) OVER(PARTITION BY patient_gid ORDER BY admission_dt) follow_up_dt,
      LEAD(follow_up_visit_id IGNORE NULLS) OVER(PARTITION BY patient_gid ORDER BY admission_dt) follow_up_visit_id,
      LEAD(follow_up_visit_number IGNORE NULLS) OVER(PARTITION BY patient_gid ORDER BY admission_dt) follow_up_visit_number,
      LEAD(follow_up_facility IGNORE NULLS) OVER(PARTITION BY patient_gid ORDER BY admission_dt) follow_up_facility,
      LEAD(follow_up_fin_class IGNORE NULLS) OVER(PARTITION BY patient_gid ORDER BY admission_dt) follow_up_fin_class
    FROM
    ( 
      SELECT
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
        NVL(TO_CHAR(mdm.eid), v.network||'_'||v.patient_id) patient_gid,
        v.prim_care_provider, 
        v.visit_id,
        v.visit_number,
        v.admission_dt,
        v.discharge_dt,
        v.visit_type_cd,
        v.fin_class,
        CASE WHEN v.visit_type_cd = 'IP' THEN v.admission_dt END AS re_admission_dt,
        CASE WHEN v.visit_type_cd <> 'IP' THEN v.visit_id END AS follow_up_visit_id, 
        CASE WHEN v.visit_type_cd <> 'IP' THEN v.visit_number END AS follow_up_visit_number, 
        CASE WHEN v.visit_type_cd <> 'IP' THEN v.admission_dt END AS follow_up_dt, 
        CASE WHEN v.visit_type_cd <> 'IP' THEN fd.facility_name END AS follow_up_facility,
        CASE WHEN v.visit_type_cd <> 'IP' THEN v.fin_class END AS follow_up_fin_class,
        RANK() OVER
        (
          PARTITION BY v.network, v.visit_id
          ORDER BY
          CASE
            WHEN SUBSTR(mdm.facility_name, 1, 2) = fd.facility_code AND mdm.mrn = v.mrn THEN 1
            WHEN SUBSTR(mdm.facility_name, 1, 2) = fd.facility_code THEN 2
            ELSE 3
          END, eid
        ) mdm_rnk
      FROM dsrip_tr001_visits v
      JOIN facility_dimension fd ON fd.network = v.network AND fd.facility_id = v.facility_id
      LEFT JOIN dconv.mdm_qcpr_pt_02122016 mdm
        ON mdm.network = v.network AND TO_NUMBER(mdm.patientid) = v.patient_id AND mdm.epic_flag = 'N'
    )
    WHERE mdm_rnk = 1
  ) q
  ON q.discharge_dt >= ADD_MONTHS(dt.report_period_start_dt, -2)
  AND q.discharge_dt < ADD_MONTHS(dt.report_period_start_dt, -1)
  AND q.visit_type_cd = 'IP'
  AND q.patient_dob <= ADD_MONTHS(q.discharge_dt, -72)
  AND (q.re_admission_dt IS NULL OR q.re_admission_dt >= q.discharge_dt+30)
);
 