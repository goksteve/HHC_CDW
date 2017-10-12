set feedback off
/*
-- One-time DDL:
@TR001_VISITS.sql
@TR001_DIAGNOSES.sql
@TR001_PAYERS.sql
@TR001_PROVIDERS.sql
@REF_HEDIS_VALUE_SETS.sql
@DSRIP_REPORT_TR001.sql
@INSURANCE_TYPE.fnc
@V_DSRIP_REPORT_TR001.sql
*/

-- Run every month:
prompt Preparing DSRIP report TR001

exec xl.open_log('DSRIP-TR001', 'Preparing DSRIP report TR001', TRUE);

exec xl.begin_action('Truncating staging tables');
truncate table tst_ok_tr001_visits;
truncate table tst_ok_tr001_diagnoses;
truncate table tst_ok_tr001_providers;
truncate table tst_ok_tr001_payers;
exec xl.end_action;

@copy_table.sql TR001_VISITS
@copy_table.sql TR001_DIAGNOSES
@copy_table.sql TR001_PROVIDERS
@copy_table.sql TR001_PAYERS

exec prepare_dsrip_report_tr001;