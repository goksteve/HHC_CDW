whenever sqlerror exit 1

set verify off
set echo off
set feedback off
set arraysize 5000
set copycommit 2

ALTER SESSION SET NLS_LENGTH_SEMANTICS='BYTE';

prompt Importing source data from CDW databases ...

BEGIN
  FOR r IN
  (
    SELECT table_name FROM user_tables
    WHERE table_name IN ('HHC_CLINIC_CODES','HHC_CLINIC_CODES','HHC_PATIENT_DIMENSION')
  )
  LOOP
    EXECUTE IMMEDIATE 'TRUNCATE TABLE '||r.table_name;
  END LOOP;
END;
/

@@copy_table HHC_CUSTOM HHC_CLINIC_CODES
@@copy_table HHC_CUSTOM HHC_LOCATION_DIMENSION
@@copy_PATIENT_DIM

exit 0
