CREATE TABLE meta_conditions
(
  criterion_id          NUMBER(6),
  network               CHAR(3) DEFAULT 'ALL'
   CONSTRAINT chk_metacondition_network CHECK (network IN ('ALL','CBN','GP1','GP2','NBN','NBX','QHN','SBN','SMN')), 
  qualifier             VARCHAR2(30) DEFAULT 'NONE',
  value                 VARCHAR2(255),
  value_description     VARCHAR2(255),
  condition_type_cd     VARCHAR2(3) NOT NULL
   CONSTRAINT chk_metacondition_type CHECK(condition_type_cd IN ('DI', 'EI', 'EN', 'MED', 'PI')),
  comparison_operator   VARCHAR2(10) DEFAULT '=' NOT NULL,
  include_exclude_ind   CHAR(1) DEFAULT 'I' NOT NULL,
   CONSTRAINT chk_metacond_inclexcl CHECK(include_exclude_ind IN ('I', 'E')),
  CONSTRAINT pk_meta_conditions PRIMARY KEY(criterion_id, network, qualifier, value),
  CONSTRAINT fk_meta_condition_criteria FOREIGN KEY(criterion_id) REFERENCES meta_criteria ON DELETE CASCADE 
) ORGANIZATION INDEX;

GRANT SELECT ON meta_conditions TO PUBLIC;
