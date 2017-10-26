SELECT
  q.*,
  SUBSTR(p.name, 1, INSTR(p.name, ',', 1) - 1) AS last_name,
  SUBSTR(p.name, INSTR(p.name, ',') + 1) AS first_name,
  TRUNC(p.birthdate) AS DOB,
  TRUNC(p.date_of_death) AS date_of_death,
  FLOOR((r.admission_date_time1 - p.birthdate)/365) AS AGE
FROM
(
  SELECT
    r.network, r.facility_id,
    r.pcp_clinic_code, r.pcp_clinic_code_description, r.pcp_clinic_service, 
    r.visit_id, r.visit_type_id, vt.name visit_type_name,
    r.financial_class_id, fc.name AS visit_financial_class,
    vsp.payer_id,
  --  r.admission_date_time, r.discharge_date_time,
    event_id, date_time, systolic_bp, diastolic_bp
  FROM dsrip_pe006_results r
  JOIN ud_master.patient p on p.patient_id = r.patient_id
  JOIN ud_master.visit_type vt on vt.visit_type_id = r.visit_type_id
  LEFT JOIN ud_master.patient_secondary_number psn
    ON psn.patient_id = r.patient_id
   AND psn.secondary_nbr_type_id =
   CASE 
    WHEN (r.network = 'GP1' AND r.facility_id = 1) THEN 13
    WHEN (r.network = 'GP1' AND r.facility_id IN (2, 4)) THEN 11
    WHEN (r.network = 'GP1' AND r.facility_id = 3) THEN 12
    WHEN (r.network = 'CBN' AND r.facility_id = 4) THEN 12
    WHEN (r.network = 'CBN' AND r.facility_id = 5) THEN 13
    WHEN (r.network = 'NBN' AND r.facility_id = 2) THEN 9
    WHEN (r.network = 'NBX' AND r.facility_id = 2) THEN 11
    WHEN (r.network = 'QHN' AND r.facility_id = 2) THEN 11
    WHEN (r.network = 'SBN' AND r.facility_id = 1) THEN 11
    WHEN (r.network = 'SMN' AND r.facility_id = 2) THEN 11
    WHEN (r.network = 'SMN' AND r.facility_id = 7) THEN 13
   END
   AND psn.secondary_nbr_id = 1
  LEFT JOIN ud_master.visit_segment_payer vsp
    ON vsp.visit_id = r.visit_id
   AND vsp.visit_segment_number = 1
   AND vsp.payer_number = 1
  LEFT JOIN ud_master.financial_class fc
   ON fc.financial_class_id = r.financial_class_id
)
PIVOT
(
--  max(admission_date_time) admission_date_time, max(discharge_date_time) discharge_date_time,
  max(visit_type_id) visit_type_id,
  max(visit_type_name) visit_type_name,
  max(pcp_clinic_code) pcp_clinic_code,
  max(pcp_clinic_code_description) pcp_clinic_code_description,
  max(pcp_clinic_service) pcp_clinic_service,
  max(facility_id) facility_id,
  max(financial_class_id),
  max(date_time) date_time,
  max(visit_id) visit_id,
  max(event_id) event_id,
  max(data_element_id) data_element_id,
  max(value_description) value_description,
  max(systolic_bp) AS systolic_bp,
  max(diastolic_bp) AS diastolic_bp
  for rnum_per_patient in (1,2)
) pv
JOIN ud_master.patient p on p.patient_id = pv.patient_id
LEFT JOIN 
(
  SELECT DISTINCT patient_id 
  FROM ud_master.problem_cmv cmv
  JOIN kollurug.meta_conditions mc
   ON mc.value = cmv.code AND mc.criterion_id = 3 AND mc.include_exclude_ind = 'I'
) prob_pat 
ON prob_pat.patient_id = r.patient_id;     
