prompt Copying DSRIP_TR001_VISITS data from &1

CALL xl.begin_action('Copying DSRIP_TR001_VISITS data from &1');

COPY FROM khaykino/Window_12@&1.DW01 APPEND dsrip_tr001_visits USING -
SELECT - 
  report_period_start_dt, -
  NETWORK, -
  facility_id, -
  patient_id, -
  patient_name, -
  patient_dob, -
  prim_care_provider, -
  visit_id, -
  visit_number, -
  mrn, -
  admission_dt, -
  discharge_dt, -
  visit_type_cd, -
  fin_class -
FROM dsrip_tr001_visits;

CALL xl.end_action();