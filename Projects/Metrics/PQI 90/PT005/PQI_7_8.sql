whenever sqlerror exit 1
set feedback off

prompt Importing source data from CDW databases ...

truncate table DSRIP_PQI_7_8_VISITS;
truncate table DSRIP_PQI_7_8_PAYERS;

@@copy_table DSRIP_PQI_7_8_VISITS
@@copy_table DSRIP_PQI_7_8_PAYERS

exec prepare_pqi90_reports_7_8;

exit 0
