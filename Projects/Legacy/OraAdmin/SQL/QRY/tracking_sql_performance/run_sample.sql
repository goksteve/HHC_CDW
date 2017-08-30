-- **********************************************************************************
-- SQL tracing / monitoring package:
--   better trace SQL latency with percentiles and histograms
--
-- "High frequency" sample specific SQL and save results in sqltrce_results table
--   Method:
--     Run a number of batches, sampling v$sql to capture individual executions
--     If no executions are found during a batch, exponentialy increase batch size
--     Capture until:
--       "capture" duration is reached
--
-- Author: Maxym Kharchenko (c - 2014) maxymkharchenko@yahoo.com
-- **********************************************************************************

define PKG_OWNER=&1     -- sqltrce_pkg owner
define SQL_ID=&2        -- sql_id to monitor
define CHILD_NO=&3      -- sql child number
define SECONDS=&4       -- (max) monitoring duration

set timi on
set time on
set echo on
set verify on
set serverout on

set termout off
colu cmd_name new_value C_NAME

select lower(a.name) as cmd_name
from v$sql s, audit_actions a
where s.command_type = a.action
  and s.sql_id='&SQL_ID'
  and s.child_number=&CHILD_NO
;
set termout on

spool &SQL_ID._&CHILD_NO._&C_NAME._&SECONDS.secs.out

begin
  &PKG_OWNER..sqltrce_pkg.sample_sql (
    sql_id => '&SQL_ID',       -- sql_id to trace
    child_number => &CHILD_NO, -- child_number to trace
    duration => &SECONDS,      -- trace duration in seconds
    save_ash => 'TRUE',        -- whether to save ASH data (for this cursor)
    sample_batch => 1000,      -- (initial) # of times to query v$sql in the inner NL join
    exponential_sampling => 2, -- if > 0, increase batch size by if found no executions
    keep_in_memory => 'FALSE', -- 'TRUE' - keep the entire result set in memory,
                               -- 'FALSE' - write to disk after each batch
    cleanup_previous => 'TRUE' -- Cleanup (truncate) previous results before starting
  );
end;
/

spool off

undef PKG_OWNER
undef SQL_ID
undef CHILD_NO
undef SECONDS
