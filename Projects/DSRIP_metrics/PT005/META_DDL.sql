begin
  for r in
  (
    select table_name
    from user_tables
    where table_name like 'META%'
  )
  loop
    execute immediate 'drop table '||r.table_name||' cascade constraints purge';
  end loop;
end;
/

CREATE TABLE meta_condition_types
(
  condition_type_cd VARCHAR2(6) CONSTRAINT pk_meta_condition_types PRIMARY KEY,
  description       VARCHAR2(1023) NOT NULL
) TABLESPACE ud_users;

GRANT ALL ON meta_condition_types TO PUBLIC;

CREATE TABLE meta_measures
(
  measure_cd   VARCHAR2(20) CONSTRAINT pk_meta_measures PRIMARY KEY,
  description  VARCHAR2(1023) NOT NULL
) TABLESPACE ud_users;

GRANT ALL ON meta_measures TO PUBLIC;

CREATE TABLE meta_criteria
(
  criterion_id    NUMBER(6) CONSTRAINT pk_meta_measure_criteria PRIMARY KEY,
  criterion_cd    VARCHAR2(55) NOT NULL CONSTRAINT uk_meta_measure_criteria UNIQUE,
  description     VARCHAR2(1024)
) TABLESPACE ud_users;

GRANT ALL ON meta_criteria TO PUBLIC;

CREATE TABLE meta_measure_logic
(
  measure_cd          VARCHAR2(20),
  criterion_id        NUMBER(6),
  denom_numerator_ind CHAR(1) CONSTRAINT chk_denom_num_ind CHECK(denom_numerator_ind IN ('D', 'N')),
  include_exclude_ind CHAR(1) CONSTRAINT chk_include_exclude CHECK(include_exclude_ind IN ('I', 'E')),
  CONSTRAINT pk_meta_measure_logic PRIMARY KEY (measure_cd, criterion_id),
  CONSTRAINT fk_logic_measure FOREIGN KEY(measure_cd) REFERENCES meta_measures ON DELETE CASCADE,
  CONSTRAINT fk_logic_criteria FOREIGN KEY(criterion_id) REFERENCES meta_criteria
) TABLESPACE ud_users;

GRANT ALL ON meta_measure_logic TO PUBLIC;

CREATE TABLE meta_conditions
(
  criterion_id        NUMBER(6) NOT NULL,
  network             CHAR(3) DEFAULT 'ALL' NOT NULL
   CONSTRAINT chk_condition_network CHECK(network IN ('ALL','CBN','EPIC','GP1','GP2','NBN','NBX','QHN','SBN','SMN')),
  condition_type_cd   VARCHAR2(3) NOT NULL,
  qualifier           VARCHAR2(30) DEFAULT 'NONE' NOT NULL,
  value               VARCHAR2(255) NOT NULL,
  value_description   VARCHAR2(255),
  logical_operator    VARCHAR2(3) NOT NULL CONSTRAINT chk_condition_logical_operator
   CHECK(logical_operator IN ('AND','OR')),
  comparison_operator VARCHAR2(10) NOT NULL CONSTRAINT chk_comp_operator CHECK(comparison_operator IN ('=','<>','<','>','LIKE','NOT LIKE')),
hint_ind  char(1),
  CONSTRAINT pk_meta_measure_conditions PRIMARY KEY (criterion_id, condition_type_cd, network, qualifier, value),
  CONSTRAINT fk_condition_type FOREIGN KEY(condition_type_cd) REFERENCES meta_condition_types,
  CONSTRAINT fk_condition_criterion FOREIGN KEY(criterion_id) REFERENCES meta_criteria ON DELETE CASCADE
) ORGANIZATION INDEX TABLESPACE ud_users;

GRANT ALL ON meta_conditions TO PUBLIC;

CREATE TABLE meta_criteria_combo
(
  parent_criterion_id  NUMBER(6) NOT NULL,
  child_criterion_id   NUMBER(6) NOT NULL,
  logical_operator     VARCHAR2(3) NOT NULL CONSTRAINT chk_combo_logical_operator
   CHECK(logical_operator IN ('AND','OR')),
  CONSTRAINT pk_meta_criteria_combo PRIMARY KEY (parent_criterion_id, child_criterion_id),
  CONSTRAINT fk_combo_parent_criterion FOREIGN KEY(parent_criterion_id) REFERENCES meta_criteria,
  CONSTRAINT fk_combo_child_criterion FOREIGN KEY(child_criterion_id) REFERENCES meta_criteria
) ORGANIZATION INDEX TABLESPACE ud_users;

GRANT ALL ON meta_criteria_combo TO PUBLIC;
