-- **********************************************************************************
-- SQL tracing / monitoring package
--   better trace SQL latency with percentiles and histograms
--
-- High frequency sample a SQL_ID and display RAW data (captured individual executions)
--
-- Author: Maxym Kharchenko (c - 2014) maxymkharchenko@yahoo.com
-- **********************************************************************************

define SQL_ID=&1
define CHILD_NO=&2
define REPS=&3

set verify off

colu status format A1    heading 'S'
colu exec_id_status format A1    heading 'P'
colu etime format 999,999,999 heading 'Elapsed|Time'
colu cputime format 999,999 heading 'CPU|Time'
colu iotime format 999,999,999 heading 'IO|Time'
colu atime format 999,999,999 heading 'App|Time'
colu ctime format 999,999,999 heading 'CC|Time'
colu execs format 99     heading 'Ex'
colu gets format 999,999.99 heading 'Gets'
colu reads format 999.99    heading 'Reads'
colu recs format 999,999.99 heading 'Rows'

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

with i_gen as (
  select level as l from dual connect by level <= &REPS
), target_sqls as (
  select /*+ ordered no_merge use_nl(s) */
    i.l,
    s.executions-lag(s.executions,1) over (order by 1) as execs,
    s.executions as se,
    s.buffer_gets-lag(s.buffer_gets,1) over (order by 1) as gets,
    s.disk_reads-lag(s.disk_reads,1) over (order by 1) as reads,
    s.rows_processed-lag(s.rows_processed,1) over (order by 1) as recs,
    s.elapsed_time-lag(s.elapsed_time,1) over (order by 1) as etime,
    s.application_wait_time-lag(s.application_wait_time,1) over (order by 1) as atime,
    s.concurrency_wait_time-lag(s.concurrency_wait_time,1) over (order by 1) as ctime,
    s.user_io_wait_time-lag(s.user_io_wait_time,1) over (order by 1) as iotime,
    s.cpu_time-lag(s.cpu_time,1) over (order by 1) as cputime,
    s.last_active_time,
    case when s.address=se.sql_address and s.plan_hash_value=se.sql_hash_value then se.sql_exec_id else se.prev_exec_id end as sql_exec_id,
    case when s.address=se.sql_address and s.plan_hash_value=se.sql_hash_value then '' else 'P' end as exec_id_status,
    case when s.address=se.sql_address and s.plan_hash_value=se.sql_hash_value then se.sql_exec_start else se.prev_exec_start end as sql_exec_start
  from i_gen i, gv$sql s, gv$session se
  where s.sql_id='&SQL_ID'
    and s.child_number=&CHILD_NO
    and 
	(
      s.address=se.sql_address and s.plan_hash_value=se.sql_hash_value
      OR
      s.address=se.prev_sql_addr
    )
)
select case when execs=1 then '' else '*' end as status, execs,
  ceil(etime/execs) as etime, ceil(cputime/execs) as cputime, ceil(iotime/execs) as iotime, 
  ceil(atime/execs) as atime, ceil(ctime/execs) as ctime,
  round(gets/execs, 2) as gets, round(reads/execs, 2) as reads, round(recs/execs, 2) as recs
  , sql_exec_id, last_active_time, sql_exec_start
  , round(percent_rank() over (order by ceil(etime/execs))*100, 2) as p
from target_sqls
where execs > 0
  and etime > 0;

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
