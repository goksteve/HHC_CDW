DROP TABLE ref_drug_descriptions PURGE;

CREATE TABLE ref_drug_descriptions
(
  drug_description  VARCHAR2(512),
  drug_type_id      NUMBER(6),
  CONSTRAINT pk_ref_drug_descriptions PRIMARY KEY(drug_description)
) ORGANIZATION INDEX;

GRANT SELECT ON ref_drug_descriptions TO PUBLIC;
