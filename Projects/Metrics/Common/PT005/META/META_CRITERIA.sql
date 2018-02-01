CREATE TABLE meta_criteria
(
  criterion_id              NUMBER(6) CONSTRAINT pk_meta_lists PRIMARY KEY,
  criterion_cd              VARCHAR2(55) NOT NULL CONSTRAINT uk_meta_criteria UNIQUE,
  description               VARCHAR2(1024) NOT NULL
);

GRANT SELECT ON meta_criteria TO PUBLIC;
