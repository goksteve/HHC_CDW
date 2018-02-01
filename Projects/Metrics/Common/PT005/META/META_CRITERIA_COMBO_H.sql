CREATE TABLE meta_criteria_combo_h
(
  change_id           NUMBER(10) NOT NULL,
  operation           CHAR(6) NOT NULL,
  parent_criterion_id NUMBER(3) NOT NULL,
  child_criterion_id  NUMBER(3) NOT NULL,
  include_exclude_ind        VARCHAR2(7) NOT NULL,
  CONSTRAINT fk_metacritcombo_h_change FOREIGN KEY(change_id) REFERENCES meta_changes 
);

GRANT SELECT ON meta_criteria_combo_h TO PUBLIC;

CREATE OR REPLACE TRIGGER tr_meta_criteria_combo
FOR INSERT OR UPDATE OR DELETE ON meta_criteria_combo
COMPOUND TRIGGER
  BEFORE STATEMENT IS
  BEGIN
    meta.init;
  END BEFORE STATEMENT;

  AFTER EACH ROW IS
  BEGIN
    IF INSERTING OR UPDATING THEN
      INSERT INTO meta_criteria_combo_h(change_id, operation, parent_criterion_id, child_criterion_id, include_exclude_ind)
      VALUES(meta.n_change_id, meta.v_operation, :new.parent_criterion_id, :new.child_criterion_id, :new.include_exclude_ind);
    ELSE  
      INSERT INTO meta_criteria_combo_h(change_id, operation, parent_criterion_id, child_criterion_id, include_exclude_ind)
      VALUES(meta.n_change_id, meta.v_operation, :old.parent_criterion_id, :old.child_criterion_id, :old.include_exclude_ind);
    END IF;
  END AFTER EACH ROW;
END tr_meta_criteria_combo;
/
