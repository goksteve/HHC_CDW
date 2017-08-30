-- META_CONDITION_TYPES:
merge into META_CONDITION_TYPES t
using
(
  select 'EI' condition_type_cd, 'Data Element ID' description from dual union all
  select 'EN', 'Data Element Name' from dual union all
  select 'PI', 'Procedure ID' from dual union all
  select 'PN', 'Procedure Name' from dual union all
  select 'DI', 'Diagnose Category' from dual union all
  select 'MED', 'MEDICATION' from dual
) q
on (t.condition_type_cd = q.condition_type_cd)
when matched then update set t.description = q.description
when not matched then insert values(q.condition_type_cd, q.description);

COMMIT;

merge into meta_measures t
using
(
  select
    'NQMC_010537' as measure_cd,
  	'Diabetes screening: Screening  for people with schizopherenia or bipolar disorder who are using antipsychotic medications: percentage of members 18 to 64 years of age during the measurement year' as description
  from dual union all
  select
    'NQMC_010520',
    'Comprehensive diabetes care: percentage of members 18 to 75 years of age with diabetes (type 1 and type 2) who had hemoglobin A1c (HbA1c) testing'
  from dual union all
  select
    'NQMC_010521',
    'Comprehensive diabetes care: percentage of members 18 to 75 years of age with diabetes (type 1 and type 2) whose most recent hemoglobin A1c (HbA1c) level is greater than 9.0% (poorly controlled)'
  from dual union all
  select
    'NQMC_010524',
    'Comprehensive diabetes care: percentage of members 18 to 75 years of age with diabetes (type 1 and type 2) who had an eye exam (retinal) performed'
  from dual union all
  select
    'NQMC_010525',
    'Comprehensive diabetes care: percentage of members 18 to 75 years of age with diabetes (type 1 and type 2) who received medical attention for nephropathy'
  from dual
) q
on (t.measure_cd = q.measure_cd)
when matched then update set t.description = q.description
when not matched then insert values(q.measure_cd, q.description);

COMMIT;

delete from meta_conditions WHERE criterion_id in (4, 6, 9, 31, 32, 33, 34);
delete from meta_criteria WHERE criterion_id = 9;
commit;

MERGE INTO meta_criteria t 
USING
(
  SELECT 4 criterion_id, 'A1C' criterion_cd, 'Hemoglobin A1C test: for diabetes screening/monitoring' description FROM dual UNION ALL
  SELECT 6, 'DIAGNOSIS:DIABETES', 'List of all kinds of Diabetes' FROM dual UNION ALL
  SELECT 7, 'CARDIO_MON', 'Cardiovascualr monitoring for people with cardiovascular disease and schizophrenia who had an LDL-C test: percentage of members 18 to 64 years of age during the measurement year.' FROM dual UNION ALL
  SELECT 8, 'DIAB_EYE_EXAM', 'Diabetes with Eye Exam' FROM dual UNION ALL
  --SELECT 9, 'BIPOLAR_DISORDER', 'Bipolar Disorder: lookup' FROM dual UNION ALL -- this Criterion has been replaced with 33
  SELECT 10, 'LDL', 'Low-density lipoprotein (LDL) test : Percentage of Members Age: 18 -64 (as of December 31) who had both An LDL-C AND HbA1C test' FROM dual UNION ALL
  SELECT 11, 'ARV_DTTM', 'Patient Arrival Time' FROM dual UNION ALL
  SELECT 12, 'ARV_MODE', 'Mode Of Arrival To The Facility( Walking, Ambulance , Taxi)' FROM dual UNION ALL
  SELECT 13, 'BP', 'Blood Pressure' FROM dual UNION ALL
  SELECT 14, 'CC', 'The Primary Symptom That A Patient States As The Reason For Seeking Medical Care.' FROM dual UNION ALL
  SELECT 15, 'DBP', 'Diastolic Blood Pressure' FROM dual UNION ALL
  SELECT 16, 'DEP_DT', 'Patient Departure Date' FROM dual UNION ALL
  SELECT 17, 'DEP_DEST', 'Patient Departure Destination' FROM dual UNION ALL
  SELECT 18, 'DISP_DTTM', 'Patient Disposition Date Time' FROM dual UNION ALL
  SELECT 19, 'DISP_STAT', 'The Final Place Or Setting To Which The Patient Was Discharged On The Day Of Discharge' FROM dual UNION ALL
  SELECT 20, 'DX1', 'The Original Value Of The First Listed Diagnosis (Dx1) ' FROM dual UNION ALL
  SELECT 21, 'DX2', 'Secondary Diagnosis  Dx2' FROM dual UNION ALL
  SELECT 22, 'ESI', 'Emergency Severity Index' FROM dual UNION ALL
  SELECT 23, 'GUC_LVL', 'Glucose Level' FROM dual UNION ALL
  SELECT 24, 'MD_FIRST_DTTM', 'Medical Provider First Sart Time' FROM dual UNION ALL
  SELECT 25, 'MD_FIRST_ID', 'Medical First  Provider Id' FROM dual UNION ALL
  SELECT 26, 'MD_LAST_ID', 'Medical Last  Provider Id' FROM dual UNION ALL
  SELECT 27, 'PROC', 'Procedure(S) During Vst' FROM dual UNION ALL
  SELECT 28, 'REG_DTTM', 'Patient Registration' FROM dual UNION ALL
  SELECT 29, 'SBP', 'Systolic Blood Pressure' FROM dual UNION ALL
  SELECT 30, 'TRIAGE_DT', 'Triage Date' FROM dual UNION ALL
  SELECT 31, 'DIAGNOSIS:SCHIZOPHRENIA', 'List of schizophrenia diagnoses' FROM dual UNION ALL
  SELECT 32, 'DIAGNOSIS:BIPOLAR', 'List of bipolar disorder diagnoses' FROM dual UNION ALL
  SELECT 33, 'MEDICATIONS:DIABETES', 'List of medications for treating diabetes' FROM dual UNION ALL
  SELECT 34, 'MEDICATIONS:ANTIPSYCHOTIC', 'List of medications for treating psychotic disorders' FROM dual  
) q
ON (t.criterion_id = q.criterion_id)
WHEN MATCHED THEN UPDATE SET t.criterion_cd = q.criterion_cd, t.description = q.description
WHEN NOT MATCHED THEN INSERT VALUES(q.criterion_id, q.criterion_cd, q.description);

COMMIT;

-- META_MEASURE_LOGIC:
merge into META_MEASURE_LOGIC t
using
(
  select 'NQMC_010537' measure_cd, 34 criterion_id, 'D' denom_numerator_ind, 'I' include_exclude_ind from dual union all
  select 'NQMC_010537', 6, 'D', 'E' from dual union all
  select 'NQMC_010537', 33, 'D', 'E' from dual union all
  select 'NQMC_010537', 4, 'N', 'I' from dual
) q
on (t.measure_cd = q.measure_cd and t.criterion_id = q.criterion_id)
when matched then update set t.denom_numerator_ind = q.denom_numerator_ind, t.include_exclude_ind = q.include_exclude_ind
when not matched then insert values(q.measure_cd, q.criterion_id, q.denom_numerator_ind, q.include_exclude_ind);

commit;

-- META_CONDITIONS:
rem @@META_CONDITIONS_dml.sql
