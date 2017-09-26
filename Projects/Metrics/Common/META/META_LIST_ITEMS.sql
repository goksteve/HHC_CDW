CREATE TABLE meta_list_items
(
  list_id                   NUMBER(6) NOT NULL,
  network                   CHAR(3) DEFAULT 'ALL'
   CONSTRAINT chk_metalistitm_network CHECK (network IN ('ALL','CBN','GP1','GP2','NBN','NBX','QHN','SBN','SMN')), 
  qualifier                 VARCHAR2(30) DEFAULT 'NONE',
  value                     VARCHAR2(255) NOT NULL,
  item_type_cd              VARCHAR2(3)
   CONSTRAINT chk_metalistitm_type CHECK(item_type_cd IN ('DI', 'EI', 'EN', 'MED', 'PI')),
  comparison_operator       VARCHAR2(10),
  CONSTRAINT pk_meta_list_items PRIMARY KEY(list_id, network, qualifier, value),
  CONSTRAINT fk_item_list FOREIGN KEY (list_id) REFERENCES meta_lists ON DELETE CASCADE 
) ORGANIZATION INDEX;

GRANT SELECT ON meta_list_items TO PUBLIC;

CREATE TABLE meta_list_items_h
(
  change_id             NUMBER(10) NOT NULL,
  operation             CHAR(6) CONSTRAINT chk_metalistitem_h_operation CHECK(operation IN ('INSERT','UPDATE','DELETE')),
  list_id               NUMBER(6),
  network               CHAR(3),
  qualifier             VARCHAR2(30) DEFAULT 'NONE',
  value                 VARCHAR2(255) NOT NULL,
  item_type_cd          VARCHAR2(3),
  comparison_operator   VARCHAR2(10),
  CONSTRAINT fk_metalistitem_change FOREIGN KEY (change_id) REFERENCES meta_changes 
) COMPRESS BASIC;

GRANT SELECT ON meta_list_items_h TO PUBLIC;

CREATE OR REPLACE TRIGGER tr_meta_list_items
FOR INSERT OR UPDATE OR DELETE ON meta_list_items
COMPOUND TRIGGER
  BEFORE STATEMENT IS
  BEGIN
    meta.init;
  END BEFORE STATEMENT;

  AFTER EACH ROW IS
  BEGIN
    CASE
     WHEN INSERTING OR UPDATING THEN
      INSERT INTO meta_list_items_h(change_id, operation, list_id, network, qualifier, value, item_type_cd, comparison_operator)
      VALUES(meta.n_change_id, meta.v_operation, :new.list_id, :new.network, :new.qualifier, :new.value, :new.item_type_cd, :new.comparison_operator);
     ELSE  
      INSERT INTO meta_list_items_h(change_id, operation, list_id, network, qualifier, value, item_type_cd)
      VALUES(meta.n_change_id, meta.v_operation, :old.list_id, :old.network, :old.qualifier, :old.value, :old.item_type_cd);
    END CASE;
  END AFTER EACH ROW;
END tr_meta_list_items;
/
