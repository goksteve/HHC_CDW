whenever sqlerror exit 1
rem whenever oserror exit 1

set arraysize 5000
set copycommit 2
set verify off
set echo off
set feedback off

define TABLE=&1

exec xl.open_log('OK_COPY_&TABLE', 'Copying &TABLE data', TRUE);

@@&TABLE._copy CBN
@@&TABLE._copy GP1
@@&TABLE._copy GP2
@@&TABLE._copy NBN
@@&TABLE._copy NBX
@@&TABLE._copy SMN

exec xl.close_log('Successfully completed');

exit 0