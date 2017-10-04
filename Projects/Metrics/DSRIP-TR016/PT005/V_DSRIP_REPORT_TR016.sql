CREATE OR REPLACE VIEW v_dsrip_report_tr016 AS
WITH
  dt AS
  (
    SELECT --+ materialize
      NVL(TO_DATE(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER')), TRUNC(SYSDATE, 'MONTH')) report_dt,
      ADD_MONTHS(NVL(TO_DATE(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER')), TRUNC(SYSDATE, 'MONTH')), -12) year_back_dt
    FROM dual
  ),
  prescriptions AS
  (
    SELECT --+ materialize parallel(8)
      mdm.eid AS patient_mdm_eid,
      NVL(TO_CHAR(mdm.eid), rpr.network||'_'||rpr.patient_id) AS patient_gid,
      NVL(dnm.drug_type_id, dscr.drug_type_id) AS drug_type_id,
      MIN(pr.network) KEEP(DENSE_RANK FIRST ORDER BY pr.order_dt DESC) network,  
      MIN(rpr.facility_id) KEEP(DENSE_RANK FIRST ORDER BY pr.order_dt DESC, rpr.network) facility_id,  
      MIN(rpr.patient_id) KEEP(DENSE_RANK FIRST ORDER BY pr.order_dt DESC, rpr.network) patient_id,  
      MIN(NVL(dnm.drug_name, dscr.drug_description)) KEEP(DENSE_RANK FIRST ORDER BY rpr.order_dt DESC, rpr.network) medication,
      MIN(rpr.order_dt) AS start_dt,
      MAX(NVL(rpr.rx_dc_dt, DATE '9999-12-31')) AS end_dt
    FROM dt
    JOIN ref_prescriptions pr
      ON rpr.order_dt < dt.report_dt
    LEFT JOIN dconv.mdm_qcpr_pt_02122016 mdm
     ON mdm.network = rpr.network AND TO_NUMBER(mdm.patientid) = rpr.patient_id AND mdm.epic_flag = 'N'
    LEFT JOIN ref_drug_names dnm ON dnm.drug_name = rpr.drug_name 
    LEFT JOIN ref_drug_descriptions dscr ON dscr.drug_description = rpr.drug_description 
    WHERE dnm.drug_type_id IN (33, 34) OR dscr.drug_type_id IN (33, 34) -- Diabetes and Antipsychotic Medications
    GROUP BY mdm.eid, NVL(TO_CHAR(mdm.eid), rpr.network||'_'||rpr.patient_id), NVL(dnm.drug_type_id, dscr.drug_type_id)
  ),
  diabetes_diagnoses AS
  (
    SELECT --+ materialize parallel(8)
      NVL(TO_CHAR(mdm.eid), pd.network||'_'||pd.patient_id) patient_gid,
      MIN(pd.onset_date) onset_dt,
      MAX(pd.stop_date) stop_dt
    FROM patient_diag_dimension pd
    JOIN meta_conditions lkp
      ON lkp.qualifier = DECODE(pd.diag_coding_scheme, '5', 'ICD9', 'ICD10')
     AND lkp.value = pd.diag_code AND lkp.criterion_id = 6 -- DIAGNOSIS:DIABETES
    LEFT JOIN dconv.mdm_qcpr_pt_02122016 mdm
      ON mdm.network = pd.network AND TO_NUMBER(mdm.patientid) = pd.patient_id AND mdm.epic_flag = 'N'
    WHERE pd.diag_coding_scheme IN (5, 10) AND pd.current_flag = '1' AND pd.stop_date IS NULL
    GROUP BY NVL(TO_CHAR(mdm.eid), pd.network||'_'||pd.patient_id)
  ),
  a1c_glucose_tests AS
  (
    SELECT --+ materialize
      NVL(TO_CHAR(mdm.eid), a1c.network||'_'||a1c.patient_id) patient_gid,
      a1c.test_type_id,
      RANK() OVER(PARTITION BY NVL(TO_CHAR(mdm.eid), a1c.network||'_'||a1c.patient_id), a1c.test_type_id ORDER BY a1c.result_dt DESC) rnk,
      a1c.network,
      a1c.facility_id,
      a1c.visit_id,
      a1c.result_dt,
      a1c.result_value 
    FROM dt
    JOIN tst_ok_tr016_a1c_glucose_lvl a1c
      ON a1c.result_dt >= dt.year_back_dt AND a1c.result_dt < dt.report_dt 
    LEFT JOIN dconv.mdm_qcpr_pt_02122016 mdm
      ON mdm.network = a1c.network AND TO_NUMBER(mdm.patientid) = a1c.patient_id AND mdm.epic_flag = 'N'
  )
SELECT
  amed.patient_gid,
  amed.medication,
/*  network,
  amed.facility_id,
  facility_name
  patient_id
  patient_name
  mrn
  birthdate
  age
  pcp
  visit_id
  visit_type_id
  visit_type
  admission_date_time
  discharge_date_time
  medicaid_ind
  payer group
  payer_id
  payer_name
  plan_id
  plan_name
  icd_code*/
  agt.test_type_id,
  agt.result_dt,
  agt.result_value
FROM dt
JOIN prescriptions amed
  ON amed.drug_type_id = 34 -- Antipsychotic Medications
 AND amed.start_dt < dt.report_dt AND amed.end_dt > dt.year_back_dt -- taken in the last year
LEFT JOIN diabetes_diagnoses dd ON dd.patient_gid = amed.patient_gid
LEFT JOIN prescriptions dmed ON dmed.patient_gid = amed.patient_gid AND dmed.drug_type_id = 33 -- Diabetes Medications
LEFT JOIN a1c_glucose_tests agt ON agt.patient_gid = amed.patient_gid AND agt.rnk = 1
WHERE
(
  (dd.onset_dt IS NULL OR dd.onset_dt > dt.year_back_dt) -- no Diabetes prior last year
  AND (dmed.start_dt IS NULL OR dmed.start_dt > dt.year_back_dt) -- no Diabetes Medications taken prior last year
  OR agt.patient_gid IS NOT NULL  -- had A1c/Glucise screening
);

select * 

from v_dsrip_report_tr016;

/*
First Name
Last Name
DOB
Age
Is Medicaid patient? – Yes/No (in lieu of CIN) – if Medicaid exists as any of the patients payer, flag yes
MRN
Facility
Speciality
Dates of service for any BH providers involved in care (e.g. Social Worker, Psychologist, Psychiatrist)
Name of BH Provider
Payer
Plan
PCP - General Med
Date of last PCP Visit
*/
