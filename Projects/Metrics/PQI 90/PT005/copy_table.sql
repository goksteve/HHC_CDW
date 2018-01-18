set arraysize 5000
set copycommit 2
set verify off
set echo off
set feedback off

define TABLE=&1

prompt Copying &TABLE ... 
 
@@copy_from CBN
@@copy_from GP1
@@copy_from GP2
@@copy_from NBN
@@copy_from NBX
@@copy_from SMN
