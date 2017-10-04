ALTER SESSION ENABLE PARALLEL DML;

DROP TABLE ref_drug_names PURGE;

CREATE TABLE ref_drug_names
(
  drug_name     VARCHAR2(175),
  drug_type_id  NUMBER(6),
  CONSTRAINT pk_tst_drug_names PRIMARY KEY(drug_name, drug_type_id)
) ORGANIZATION INDEX
PARTITION BY LIST(drug_type_id)
(
  PARTITION type_5 VALUES(5),
  PARTITION type_22 VALUES(22),
  PARTITION type_24 VALUES(24),
  PARTITION type_28 VALUES(28),
  PARTITION type_33 VALUES(33),
  PARTITION type_34 VALUES(34)
);

GRANT SELECT ON ref_drug_names TO PUBLIC;

set timi on

INSERT --+ APPEND PARALLEL(16)
INTO tst_ok_drug_names
WITH
  nm AS
  (
    SELECT --+ materialize
      DISTINCT drug_name 
    FROM ref_prescriptions
  ), 
  cnd AS
  (
    SELECT --+ materialize
      DISTINCT
      cnd.value,
      cr.criterion_id drug_type_id
    FROM meta_criteria cr 
    JOIN meta_conditions cnd ON cnd.criterion_id = cr.criterion_id
    WHERE cr.criterion_cd LIKE 'MEDICATIONS%'
  )
SELECT --+ ordered
  DISTINCT n.drug_name, c.drug_type_id 
FROM nm n
JOIN cnd c ON n.drug_name LIKE c.value; 

COMMIT;
