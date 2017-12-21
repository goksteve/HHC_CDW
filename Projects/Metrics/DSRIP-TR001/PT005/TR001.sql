/*
-- One-time DDL/DML:

@DSRIP_TR001_VISITS.sql
@DSRIP_TR001_DIAGNOSES.sql
@DSRIP_TR001_PAYERS.sql
@DSRIP_TR001_PROVIDERS.sql
@DSRIP_REPORT_TR001.sql
@INSURANCE_TYPE.fnc
@V_DSRIP_TR001_DETAIL.sql
@V_EPIC_BH_FOLLOW_UP_VISITS.sql
@PREPARE_DSRIP_REPORT_TR001.sql
@V_DSRIP_TR001_SUMMARY.sql
@V_DSRIP_TR001_EPIC_SUMMARY.sql
@add_DSRIP_REPORTS.sql
*/

-- Run every month:
whenever sqlerror exit 1
set feedback off

prompt Importing source data for the DSRIP report TR001 from 6 CDW databases ...
exec xl.open_log('DSRIP-TR001', 'Importing source data for the DSRIP report TR001', TRUE);

call xl.begin_action('Truncating staging tables');
truncate table dsrip_tr001_diagnoses;
truncate table dsrip_tr001_providers;
truncate table dsrip_tr001_payers;
truncate table dsrip_tr001_visits;
call xl.end_action();

@copy_table.sql VISITS
@copy_table.sql PROVIDERS
@copy_table.sql PAYERS
@copy_table.sql DIAGNOSES

exec xl.close_log('Successfully completed');

prompt Generating DSRIP report TR001. It may take a while ...
set timi on
call prepare_dsrip_report_tr001();

exit 0