set arraysize 5000
set copycommit 2
set verify off
set echo off
set feedback off

define TABLE=&1

exec xl.begin_action('Copying &TABLE data');

@@&TABLE._copy CBN
rem @@&TABLE._copy GP1
rem @@&TABLE._copy GP2
rem @@&TABLE._copy NBN
rem @@&TABLE._copy NBX
rem @@&TABLE._copy SMN

exec xl.end_action;
