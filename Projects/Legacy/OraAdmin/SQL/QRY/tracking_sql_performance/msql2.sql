-- **********************************************************************************
-- SQL tracing / monitoring package
--   better trace SQL latency with percentiles and histograms
--
-- Analyze data previously captured in sqltrce_sql_monitor
-- Calculate "elapsed time" percentiles, i.e. p50, p90, p99
--   ~ the same # of executions is expected in each "bucket"
--
-- Note: expects that sqltrce_pkg.monitor_sql() routine already ran for specific SQL_ID
--
-- Author: Maxym Kharchenko (c - 2014) maxymkharchenko@yahoo.com
-- **********************************************************************************

define TAB_OWNER=&1  -- sqltrce_sql_monitor table owner
define SQL_ID=&2     -- sql_id to trace
define FUNC=&3       -- aggregate function (min, max, avg etc)
define NO_BUCKETS=&4 -- number of buckets

set verify off

colu p1      format a3          heading 'Pct'
colu etime   format A30         heading 'Elapsed|Time'
colu cputime format 999,999.99  heading 'CPU|Time'
colu iotime  format 999,999.99  heading 'IO|Time'
colu atime   format 999,999.99  heading 'App|Time'
colu ctime   format 999,999.99  heading 'CC|Time'
colu execs   format 999,999     heading 'Execs'
colu gets    format 999,999.99  heading 'Gets'
colu reads   format 999.99      heading 'Reads'

set termout off
alter session set nls_date_format='YYYY-MM-DD HH24:MI:SS';
set termout on

prompt ========================================================================================
prompt Analyzing data from &TAB_OWNER..sqltrce_sql_monitor table for sql_id=&SQL_ID
prompt
prompt GOAL: Calculate "elapsed time" percentiles (&NO_BUCKETS buckets, ~ same # of executions in each)
prompt
prompt Displaying: "&FUNC" metric in a bucket (all times are in milliseconds)
prompt ========================================================================================

with target_sqls as (
  select 1 as execs,
    buffer_gets as gets,
    disk_reads as reads,
    elapsed_time as etime,
    application_wait_time as atime,
    concurrency_wait_time as ctime,
    user_io_wait_time as iotime,
    cpu_time as cputime,
    sql_exec_id, sql_exec_start
  from &TAB_OWNER..sqltrce_sql_monitor
  where sql_id='&SQL_ID'
), target_sqls2 as (
  select ntile(&NO_BUCKETS) over (order by etime/execs) as pct,
    execs, etime, cputime, iotime, atime, ctime,
    gets, reads
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
  &FUNC(round(reads/execs, 2)) as reads
from target_sqls2 s
group by s.pct
order by s.pct
/

colu SAMPLING_ETIME_MEAN new_val SETIME_MEAN
colu SAMPLING_EXECS new_val SEXECS
set termout off
select count(1) as SAMPLING_EXECS,
  round(sum(elapsed_time)/decode(count(1), 0, 1, count(1))/1000, 2) as sampling_etime_mean
from &TAB_OWNER..sqltrce_sql_monitor
where sql_id='&SQL_ID';
set termout on

prompt ========================================================================================
prompt Sample metrics:
prompt
prompt Executions: &SEXECS
prompt Average elapsed time: &SETIME_MEAN milliseconds
prompt ========================================================================================

undef TAB_OWNER
undef SQL_ID
undef FUNC
