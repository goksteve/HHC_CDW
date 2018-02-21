@@saveset

set termout off

var sql_id varchar2(30)
exec :sql_id := '&1'

set termout on

col executions              format 999,999,999      heading 'Execs'
col ela                     format 99,999.99        heading 'Elapsed|s'
col ela_exec                format 999,999.999      heading 'Ela/exec|s'
col cpu_time                format 99,999.99        heading 'CPU, s'
col gets_exec               format 999,999,999      heading 'Gets/exec'
col rows_per_exec           format 999,999,999      heading 'Rows per|exec'
col version_count           format 99,999           heading 'Versi|ons'
col loaded_versions         format 99,999           heading 'Loaded|vers'
col loads                   format 99,999           heading 'Loads'
col share_mem               format 999.99           heading 'Share|Mem, MB'

select executions,
       elapsed_time/1e6 ela,
       elapsed_time/nullif(executions, 0)/1e6 ela_exec,
       cpu_time/1e6 cpu_time,
       buffer_gets/executions gets_exec,
       rows_processed/nullif(executions, 0) rows_per_exec,
       version_count,
       loaded_versions,
       loads,
       sharable_mem/1024/1024 share_mem       
  from v$sqlarea
 where sql_id = :sql_id;
  
@@loadset