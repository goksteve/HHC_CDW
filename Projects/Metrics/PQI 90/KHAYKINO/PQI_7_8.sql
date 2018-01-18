whenever sqlerror exit 1
set feedback off

alter session force parallel dml;
alter session force parallel ddl;

/*
rem One-time DDL:
--prompt @DSRIP_PQI_7_8_VISITS.sql
@DSRIP_PQI_7_8_VISITS.sql
prompt @DSRIP_PQI_7_8_PAYERS.sql
@DSRIP_PQI_7_8_PAYERS.sql
*/

rem Every month:
TRUNCATE TABLE dsrip_pqi_7_8_visits;
TRUNCATE TABLE dsrip_pqi_7_8_payers;

prompt @Insert_VISITS.sql
@Insert_VISITS.sql

prompt @Insert_PAYERS.sql
@Insert_PAYERS.sql

exit
