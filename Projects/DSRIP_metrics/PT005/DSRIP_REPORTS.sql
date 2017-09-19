DROP TABLE dsrip_reports PURGE;

CREATE TABLE dsrip_reports
(
  report_cd               VARCHAR2(16) CONSTRAINT pk_dsrip_reports PRIMARY KEY,
  report_description      VARCHAR2(255) NOT NULL,
  denominator_inclusion   VARCHAR2(1024),
  denominator_exclusion   VARCHAR2(1024),
  numerator_1_inclusion   VARCHAR2(1024),
  numerator_2_inclusion   VARCHAR2(1024),
  numerator_3_inclusion   VARCHAR2(1024),
  numerator_4_inclusion   VARCHAR2(1024)
);

INSERT INTO dsrip_reports VALUES
(
  'DSRIP-TR001',
  'Follow-up post Psychiatric Hospitalization',
  'Patients aged 6 and older discharged from a hospital after being hospitalized with one of the Primary Psychiatric diagnoses, which does not include Substance Abuse diagnoses',
  NULL,
  'Patients who came for a follow-up visit to a Behavioral Health provider within 30 days of discharge from the hospital',
  'Patients who came for a follow-up visit to a Behavioral Health provider within 7 days of discharge from the hospital',
  NULL,
  NULL
);

INSERT INTO dsrip_reports VALUES
(
  'DSRIP-TR016',
  'Diabetes Screening for People with Schizophrenia or Bipolar Disease who are using Antipsychotic Medications',
  'Patients, ages 18 - 64 years with Schizophrenia or Bipolar Disorder who filled an Antipsychotic Medication script',
  'Patients already diagnosed with Diabetes',
  'Patients who had a glucose or HbA1c test during the measurement year',
  NULL,
  NULL,
  NULL
);

COMMIT;
