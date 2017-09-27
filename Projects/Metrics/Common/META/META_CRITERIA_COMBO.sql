CREATE TABLE meta_criteria_combo
(
  parent_criterion_id NUMBER(3),
  child_criterion_id  NUMBER(3),
  include_exclude_ind CHAR(1) NOT NULL CONSTRAINT chk_metalistcombo_logicalopr CHECK (include_exclude_ind IN ('I', 'E')),
  CONSTRAINT pk_meta_criteria_combo PRIMARY KEY(parent_criterion_id, child_criterion_id),
  CONSTRAINT fk_metacritcombo_parent FOREIGN KEY(parent_criterion_id) REFERENCES meta_criteria ON DELETE CASCADE, 
  CONSTRAINT fk_metacritcombo_child FOREIGN KEY(child_criterion_id) REFERENCES meta_criteria 
) ORGANIZATION INDEX;

GRANT SELECT ON meta_criteria_combo TO PUBLIC;
