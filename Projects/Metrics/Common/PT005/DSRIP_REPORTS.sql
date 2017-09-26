DROP TABLE dsrip_reports PURGE;

CREATE TABLE dsrip_reports
(
  report_cd               VARCHAR2(16) CONSTRAINT pk_dsrip_reports PRIMARY KEY,
  description             VARCHAR2(512) NOT NULL,
  denominator_inclusion   VARCHAR2(1024),
  denominator_exclusion   VARCHAR2(1024),
  numerator_1_inclusion   VARCHAR2(1024),
  numerator_2_inclusion   VARCHAR2(1024),
  numerator_3_inclusion   VARCHAR2(1024),
  numerator_4_inclusion   VARCHAR2(1024),
  numerator_5_inclusion   VARCHAR2(1024)
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
  NULL,
  NULL
);

INSERT INTO dsrip_reports(report_cd, description) VALUES('NQMC-010513', 'Medication management for people with asthma: percentage of members 5 to 85 years of age during the measurement year who were identified as having persistent asthma and who were dispensed an asthma controller medication that they remained on for at least 50% of their treatment period.');
INSERT INTO dsrip_reports(report_cd, description) VALUES('NQMC-010514', 'Medication management for people with asthma: percentage of members 5 to 85 years of age during the measurement year who were identified as having persistent asthma and who were dispensed an asthma controller medication that they remained on for at least 75% of their treatment period.');
INSERT INTO dsrip_reports(report_cd, description) VALUES('NQMC-010516', 'Hypertension: Controlling high blood pressure for people with diagnosis of hypertension and whose BP was adequately controlled: Percentage of members 18 to 85 years during the measurement year.');
INSERT INTO dsrip_reports(report_cd, description) VALUES('NQMC-010520', 'Comprehensive diabetes care: percentage of members 18 to 75 years of age with diabetes (type 1 and type 2) who had hemoglobin A1c (HbA1c) testing');
INSERT INTO dsrip_reports(report_cd, description) VALUES('NQMC-010521', 'Comprehensive diabetes care: percentage of members 18 to 75 years of age with diabetes (type 1 and type 2) whose most recent hemoglobin A1c (HbA1c) level is greater than 9.0% (poorly controlled)');
INSERT INTO dsrip_reports(report_cd, description) VALUES('NQMC-010524', 'Comprehensive diabetes care: percentage of members 18 to 75 years of age with diabetes (type 1 and type 2) who had an eye exam (retinal) performed');
INSERT INTO dsrip_reports(report_cd, description) VALUES('NQMC-010525', 'Comprehensive diabetes care: percentage of members 18 to 75 years of age with diabetes (type 1 and type 2) who received medical attention for nephropathy');
INSERT INTO dsrip_reports(report_cd, description) VALUES('NQMC-010537', 'Diabetes screening: Screening  for people with schizopherenia or bipolar disorder who are using antipsychotic medications: percentage of members 18 to 64 years of age during the measurement year');
INSERT INTO dsrip_reports(report_cd, description) VALUES('NQMC-010538', 'Diabetes Monitoring: Diabetes and Schizophrenia, Percentage of Members Age: 18 -64 (as of December 31) who had both An LDL-C AND HbA1C test');
INSERT INTO dsrip_reports(report_cd, description) VALUES('NQMC-010539', 'Cardiovascualr monitoring for people with cardiovascular disease and schizophrenia who had an LDL-C test: percentage of members 18 to 64 years of age during the measurement year.');
INSERT INTO dsrip_reports(report_cd, description) VALUES('NQMC-010547', 'Acute Bronchitis Treatment without Antibiotics, Avoidance of antibiotic treatment in adults with acute bronchitis: percentage of adults 18 to 64 years of age with a diagnosis of acute bronchitis who were not dispensed an antibiotic prescription ');
INSERT INTO dsrip_reports(report_cd, description) VALUES('NQMC-010929', 'Breast cancer screening: percentage of women 50 to 74 years of age who had a mammogram to screen for breast cancer.');
INSERT INTO dsrip_reports(report_cd, description) VALUES('NQMC-010930', 'Cervical cancer screening: percentage of women 21 to 64 years of age who were screened for cervical cancer.');

COMMIT;
