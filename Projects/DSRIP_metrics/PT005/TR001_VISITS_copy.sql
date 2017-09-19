prompt Copying TR001_VISITS data from &1

exec xl.begin_action('Copying TR001_VISITS data from &1')

COPY FROM khaykino/Window#07@&1.DW01 APPEND tst_ok_tr001_visits USING -
SELECT -  
  network, -
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
FROM tr001_visits;

exec xl.end_action;