CREATE OR REPLACE PACKAGE pkg_metadata_admin AS
  n_change_id NUMBER(10);
  v_operation CHAR(6);
  v_os_user   VARCHAR2(30);

  PROCEDURE init;
END pkg_metadata_admin;
/

CREATE OR REPLACE SYNONYM meta FOR pkg_metadata_admin;

CREATE OR REPLACE PACKAGE BODY pkg_metadata_admin AS
  PROCEDURE init IS
  BEGIN
    n_change_id := SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER');
    BEGIN
      SELECT os_user INTO v_os_user FROM meta_changes WHERE change_id = n_change_id;
      IF v_os_user <> SYS_CONTEXT('USERENV', 'OS_USER') THEN
        Raise_Application_Error(-20000, 'Not allowed to "hijack" other user''s change session');
      END IF;
    EXCEPTION
     WHEN NO_DATA_FOUND THEN
      Raise_Application_Error(-20000, 'First, you need to insert a new row into the META_CHANGES table and only then make changes to other META_* tables, within the same database session.');
    END;
    
    v_operation := CASE WHEN INSERTING THEN 'INSERT' WHEN UPDATING THEN 'UPDATE' ELSE 'DELETE' END;
  END init;
END pkg_metadata_admin;
/
