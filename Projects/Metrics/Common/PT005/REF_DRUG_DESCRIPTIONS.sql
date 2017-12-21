DROP TABLE ref_drug_descriptions PURGE;

CREATE TABLE ref_drug_descriptions
(
  drug_description  VARCHAR2(512),
  drug_type_id      NUMBER(6) NOT NULL,
  CONSTRAINT pk_ref_drug_descriptions PRIMARY KEY(drug_type_id, drug_description)
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

GRANT SELECT ON ref_drug_descriptions TO PUBLIC;
