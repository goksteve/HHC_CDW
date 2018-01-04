prompt Populating table DSRIP_TR016_PCP_INFO ...

TRUNCATE TABLE dsrip_tr016_pcp_info;

INSERT --+ parallel(8) 
INTO dsrip_tr016_pcp_info
SELECT
  network, patient_id, prim_care_provider,
  f.name pcp_visit_facility, pcp_visit_number, pcp_visit_dt
FROM
(
  SELECT
    SUBSTR(db.name, 1, 3) AS network,
    p.patient_id,
    p.prim_care_provider,
    v.visit_id, v.facility_id, v.visit_number pcp_visit_number, v.admission_date_time pcp_visit_dt,
    ROW_NUMBER() OVER(PARTITION BY p.patient_id ORDER BY v.admission_date_time DESC) rnum 
  FROM v$database db
  CROSS JOIN hhc_custom.hhc_patient_dimension p
  LEFT JOIN ud_master.visit v ON v.patient_id = p.patient_id
  LEFT JOIN ud_master.visit_segment_visit_location vl ON vl.visit_id = v.visit_id
  LEFT JOIN hhc_custom.hhc_location_dimension ld ON ld.location_id = vl.location_id AND ld.clinic_code <> 'N/A'
  LEFT JOIN khaykino.ref_clinic_codes cc ON cc.code = TO_NUMBER(ld.clinic_code) AND cc.category_id = 'PCP'
) pv 
LEFT JOIN ud_master.facility f ON f.facility_id = pv.facility_id
WHERE pv.rnum = 1;

COMMIT;