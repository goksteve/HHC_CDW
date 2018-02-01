CREATE TABLE meta_conditions_h
(
  change_id             NUMBER(10) NOT NULL,
  operation             CHAR(6) NOT NULL CONSTRAINT chk_metacondition_h_operation CHECK(operation IN ('INSERT','UPDATE','DELETE')),
  criterion_id          NUMBER(6) NOT NULL,
  network               CHAR(3) NOT NULL,
  qualifier             VARCHAR2(30) NOT NULL,
  value                 VARCHAR2(255) NOT NULL,
  value_description     VARCHAR2(255),
  condition_type_cd     VARCHAR2(3) NOT NULL,
  comparison_operator   VARCHAR2(10) NOT NULL,
  include_exclude_ind   CHAR(1) NOT NULL,
  CONSTRAINT fk_metacondition_h_change FOREIGN KEY (change_id) REFERENCES meta_changes 
) COMPRESS BASIC;

GRANT SELECT ON meta_conditions_h TO PUBLIC;

CREATE OR REPLACE TRIGGER tr_meta_conditions
FOR INSERT OR UPDATE OR DELETE ON meta_conditions
COMPOUND TRIGGER
  BEFORE STATEMENT IS
  BEGIN
    meta.init;
  END BEFORE STATEMENT;

  AFTER EACH ROW IS
  BEGIN
    CASE
     WHEN INSERTING OR UPDATING THEN
      INSERT INTO meta_conditions_h(change_id, operation, criterion_id, network, qualifier, value, value_description, condition_type_cd, comparison_operator, include_exclude_ind)
      VALUES(meta.n_change_id, meta.v_operation, :new.criterion_id, :new.network, :new.qualifier, :new.value, :new.value_description, :new.condition_type_cd, :new.comparison_operator, :new.include_exclude_ind);
     ELSE  
      INSERT INTO meta_conditions_h(change_id, operation, criterion_id, network, qualifier, value, condition_type_cd, comparison_operator, include_exclude_ind)
      VALUES(meta.n_change_id, meta.v_operation, :old.criterion_id, :old.network, :old.qualifier, :old.value, :old.condition_type_cd, :old.comparison_operator, :old.include_exclude_ind);
    END CASE;
  END AFTER EACH ROW;
END tr_meta_conditions;
/
