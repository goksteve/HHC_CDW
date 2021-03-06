CREATE OR REPLACE FUNCTION eval_dts_interval(i_string IN VARCHAR2) RETURN INTERVAL DAY TO SECOND AS
  ret INTERVAL DAY TO SECOND;
BEGIN
  EXECUTE IMMEDIATE 'BEGIN :ret := '||i_string||'; END;' USING OUT ret;
  RETURN ret;
END;
/
 
GRANT EXECUTE ON eval_dts_interval TO PUBLIC;

