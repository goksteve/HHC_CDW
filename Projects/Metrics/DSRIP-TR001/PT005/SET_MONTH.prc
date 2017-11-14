CREATE OR REPLACE PROCEDURE set_month(p_month IN VARCHAR2) AS
BEGIN
  dbms_session.set_identifier('01-'||p_month);
END;
/