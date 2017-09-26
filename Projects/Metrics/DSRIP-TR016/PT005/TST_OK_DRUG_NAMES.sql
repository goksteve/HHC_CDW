DROP TABLE tst_ok_drug_names PURGE;

CREATE TABLE tst_ok_drug_names
(
  drug_name CONSTRAINT pk_tst_drug_names PRIMARY KEY,
  drug_type
) ORGANIZATION INDEX
AS
WITH
  nm AS
  (
    SELECT --+ materialize
      DISTINCT drug_name 
    FROM tst_ok_prescriptions
  ) 
SELECT --+ parallel(8) 
  DISTINCT
  nm.drug_name, REPLACE(cr.criterion_cd, 'MEDICATIONS:') drug_type
FROM meta_conditions lkp
JOIN meta_criteria cr ON cr.criterion_id = lkp.criterion_id
JOIN nm ON nm.drug_name LIKE lkp.value 
WHERE lkp.criterion_id in (33, 34);

CREATE BITMAP INDEX bmi_prscr_name_type 
ON tst_ok_prescriptions(nm.drug_type)
FROM tst_ok_prescriptions pr, tst_ok_drug_names nm
WHERE nm.drug_name = pr.drug_name
LOCAL;
