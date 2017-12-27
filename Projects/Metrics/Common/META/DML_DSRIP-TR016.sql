INSERT INTO dsrip_reports VALUES
(
  'DSRIP-TR016',
  'Diabetes Screening for People with Schizophrenia or Bipolar Disease who are using Antipsychotic Medications',
  'Patients, ages 18 - 64 years with Schizophrenia or Bipolar Disorder who filled an Antipsychotic Medication script',
  'Patients already diagnosed with Diabetes',
  'Patients who had a glucose or HbA1c test during the measurement year',
  NULL,
  NULL,
  NULL,
  NULL
);

INSERT INTO meta_logic VALUES('DSRIP-TR016', 1, 34, 'D', 'I');
INSERT INTO meta_logic VALUES('DSRIP-TR016', 2, 6, 'D', 'E');
INSERT INTO meta_logic VALUES('DSRIP-TR016', 3, 33, 'D', 'E');
INSERT INTO meta_logic VALUES('DSRIP-TR016', 4, 4, 'N', 'I');

INSERT INTO dsrip_reports VALUES
(
  'DSRIP-TR016-EPIC',
  'Diabetes Screening for People with Schizophrenia or Bipolar Disease who are using Antipsychotic Medications 0- EPIC data only',
  'Patients, ages 18 - 64 years with Schizophrenia or Bipolar Disorder who filled an Antipsychotic Medication script',
  'Patients already diagnosed with Diabetes',
  'Patients who had a glucose or HbA1c test during the measurement year',
  NULL,
  NULL,
  NULL,
  NULL
);

COMMIT;
