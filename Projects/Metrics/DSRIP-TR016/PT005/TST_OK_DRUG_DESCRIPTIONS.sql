DROP TABLE tst_ok_drug_descriptions PURGE;

CREATE TABLE tst_ok_drug_descriptions
(
  drug_description CONSTRAINT pk_tst_drug_descriptions PRIMARY KEY,
  drug_type 
) ORGANIZATION INDEX AS
WITH
  dscr as
  (
    SELECT --+ materialize
      DISTINCT drug_description 
    FROM tst_ok_prescriptions
  )
SELECT --+ parallel(8)
  DISTINCT dscr.drug_description, REPLACE(cr.criterion_cd, 'MEDICATIONS:') drug_type
FROM meta_conditions lkp
JOIN meta_criteria cr ON cr.criterion_id = lkp.criterion_id
JOIN dscr on dscr.drug_description LIKE lkp.value 
WHERE lkp.criterion_id in (33, 34);

CREATE BITMAP INDEX bmi_prscr_descr_type 
ON tst_ok_prescriptions(dscr.drug_type)
FROM tst_ok_prescriptions pr, tst_ok_drug_descriptions dscr 
WHERE dscr.drug_description = pr.drug_description
LOCAL;
