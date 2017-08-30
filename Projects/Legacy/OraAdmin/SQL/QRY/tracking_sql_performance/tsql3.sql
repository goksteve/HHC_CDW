-- **********************************************************************************
-- SQL tracing / monitoring package
--   better trace SQL latency with percentiles and histograms
--
-- Analyze data previously captured in sqltrce_results
-- and calculate "elapsed time" percentiles, i.e. p50, p90, p99
--   ~ the same time range is expected in each "bucket"
--
-- Note: expects that sqltrce_pkg.sample_sql() routine already ran for specific SQL_ID
--
-- Author: Maxym Kharchenko (c - 2014) maxymkharchenko@yahoo.com
-- **********************************************************************************

define TAB_OWNER=&1  -- sqltrce_results table owner
define FUNC=&2       -- aggregate function (min, max, avg etc)
define NO_BUCKETS=&3 -- number of buckets

set verify off

colu bucket       format 999          heading 'Bucket'
colu bucket_range format a20         heading 'Range (ms)'
colu graph        format a10         heading 'Graph'
colu etime        format 999,999.99  heading 'Elapsed|Time'
colu cputime      format 999,999.99  heading 'CPU|Time'
colu iotime       format 999,999.99  heading 'IO|Time'
colu atime        format 999,999.99  heading 'App|Time'
colu ctime        format 999,999.99  heading 'CC|Time'
colu execs        format 999,999     heading 'Execs'
colu gets         format 999,999.99  heading 'Gets'
colu reads        format 999.99      heading 'Reads'
colu recs         format 999,999.99  heading 'Rows'

set termout off
alter session set nls_date_format='YYYY-MM-DD HH24:MI:SS';
set termout on

prompt ===================================================================================
prompt Analyzing data from &TAB_OWNER..sqltrce_results table
prompt
prompt GOAL: Calculate "elapsed time" histogram (&NO_BUCKETS buckets, ~ same time range in each)
prompt
prompt Displaying: "&FUNC" metric in a bucket (all times are in milliseconds)
prompt ===================================================================================

with target_sqls as (
  select executions as execs,
    buffer_gets as gets,
    disk_reads as reads,
    rows_processed as recs,
    elapsed_time as etime,
    application_wait_time as atime,
    concurrency_wait_time as ctime,
    user_io_wait_time as iotime,
    cpu_time as cputime,
    last_active_time
  from &TAB_OWNER..sqltrce_results
), i_gen2 as (
  select level as n from dual connect by level <= &NO_BUCKETS
), i_range as (
  select min(etime) as min_v, max(etime) as max_v, max(etime)-min(etime) as range_v
  from target_sqls
  where execs > 0
    and etime > 0
), time_buckets as (
  select i.n,
    r.min_v+(i.n-1)*(r.range_v/&NO_BUCKETS) as min_bucket_etime,
    r.min_v+(i.n)*(r.range_v/&NO_BUCKETS) as max_bucket_etime
  from i_gen2 i, i_range r
)
select b.n as bucket,
  round(b.min_bucket_etime/1000, 2)||'-'||round(b.max_bucket_etime/1000, 2) as bucket_range,
  sum(execs) as execs,
  lpad('#', sum(execs)/max(sum(execs)) over () * 10, '#') as graph,
  &FUNC(round(etime/execs/1000, 2)) as etime,
  &FUNC(round(cputime/execs/1000, 2)) as cputime,
  &FUNC(round(iotime/execs/1000, 2)) as iotime, 
  &FUNC(round(atime/execs/1000, 2)) as atime,
  &FUNC(round(ctime/execs/1000, 2)) as ctime,
  &FUNC(round(gets/execs, 2)) as gets,
  &FUNC(round(reads/execs, 2)) as reads,
  &FUNC(round(recs/execs, 2)) as recs,
  max(last_active_time) as last_active_time
from time_buckets b left outer join target_sqls s
  on s.etime >= b.min_bucket_etime 
    and s.etime < decode(b.n, &NO_BUCKETS, b.max_bucket_etime+1, b.max_bucket_etime)
--where s.execs > 0
--  and s.etime > 0
group by b.n, b.min_bucket_etime, b.max_bucket_etime
order by b.n
/

colu SAMPLING_ETIME_MEAN new_val SETIME_MEAN
colu SAMPLING_EXECS new_val SEXECS
set termout off
select sum(executions) as SAMPLING_EXECS,
  round(sum(elapsed_time)/decode(sum(executions), 0, 1, sum(executions))/1000, 2) as sampling_etime_mean
from &TAB_OWNER..sqltrce_results;
set termout on

prompt ========================================================================================
prompt Sample metrics:
prompt
prompt Executions: &SEXECS
prompt Average elapsed time: &SETIME_MEAN milliseconds
prompt ========================================================================================


undef TAB_OWNER
undef FUNC

undef NO_BUCKETS
