CREATE OR REPLACE FUNCTION eval_ytm_interval(i_string IN VARCHAR2) RETURN INTERVAL YEAR TO MONTH AS
  ret INTERVAL YEAR TO MONTH;
BEGIN
  EXECUTE IMMEDIATE 'BEGIN :ret := '||i_string||'; END;' USING OUT ret;
  RETURN ret;
END;
/
 
GRANT EXECUTE ON eval_ytm_interval TO PUBLIC;

