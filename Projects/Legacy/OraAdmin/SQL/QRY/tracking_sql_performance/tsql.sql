-- **********************************************************************************
-- SQL tracing / monitoring package
--   better trace SQL latency with percentiles and histograms
--
-- Analyze data previously captured in sqltrce_results
-- Display RAW data
--
-- Note: expects that sqltrce_pkg.sample_sql() routine already ran for specific SQL_ID
--
-- Author: Maxym Kharchenko (c - 2014) maxymkharchenko@yahoo.com
-- **********************************************************************************

define TAB_OWNER=&1  -- sqltrce_results table owner

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

set termout off
alter session set nls_date_format='YYYY-MM-DD HH24:MI:SS';
set termout on

prompt ========================================================================================
prompt RAW data from saved SQL sampling
prompt
prompt Times are in microseconds
prompt ========================================================================================

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
    sql_exec_id, sql_exec_start,
    last_active_time
  from &TAB_OWNER..sqltrce_results
)
select case when execs=1 then '' else '*' end as status, execs,
  ceil(etime/execs) as etime, ceil(cputime/execs) as cputime, ceil(iotime/execs) as iotime, 
  ceil(atime/execs) as atime, ceil(ctime/execs) as ctime,
  round(gets/execs, 2) as gets, round(reads/execs, 2) as reads, round(recs/execs, 2) as recs
  , sql_exec_id, sql_exec_start, last_active_time
  , round(percent_rank() over (order by ceil(etime/execs))*100, 2) as p
from target_sqls
where execs > 0
  and etime > 0
/

colu SAMPLING_ETIME_MEAN new_val SETIME_MEAN
colu SAMPLING_EXECS new_val SEXECS
set termout off
select sum(executions) as SAMPLING_EXECS,
  round(sum(elapsed_time)/decode(sum(executions), 0, 1, sum(executions)), 2) as sampling_etime_mean
from &TAB_OWNER..sqltrce_results;
set termout on

prompt ========================================================================================
prompt Sample metrics:
prompt
prompt Executions: &SEXECS
prompt Average elapsed time: &SETIME_MEAN microseconds
prompt ========================================================================================

undef TAB_OWNER
