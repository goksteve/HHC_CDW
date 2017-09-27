CREATE TABLE meta_criteria_h
(
  change_id                 NUMBER(10) NOT NULL,
  operation                 CHAR(6) NOT NULL CONSTRAINT chk_metacrit_h_operation CHECK(operation IN ('INSERT','UPDATE','DELETE')),
  criterion_id              NUMBER(6) NOT NULL,
  criterion_cd              VARCHAR2(55) NOT NULL,
  description               VARCHAR2(1024) NOT NULL,
  CONSTRAINT fk_metacrit_h_change FOREIGN KEY(change_id) REFERENCES meta_changes
);

GRANT SELECT ON meta_criteria_h TO PUBLIC;

CREATE OR REPLACE TRIGGER tr_meta_criteria
FOR INSERT OR UPDATE OR DELETE ON meta_criteria
COMPOUND TRIGGER
  BEFORE STATEMENT IS
  BEGIN
    meta.init;
  END BEFORE STATEMENT;

  AFTER EACH ROW IS
  BEGIN
    IF INSERTING OR UPDATING THEN
      INSERT INTO meta_criteria_h(change_id, operation, criterion_id, criterion_cd, description)
      VALUES(meta.n_change_id, meta.v_operation, :new.criterion_id, :new.criterion_cd, :new.description);
    ELSE  
      INSERT INTO meta_criteria_h(change_id, operation, criterion_id, criterion_cd, description)
      VALUES(meta.n_change_id, meta.v_operation, :old.criterion_id, :old.criterion_cd, :old.description);
    END IF;
  END AFTER EACH ROW;
END tr_meta_criteria;
/
