-- **********************************************************************************
-- SQL tracing / monitoring package:
--   better trace SQL latency with percentiles and histograms
--
-- Report SQL execution ids that "made it" into ASH
--
-- Note: expects that sqltrce_pkg.sample_sql() routine already ran for specific SQL_ID
--
-- Author: Maxym Kharchenko (c - 2014) maxymkharchenko@yahoo.com
-- **********************************************************************************

define TAB_OWNER=&1 -- sqltrce_results table owner

colu status         format A1           heading 'S'
colu exec_id_status format A1           heading 'P'
colu etime          format 999,999,999  heading 'Elapsed|Time'
colu cputime        format 999,999      heading 'CPU|Time'
colu iotime         format 999,999,999  heading 'IO|Time'
colu atime          format 999,999,999  heading 'App|Time'
colu ctime          format 999,999,999  heading 'CC|Time'
colu execs          format 99           heading 'Ex'
colu gets           format 999,999.99   heading 'Gets'
colu reads          format 999,999.99   heading 'Reads'
colu recs           format 999,999.99   heading 'Rows'
colu sample_time    format a25
colu state          format a30

set linesize 220

set termout off
alter session set nls_date_format='YYYY-MM-DD HH24:MI:SS';
alter session set nls_timestamp_format='YYYY-MM-DD HH24:MI:SS';
set termout on

with percentiled_execs as (
  select sql_exec_status, sql_exec_id, sql_exec_status, sql_exec_start, 
    executions as execs,
    ceil(elapsed_time/executions/1000) as etime, 
    ceil(cpu_time/executions/1000) as cputime, 
    ceil(user_io_wait_time/executions/1000) as iotime,
    ceil(application_wait_time/executions/1000) as atime, 
    ceil(concurrency_wait_time/executions/1000) as ctime,
    round(buffer_gets/executions, 2) as gets, 
    round(disk_reads/executions, 2) as reads, 
    round(percent_rank() over (order by ceil(elapsed_time/executions))*100, 2) as p
  from &TAB_OWNER..sqltrce_results
)
select a.sql_exec_id, a.sql_exec_start, a.sample_time,
  case when a.session_state='WAITING' then a.event else 'ON CPU' end as state,
  p.execs, p.p, p.etime, p.cputime, p.iotime, p.atime, p.ctime, p.gets, p.reads
from &TAB_OWNER..sqltrce_ash a, percentiled_execs p
where a.sql_exec_id = p.sql_exec_id
order by p.p
/

undef TAB_OWNER
