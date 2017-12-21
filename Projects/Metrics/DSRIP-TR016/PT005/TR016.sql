/* One-time DDL:
@REF_PRESCRIPTIONS.sql
@REF_DRUG_NAMES.sql
@REF_DRUG_DESCRIPTIONS.sql
@DSRIP_TR016_A1C_GLUCOSE_RSLT.sql
@DSRIP_TR016_PAYERS.sql
*/

-- Every month:
whenever sqlerror exit 1
whenever oserror exit 1
set line 100
set verify off

column 1 new_value 1
select '' "1" from dual where rownum = 0;
define MON='&1'

prompt Preparing DSRIP report TR016

exec xl.open_log('DSRIP-TR016', 'Preparing source data for DSRIP report TR016', TRUE);

exec xl.begin_action('Truncating staging tables');
truncate table DSRIP_TR016_A1C_GLUCOSE_RSLT;
truncate table DSRIP_TR016_PAYERS;
truncate table DSRIP_TR016_PCP_INFO;
exec xl.end_action;

@copy_table.sql TR016_A1C_GLUCOSE_RSLT
@copy_table.sql TR016_PAYERS
@copy_table.sql TR016_PCP_INFO

exec xl.close_log('Successfully completed');

prompt Preparing report data. It may take a while ..
call prepare_dsrip_report_tr016('&MON');

exit