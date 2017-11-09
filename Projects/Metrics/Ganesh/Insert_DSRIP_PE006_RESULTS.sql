prompt Populating DSRIP_PE006_RESULTS ...
set timing on
set sqlblanklines on

INSERT --+ parallel(4) 
INTO dsrip_pe006_results
WITH 
  dt AS 
  (
    SELECT --+ materialize
      SUBSTR(ORA_DATABASE_NAME, 1, 3) NETWORK,
			TRUNC(sysdate, 'MONTH') AS report_period_start_dt,
      ADD_MONTHS (TRUNC (SYSDATE, 'MONTH'), -24) begin_dt,
      TRUNC (SYSDATE, 'MONTH') end_dt
      FROM DUAL
  ),
  lkp AS 
  (
    SELECT --+ materialize
      dt.network,
      dt.begin_dt,
      dt.end_dt,
      mc.VALUE,
      mc.value_description,
      CASE
         WHEN UPPER (mc.value_description) LIKE '%SYS%' THEN 'S' -- systolic
         WHEN UPPER (mc.value_description) LIKE '%DIAS%' THEN 'D' -- diastolic
         ELSE 'C' -- combo
      END test_type
    FROM dt
    JOIN kollurug.meta_conditions mc
      ON     mc.network = dt.network
     AND mc.criterion_id = 13
     AND mc.include_exclude_ind = 'I'
   ),
  pcp_visits AS 
  (
    SELECT --+ materialize ordered use_hash(v vt vsvl ld vsp fc)
      dt.report_period_start_dt,
      dt.end_dt report_period_end_dt,
      v.visit_id,
      vt.name AS visit_type_name,
      v.financial_class_id,
      fc.name AS visit_financial_class,               
      vsp.payer_id,
      v.facility_id,
      v.admission_date_time,
      v.discharge_date_time,
      ld.clinic_code AS pcp_clinic_code, 
      v.patient_id,
      ROW_NUMBER() OVER(PARTITION BY v.visit_id ORDER BY vsvl.visit_segment_number, vsvl.location_id) rnum
    FROM dt
    JOIN ud_master.visit v
      ON v.admission_date_time >= dt.begin_dt AND v.admission_date_time < dt.end_dt
    JOIN ud_master.visit_type vt 
      ON vt.visit_type_id = v.visit_type_id
    JOIN ud_master.visit_segment_visit_location vsvl
      ON vsvl.visit_id = v.visit_id
    JOIN hhc_custom.hhc_location_dimension ld
      ON ld.location_id = vsvl.location_id
    JOIN kollurug.xx_pcp_codes pcp
      ON pcp.code = ld.clinic_code AND pcp.network = dt.network
    LEFT JOIN ud_master.visit_segment_payer vsp
      ON vsp.visit_id = v.visit_id AND vsp.visit_segment_number = 1 AND vsp.payer_number = 1
    LEFT JOIN ud_master.financial_class fc
      ON fc.financial_class_id = v.financial_class_id),
  rslt AS 
  (
    SELECT --+ use_hash(r evnt v)
      v.report_period_start_dt,
      v.report_period_end_dt,
      lkp.network,
      v.facility_id,
      v.pcp_clinic_code,
      v.patient_id,
      v.visit_id,
      v.visit_type_name,
      v.financial_class_id,
      v.visit_financial_class,               
      v.payer_id,
      v.admission_date_time,
      v.discharge_date_time,
      evnt.event_id,
      evnt.date_time,
      r.data_element_id,
      lkp.value_description,
      r.VALUE,
      CASE
        WHEN lkp.test_type = 'C' THEN TO_NUMBER (REGEXP_SUBSTR (r.VALUE,'^[^0-9]*([0-9]{2,})/([0-9]{2,})',1,1,'x',1))
        WHEN lkp.test_type = 'S' THEN TO_NUMBER (REGEXP_SUBSTR (r.VALUE,'^[^0-9]*([0-9]{2,})',1,'',1))
      END AS systolic_bp,
      CASE
        WHEN lkp.test_type = 'C' THEN TO_NUMBER (REGEXP_SUBSTR (r.VALUE,'^[^0-9]*([0-9]{2,})/([0-9]{2,})',1,1,'x',2))
        WHEN lkp.test_type = 'D' THEN TO_NUMBER (REGEXP_SUBSTR (r.VALUE,'^[^0-9]*([0-9]{2,})',1,1,'',1))
      END AS diastolic_bp   
    FROM lkp
    JOIN ud_master.result r
      ON r.data_element_id = lkp.VALUE
    AND cid >= 20150801000000
    JOIN ud_master.event evnt
      ON evnt.visit_id = r.visit_id
    AND evnt.event_id = r.event_id
    AND evnt.date_time >= lkp.begin_dt
    AND evnt.date_time < lkp.end_dt
    JOIN pcp_visits v
      ON v.visit_id = r.visit_id AND v.rnum = 1
  ),
  rslt_combo AS 
  (
    SELECT 
      g.report_period_start_dt,
      g.report_period_end_dt,
      g.network,
      g.facility_id,
      g.pcp_clinic_code,
      hc.description AS pcp_clinic_code_description,
      hc.service AS pcp_clinic_service,
      g.patient_id,
      g.visit_id,
      g.visit_type_name,
      g.admission_date_time,
      g.discharge_date_time,
      g.financial_class_id,
      g.visit_financial_class,               
      g.payer_id,
      g.date_time,
      g.event_id,
      g.systolic_bp,
      g.diastolic_bp,
      COUNT(1) OVER (PARTITION BY g.patient_id) elevated_cnt,
      ROW_NUMBER() OVER (PARTITION BY g.patient_id ORDER BY g.date_time DESC) rnum_per_patient
    FROM 
    (  
      SELECT 
        report_period_start_dt,
        report_period_end_dt,
        network,
        facility_id,
        pcp_clinic_code,
        patient_id,
        visit_id,
        visit_type_name,
        financial_class_id,
        visit_financial_class,               
        payer_id,
        admission_date_time,
        discharge_date_time,
        event_id,
        date_time,
        ROW_NUMBER() OVER (PARTITION BY patient_id, TRUNC (date_time) ORDER BY date_time DESC) rnum_per_day,
        MAX (systolic_bp) systolic_bp,
        MAX (diastolic_bp) diastolic_bp
      FROM rslt
      GROUP BY report_period_start_dt, report_period_end_dt, network, facility_id, pcp_clinic_code, patient_id, visit_id, visit_type_name, financial_class_id, visit_financial_class, payer_id,                         
              admission_date_time, discharge_date_time, date_time, event_id
      HAVING MAX (systolic_bp) BETWEEN 140 AND 311 AND MAX (diastolic_bp) BETWEEN 90 AND 284
    ) g
    LEFT JOIN hhc_custom.hhc_clinic_codes hc
      ON hc.code = g.pcp_clinic_code
    WHERE g.rnum_per_day = 1
  )
SELECT -- noparallel
  report_period_start_dt, report_period_end_dt, network, facility_id, pcp_clinic_code,pcp_clinic_code_description, pcp_clinic_service,
  patient_id, visit_id, visit_type_name, admission_date_time, discharge_date_time, financial_class_id, visit_financial_class,               
  payer_id, date_time, event_id, systolic_bp, diastolic_bp, elevated_cnt, rnum_per_patient
FROM rslt_combo
WHERE elevated_cnt > 1 
AND rnum_per_patient < 3;
commit;