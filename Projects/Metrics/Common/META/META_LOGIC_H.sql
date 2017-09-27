CREATE TABLE meta_logic_h
(
  change_id             NUMBER(10) NOT NULL,
  operation             CHAR(6) NOT NULL,
  report_cd             VARCHAR2(20) NOT NULL,
  num                   NUMBER(1) NOT NULL,
  criterion_id          NUMBER(6) NOT NULL,
  denom_numerator_ind   CHAR(1) NOT NULL,
  include_exclude_ind   CHAR(1) NOT NULL,
  CONSTRAINT fk_metalogic_h_change FOREIGN KEY (change_id) REFERENCES meta_changes
);

GRANT SELECT ON meta_logic_h TO PUBLIC;

CREATE OR REPLACE TRIGGER tr_meta_logic
FOR INSERT OR UPDATE OR DELETE ON meta_logic
COMPOUND TRIGGER
  BEFORE STATEMENT IS
  BEGIN
    meta.init;
  END BEFORE STATEMENT;

  AFTER EACH ROW IS
  BEGIN
    IF INSERTING OR UPDATING THEN
      INSERT INTO meta_logic_h(change_id, operation, report_cd, num, criterion_id, denom_numerator_ind, include_exclude_ind)
      VALUES(meta.n_change_id, meta.v_operation, :new.report_cd, :new.num, :new.criterion_id, :new.denom_numerator_ind, :new.include_exclude_ind);
    ELSE  
      INSERT INTO meta_logic_h(change_id, operation, report_cd, num, criterion_id, denom_numerator_ind, include_exclude_ind)
      VALUES(meta.n_change_id, meta.v_operation, :old.report_cd, :old.num, :old.criterion_id, :old.denom_numerator_ind, :old.include_exclude_ind);
    END IF;
  END AFTER EACH ROW;
END tr_meta_logic;
/
