INSERT INTO meta_changes(comments) VALUES('Adding meta-data for the PQI90 reports #7 and #8');

INSERT INTO dsrip_reports VALUES
(
  'PQI90-78',
  'Prevension Quality Composit',
  'Patients aged 18 and older hospitalized in the last month',
  NULL,
  'Patients who were hospitalized with one of the "Hypertension" diagnoses',
  'Patients who were hospitalized with one of the "Heart failure" diagnoses',
  NULL,
  NULL,
  NULL
);

INSERT INTO meta_criteria VALUES(38, 'DIAGNOSES:HYPERTENSION:PQI90-7', 'List of Hypertension Diagnoses included into the Numerator of the report PQI90 #7');  
INSERT INTO meta_criteria VALUES(39, 'DIAGNOSES:HEART FAILURE:PQI90-8', 'List of Heart Failure Diagnoses included into the Numerator of the report PQI90 #8');  

INSERT INTO meta_conditions
SELECT 38, 'ALL', 'ICD10', t.COLUMN_VALUE, 'Hypertension Diagnosis', 'DI', '=', 'I'
FROM TABLE(tab_v256('I10','I11.9','I12.9','I13.10')) t;

INSERT INTO meta_conditions
SELECT 39, 'ALL', 'ICD10', t.COLUMN_VALUE, 'Heart Failure Diagnosis', 'DI', '=', 'I'
FROM TABLE
(
  tab_v256
  (
    'I09.81','I50.30','I11.0','I50.31','I13.0','I50.32','I13.2','I50.33',
    'I50.1','I50.40','I50.20','I50.41','I50.21','I50.42','I50.22','I50.43','I50.23','I50.9'
  )
) t;

COMMIT;
