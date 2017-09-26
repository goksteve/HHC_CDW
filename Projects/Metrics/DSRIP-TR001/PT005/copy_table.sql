set arraysize 5000
set copycommit 2
set verify off
set echo off
set feedback off

define TABLE=&1

exec xl.begin_action('Copying &TABLE data');

@@&TABLE._copy CBN
@@&TABLE._copy GP1
@@&TABLE._copy GP2
@@&TABLE._copy NBN
@@&TABLE._copy NBX
@@&TABLE._copy SMN

exec xl.end_action;
