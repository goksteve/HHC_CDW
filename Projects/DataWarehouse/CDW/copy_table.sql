set arraysize 5000
set copycommit 2
set verify off
set echo off
set feedback off

define TABLE=&1

CALL xl.begin_action('Copying &TABLE data');

@@copy_&TABLE CBN
@@copy_&TABLE GP1
@@copy_&TABLE GP2
@@copy_&TABLE NBN
@@copy_&TABLE NBX
@@copy_&TABLE SMN

CALL xl.end_action();
