prompt Creating package PKG_DBG_XLOGGER
 
CREATE OR REPLACE PACKAGE pkg_dbg_xlogger AS
/*
  This package is for debugging and performance tuning
 
  History of changes (newest to oldest):
  --------------------------------------------------------------------------------
  10-Nov-2015, OK: new version
*/
  PROCEDURE open_log(p_name IN VARCHAR2, p_comment IN VARCHAR2 DEFAULT NULL, p_debug IN BOOLEAN DEFAULT FALSE);
 
  FUNCTION get_current_proc_id RETURN PLS_INTEGER;
 
  PROCEDURE begin_action
  (
    p_action    IN VARCHAR2, 
    p_comment   IN VARCHAR2 DEFAULT 'Started',
    p_debug     IN BOOLEAN DEFAULT NULL
  );
 
  PROCEDURE end_action(p_comment IN VARCHAR2 DEFAULT 'Completed');
 
  PROCEDURE close_log(p_result IN VARCHAR2 DEFAULT NULL, p_dump IN BOOLEAN DEFAULT FALSE);
  
  PROCEDURE spool_log(p_where IN VARCHAR2 DEFAULT NULL, p_max_rows IN PLS_INTEGER DEFAULT 100);
 
  PROCEDURE cancel_log;
END;
/
 
CREATE OR REPLACE SYNONYM xl FOR pkg_dbg_xlogger;
GRANT EXECUTE ON xl TO PUBLIC;
