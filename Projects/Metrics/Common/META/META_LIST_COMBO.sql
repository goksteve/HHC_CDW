CREATE TABLE meta_list_combo
(
  parent_list_id    NUMBER(3),
  child_list_id     NUMBER(3),
  logical_operator  VARCHAR2(6) NOT NULL CONSTRAINT chk_metalistcombo_logicalopr CHECK (logical_operator IN ('IN', 'NOT IN')),
  CONSTRAINT pk_meta_list_combo PRIMARY KEY(parent_list_id, child_list_id),
  CONSTRAINT fk_metalistcombo_parent FOREIGN KEY(parent_list_id) REFERENCES meta_lists ON DELETE CASCADE, 
  CONSTRAINT fk_metalistcombo_child FOREIGN KEY(child_list_id) REFERENCES meta_lists ON DELETE CASCADE 
) ORGANIZATION INDEX;

GRANT SELECT ON meta_list_combo TO PUBLIC;