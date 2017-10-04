/* One-time DDL:
@TST_OK_PRESCRIPTIONS.sql
@TST_OK_DRUG_NAMES.sql
@TST_OK_DRUG_DESCRIPTIONS.sql
@TST_OK_TR016_A1C_GLUCOSE_LVL.sql
*/
-- Every month:
prompt Preparing DSRIP report TR016

exec xl.open_log('DSRIP-TR016', 'Preparing DSRIP report TR016', TRUE);
exec xl.begin_action('Truncating staging tables');
truncate table TST_OK_TR016_A1C_GLUCOSE_LVL;
exec xl.end_action;

@copy_table.sql TR016_A1C_GLUCOSE_LVL
