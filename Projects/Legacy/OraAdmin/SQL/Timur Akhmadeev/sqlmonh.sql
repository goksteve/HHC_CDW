@saveset
set long 1000000 linesize 4000 pagesize 0 head off feed off echo off termout off
repheader off

var sql_id varchar2(13)
exec :sql_id := '&1'

col rep_name        new_value       rep_name
select '&SQLPATH/tmp/sqlmon_' || :sql_id rep_name from dual;

spool &rep_name..html
select DBMS_SQLTUNE.REPORT_SQL_MONITOR(sql_id=>'&1', report_level=>'all', type=>'html') SQL_Report from dual;
spool off

host &rep_name..html

@loadset