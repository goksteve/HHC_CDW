set verify off
set echo off
set feedback off
set arraysize 5000
set copycommit 2

define SCHEMA=&1
define TABLE=&2

prompt Copying &TABLE ... 

@@copy_from CBN
@@copy_from GP1
@@copy_from GP2
@@copy_from NBN
@@copy_from NBX
@@copy_from QHN
@@copy_from SBN
@@copy_from SMN
