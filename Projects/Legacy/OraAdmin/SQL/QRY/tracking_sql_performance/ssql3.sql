-- **********************************************************************************
-- SQL tracing / monitoring package
--   better trace SQL latency with percentiles and histograms
--
-- High frequency sample a SQL_ID
-- Then, Calculate "elapsed time" histogram to see "the shape" of elapsed time
--   ~ the same time range is expected in each "bucket"
--
-- Author: Maxym Kharchenko (c - 2014) maxymkharchenko@yahoo.com
-- **********************************************************************************

define SQL_ID=&1     -- sql_id to trace
define CHILD_NO=&2   -- sql child number
define REPS=&3       -- Number of "repetions into v$sql" (sampling batch size)
define FUNC=&4       -- aggregate function (min, max, avg etc)
define NO_BUCKETS=&5 -- number of buckets

set verify off

colu bucket       format 99          heading 'Bucket'
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

prompt ===================================================================================
prompt Sampling sql_id=&SQL_ID:&CHILD_NO
prompt   &STEXT
prompt
prompt GOAL: Calculate "elapsed time" histogram (&NO_BUCKETS buckets, ~ same time range in each)
prompt
prompt &REPS times. Running elapsed_time average=&RUNNING_MEAN ms
prompt 
prompt Displaying: "&FUNC" metric in a bucket (all times are in milliseconds)
prompt ===================================================================================

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
where s.execs > 0
  and s.etime > 0
group by b.n, b.min_bucket_etime, b.max_bucket_etime
order by b.n
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

undef NO_BUCKETS
