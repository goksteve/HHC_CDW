@@saveset

col begin_tim               format a15              heading 'Begin time'
col end_tim                 format a15              heading 'End time'
col cpu_time                format 99,999.99        heading 'CPU, s'
col ela                     format 99,999.99        heading 'Elapsed|s'
col exe                     format 999,999,999      heading 'Execs'
col ela_exec                format 999,999.999      heading 'Ela/exec|s'
col phy_reads               format 999,999,999      heading 'Physical|reads'
col share_mem               format 999.99           heading 'Share|Mem, MB'
col version_count           format 99,999           heading 'Versi|ons'
col loaded_versions         format 99,999           heading 'Loaded|vers'

select to_char(s.begin_interval_time, 'YYYYMMDD HH24:MI') begin_tim
     , to_char(s.end_interval_time, 'YYYYMMDD HH24:MI') end_tim
     , ss.cpu_time_delta/1e6 cpu_time
     , ss.elapsed_time_delta/1e6 ela
     , executions_delta exe
     , ss.elapsed_time_delta/nullif(ss.executions_delta, 0)/1e6 ela_exec
     , ss.physical_read_requests_delta phy_reads
     , ss.sharable_mem/1024/1024 share_mem
     , ss.loaded_versions
     , ss.version_count
  from dba_hist_sqlstat ss, dba_hist_snapshot s
 where ss.dbid = (select dbid from v$database)
   and s.instance_number = (select i.instance_number from v$instance i)
   and ss.dbid = s.dbid   
   and ss.snap_id = s.snap_id
   and s.begin_interval_time between date '&begin_date' and date '&end_date'
   and ss.sql_id = '&sql_id'
 order by s.begin_interval_time;
 
@@loadset