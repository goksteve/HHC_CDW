CREATE TABLE meta_lists
(
  list_id               NUMBER(3) CONSTRAINT pk_meta_lists PRIMARY KEY,
  list_cd               VARCHAR2(55) NOT NULL CONSTRAINT uk_meta_criteria UNIQUE,
  description           VARCHAR2(1024) NOT NULL,
  default_item_type_cd  VARCHAR2(3) NOT NULL
   CONSTRAINT chk_metalist_dflttype CHECK(default_item_type_cd IN ('DI', 'EI', 'EN', 'MED', 'PI')),
  default_operator  VARCHAR2(4) DEFAULT '=' NOT NULL
   CONSTRAINT chk_metalist_dfltopr CHECK(default_operator IN ('=', 'LIKE'))
);

GRANT SELECT ON meta_lists TO PUBLIC;

CREATE TABLE meta_lists_h
(
  change_id             NUMBER(10) NOT NULL,
  operation             CHAR(6) NOT NULL CONSTRAINT chk_metalist_h_operation CHECK(operation IN ('INSERT','UPDATE','DELETE')),
  list_id               NUMBER(3) NOT NULL,
  list_cd               VARCHAR2(55),
  description           VARCHAR2(1024),
  default_item_type_cd  VARCHAR2(3),
  default_operator      VARCHAR2(4),
  CONSTRAINT fk_metalist_h_change FOREIGN KEY(change_id) REFERENCES meta_changes
);

GRANT SELECT ON meta_lists TO PUBLIC;
GRANT SELECT ON meta_lists_h TO PUBLIC;

CREATE OR REPLACE TRIGGER tr_meta_list
FOR INSERT OR UPDATE OR DELETE ON meta_lists
COMPOUND TRIGGER
  BEFORE STATEMENT IS
  BEGIN
    meta.init;
  END BEFORE STATEMENT;

  AFTER EACH ROW IS
  BEGIN
    IF INSERTING OR UPDATING THEN
      INSERT INTO meta_lists_h(change_id, operation, list_id, list_cd, description, default_item_type_cd, default_operator)
      VALUES(meta.n_change_id, meta.v_operation, :new.list_id, :new.list_cd, :new.description, :new.default_item_type_cd, :new.default_operator);
    ELSE  
      INSERT INTO meta_lists_h(change_id, operation, list_id)
      VALUES(meta.n_change_id, meta.v_operation, :old.list_id);
    END IF;
  END AFTER EACH ROW;
END tr_meta_list;
/
