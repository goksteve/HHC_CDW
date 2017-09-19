DROP TABLE tst_ok_tr001_report PURGE;

DROP TABLE dsrip_report_tr001 PURGE;

CREATE TABLE dsrip_report_tr001
(
  report_period_start_dt    DATE,
  network                   VARCHAR2(3),
  last_name                 VARCHAR2(107 CHAR),
  first_name                VARCHAR2(107 CHAR),
  dob                       DATE,
  prim_care_provider        VARCHAR2(60 BYTE),
  visit_id                  NUMBER(12),
  hospitalization_facility  VARCHAR2(100 BYTE),
  mrn                       VARCHAR2(30 CHAR),
  visit_number              VARCHAR2(40 BYTE),
  admission_dt              DATE,
  discharge_dt              DATE,
  follow_up_visit_id        NUMBER,
  follow_up_facility        VARCHAR2(100 BYTE),
  follow_up_visit_number    VARCHAR2(40 BYTE),
  follow_up_dt              DATE,
  bh_provider_info          VARCHAR2(4000 BYTE),
  payer                     VARCHAR2(2199 CHAR),
  payer_group               VARCHAR2(4000 CHAR),
  fin_class                 VARCHAR2(100 BYTE),
  "30-day follow up"        CHAR(1 CHAR),
  "7-day follow up"         CHAR(1 CHAR),
  CONSTRAINT pk_dsrip_report_tr001 PRIMARY KEY(report_period_start_dt, network, visit_id)
);

INSERT INTO dsrip_report_tr001
SELECT
  date '2017-07-01' report_period_start_dt,
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
  "30-day follow up",
  "7-day follow up"
FROM
(
  SELECT
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
      FROM tst_ok_tr001_providers pr
      JOIN provider_dimension pd ON pd.provider_id = pr.provider_id
      WHERE pr.visit_id = q.follow_up_visit_id
      GROUP BY pr.visit_id
    ) bh_provider_info,
    (
      SELECT
        MIN(pm.payer_group||'\'||pm.payer_name) KEEP (DENSE_RANK FIRST ORDER BY CASE WHEN pm.payer_group = 'Medicaid' THEN 1 ELSE 2 END, vp.payer_rank) 
      FROM tst_ok_tr001_payers vp
      JOIN payer_mapping pm ON pm.payer_id = vp.payer_id
      WHERE vp.visit_id = q.follow_up_visit_id AND pm.network = q.network
      GROUP BY vp.visit_id
    ) payer_info,
    q.follow_up_fin_class,
    CASE WHEN q.follow_up_dt < q.discharge_dt+30 then 'Y' end "30-day follow up",
    CASE WHEN q.follow_up_dt < q.discharge_dt+7 then 'Y' end "7-day follow up"
  FROM
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
      FROM tst_ok_tr001_visits v
      JOIN facility_dimension fd ON fd.network = v.network AND fd.facility_id = v.facility_id
      LEFT JOIN dconv.mdm_qcpr_pt_02122016 mdm
        ON mdm.network = v.network AND TO_NUMBER(mdm.patientid) = v.patient_id AND mdm.epic_flag = 'N'
    )
    WHERE mdm_rnk = 1
  ) q
  WHERE q.visit_type_cd = 'IP'
  AND q.discharge_dt >= DATE '2017-07-01' and q.discharge_dt < DATE '2017-08-01'
  AND q.patient_dob <= ADD_MONTHS(q.discharge_dt, -72)
  AND (q.re_admission_dt IS NULL OR q.re_admission_dt >= q.discharge_dt+30)
);

COMMIT;

TRUNCATE TABLE dsrip_report_results;

INSERT INTO dsrip_report_results(report_cd, period_start_dt, network, facility_name, denominator, numerator_1, numerator_2)
SELECT 
  'DSRIP-TR001' report_cd, 
  report_period_start_dt,
  DECODE(GROUPING(network), 1, 'ALL', network) network,
  DECODE(GROUPING(hospitalization_facility), 1, 'ALL', hospitalization_facility) facility,
  COUNT(1) denomionator,
  COUNT("30-day follow up") numerator_1,
  COUNT("7-day follow up") numerator_2
FROM dsrip_report_tr001 r
GROUP BY GROUPING SETS((report_period_start_dt, network, hospitalization_facility),(report_period_start_dt, network),(report_period_start_dt));

COMMIT;