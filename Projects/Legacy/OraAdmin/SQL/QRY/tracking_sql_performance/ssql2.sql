-- **********************************************************************************
-- SQL tracing / monitoring package
--   better trace SQL latency with percentiles and histograms
--
-- High frequency sample a SQL_ID
-- Then, Calculate "elapsed time" percentiles, i.e. p50, p90, p99
--   ~ the same # of executions is expected in each "bucket"
--
-- Author: Maxym Kharchenko (c - 2014) maxymkharchenko@yahoo.com
-- **********************************************************************************

define SQL_ID=&1     -- sql_id to trace
define CHILD_NO=&2   -- sql child number
define REPS=&3       -- Number of "repetions into v$sql" (sampling batch size)
define FUNC=&4       -- aggregate function (min, max, avg etc)
define NO_BUCKETS=&5 -- number of buckets

set verify off

colu p1      format A3          heading 'Pct'
colu etime   format A30         heading 'Elapsed|Time'
colu cputime format 999,999.99  heading 'CPU|Time'
colu iotime  format 999,999.99  heading 'IO|Time'
colu atime   format 999,999.99  heading 'App|Time'
colu ctime   format 999,999.99  heading 'CC|Time'
colu execs   format 999,999     heading 'Execs'
colu gets    format 999,999.99  heading 'Gets'
colu reads   format 999.99      heading 'Reads'
colu recs    format 999,999.99  heading 'Rows'

colu BEFORE_EXECS new_val BEXECS
colu BEFORE_ETIME new_val BETIME
colu RUNNING_ETIME_MEAN new_val RUNNING_MEAN
colu SQL_TEXT new_val STEXT
set termout off
select executions as BEFORE_EXECS, elapsed_time as BEFORE_ETIME, substr(sql_text, 1, 80) as sql_text,
  round(elapsed_time/decode(executions, 0, 1, executions)/1000, 2) as running_etime_mean
from v$sql where sql_id='&SQL_ID' and child_number=&CHILD_NO;

alter session set nls_date_format='YYYY-MM-DD HH24:MI:SS';
set termout on

prompt ========================================================================================
prompt Sampling sql_id=&SQL_ID:&CHILD_NO
prompt   &STEXT
prompt
prompt GOAL: Calculate "elapsed time" percentiles (&NO_BUCKETS buckets, ~ same # of executions in each)
prompt
prompt &REPS times. Running elapsed_time average=&RUNNING_MEAN ms
prompt
prompt Displaying: "&FUNC" metric in a bucket (all times are in milliseconds)
prompt ========================================================================================

set timi on

with i_gen as (
  select level as l from dual connect by level <= &REPS
), target_sqls as (
  select /*+ ordered no_merge use_nl(s) */
    i.l,
    s.executions-lag(s.executions,1) over (order by 1) as execs,
    s.buffer_gets-lag(s.buffer_gets,1) over (order by 1) as gets,
    s.disk_reads-lag(s.disk_reads,1) over (order by 1) as reads,
    s.rows_processed-lag(s.rows_processed,1) over (order by 1) as recs,
    s.elapsed_time-lag(s.elapsed_time,1) over (order by 1) as etime,
    s.application_wait_time-lag(s.application_wait_time,1) over (order by 1) as atime,
    s.concurrency_wait_time-lag(s.concurrency_wait_time,1) over (order by 1) as ctime,
    s.user_io_wait_time-lag(s.user_io_wait_time,1) over (order by 1) as iotime,
    s.cpu_time-lag(s.cpu_time,1) over (order by 1) as cputime,
    s.last_active_time
  from i_gen i, gv$sql s, gv$session se
  where s.sql_id='&SQL_ID'
    and s.child_number=&CHILD_NO
    and (
      (s.address=se.sql_address and s.plan_hash_value=se.sql_hash_value)
      OR
      (s.address=se.prev_sql_addr )
    )
), target_sqls2 as (
  select ntile(&NO_BUCKETS) over (order by etime/execs) as pct,
    execs, etime, cputime, iotime, atime, ctime,
    gets, reads, recs, last_active_time
  from target_sqls
  where execs > 0
    and etime > 0
)
select 'p'||to_char(round((s.pct-1)/&NO_BUCKETS.*100)) as p1,
  sum(execs) as execs, 
  round(min(etime/execs)/1000, 2)||'-'||round(max(etime/execs)/1000, 2) as etime,
  &FUNC(round(cputime/execs/1000, 2)) as cputime,
  &FUNC(round(iotime/execs/1000, 2)) as iotime, 
  &FUNC(round(atime/execs/1000, 2)) as atime,
  &FUNC(round(ctime/execs/1000, 2)) as ctime,
  &FUNC(round(gets/execs, 2)) as gets,
  &FUNC(round(reads/execs, 2)) as reads,
  &FUNC(round(recs/execs, 2)) as recs,
  max(last_active_time) as last_active_time
from target_sqls2 s
group by s.pct
order by s.pct
/

set timi off

colu SAMPLING_ETIME_MEAN new_val SETIME_MEAN
colu SAMPLING_EXECS new_val SEXECS
set termout off
select executions-&BEXECS as SAMPLING_EXECS,
  round((elapsed_time-&BETIME)/decode(executions-&BEXECS, 0, 1, executions-&BEXECS)/1000, 2) as sampling_etime_mean
from v$sql where sql_id='&SQL_ID' and child_number=&CHILD_NO;
set termout on

prompt ========================================================================================
prompt Sample metrics:
prompt
prompt Executions: &SEXECS
prompt Average elapsed time: &SETIME_MEAN milliseconds
prompt ========================================================================================

undef SQL_ID
undef CHILD_NO
undef REPS
undef FUNC
