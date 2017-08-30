-- **********************************************************************************
-- SQL tracing / monitoring package:
--   better trace SQL latency with percentiles and histograms
--
-- Run SQL monitoring for a specific SQL and save results in sqltrce_monitor_sql table
--   Method:
--     Add /*+ MONITOR */ hint to SQL_ID (by sql profile)
--     Capture until either:
--       enough executions are captured
--       "capture" duration is reached
--
-- Author: Maxym Kharchenko (c - 2014) maxymkharchenko@yahoo.com
-- **********************************************************************************

define PKG_OWNER=&1     -- sqltrce_pkg owner
define SQL_ID=&2        -- sql_id to monitor
define SECONDS=&3       -- (max) monitoring duration
define MAX_CAPTURED=&4  -- stop after capturing this # of statements

set timi on
set time on
set echo on
set verify on
set serverout on

set termout off
colu cmd_name new_value C_NAME

select lower(a.name) as cmd_name
from v$sqlarea s, audit_actions a
where s.command_type = a.action
  and s.sql_id='&SQL_ID'
;
set termout on

spool &SQL_ID._&C_NAME._&SECONDS.secs.out

begin
  &PKG_OWNER..sqltrce_pkg.monitor_sql (
    sql_id => '&SQL_ID',             -- sql_id to trace
    duration => &SECONDS,            -- trace duration in seconds
    max_executions => &MAX_CAPTURED, -- MAX # of captured executions
    save_ash => 'TRUE',              -- whether to save ASH data 
    save_sqlmon => 'TRUE',           -- wheher to save sql monitoring data
    cleanup_previous => 'TRUE'       -- Cleanup (truncate) previous results before starting
  );
end;
/

spool off

undef PKG_OWNER
undef SQL_ID
undef SECONDS
undef MAX_CAPTURED
