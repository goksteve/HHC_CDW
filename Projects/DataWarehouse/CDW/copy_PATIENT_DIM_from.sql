define DB=&1

prompt Copying HHC_PATIENT_DIMENSION from &DB ... 
COPY FROM khaykino/Window_12@&DB.DW01 APPEND hhc_patient_dimension USING -
SELECT -
  SUBSTR(db.name, 1, 3) network, -
  t.patient_id, -
  t.patient, -
  t.medical_record_nbr, -
  t.sex, -
  t.age_group, -
  t.birthdate, -
  t.date_of_death, -
  t.address1, -
  t.address2, -
  t.city, -
  t.state, -
  t.country, -
  t.mailing_code, -
  t.marital_status, -
  t.race, -
  t.religion, -
  t.occupation, -
  t.employer, -
  t.social_security_nbr, -
  t.confidential_flag, -
  t.home_phone, -
  t.day_phone, -
  t.smoker_flag, -
  t.sec_lang_name, -
  t.block_code, -
  t.prim_care_provider -
FROM hhc_custom.hhc_patient_dimension t - 
CROSS JOIN v$database db;
