CREATE SEQUENCE seq_meta_changes NOCACHE; 

CREATE TABLE meta_changes
(
  change_id NUMBER(10) CONSTRAINT pk_meta_changes PRIMARY KEY,
  change_dt DATE  NOT NULL,
  os_user   VARCHAR2(30) NOT NULL,
  comments  VARCHAR2(1024)
);

COMMENT ON TABLE meta_changes IS 'Log of the changes to the meta-data of the DSRIP reports and NQMC Measures';

GRANT SELECT ON meta_changes TO PUBLIC;

CREATE OR REPLACE TRIGGER biudr_meta_changes
BEFORE INSERT OR UPDATE OR DELETE ON meta_changes
FOR EACH ROW
BEGIN
  IF UPDATING OR DELETING THEN
    Raise_Application_Error(-20000, 'Not allowed to Update/Delete data in the audit table META_CHANGES');
  END IF;
  
  :new.change_id := seq_meta_changes.NEXTVAL;
  :new.change_dt := SYSDATE;
  :new.os_user := SYS_CONTEXT('USERENV','OS_USER');
  DBMS_SESSION.SET_IDENTIFIER(:new.change_id);
END biudr_meta_changes;
/   
