whenever sqlerror exit 1
set feedback off

prompt Importing source data from CDW databases ...

@@copy_table STG_ICD_CODES
@@copy_table STG_MAP_ICD_CODES
@@copy_table TST_PROBLEM_CMV

exit 0
