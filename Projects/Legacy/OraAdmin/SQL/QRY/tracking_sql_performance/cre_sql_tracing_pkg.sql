-- **********************************************************************************
-- SQL tracing / monitoring package
--   better trace SQL latency with percentiles and histograms
--
-- PLSQL package to "sample" or "monitor" inividual sql executions
--
-- Author: Maxym Kharchenko (c - 2014) maxymkharchenko@yahoo.com
-- **********************************************************************************

define P_OWNER=&1
define P_TBS=&2
define P_DEBUG=1

create table &P_OWNER..sqltrce_ash tablespace &P_TBS
as select * from v$active_session_history where 1=0
/

create table &P_OWNER..sqltrce_sql_monitor tablespace &P_TBS
as select * from v$sql_monitor where 1=0
/

create table &P_OWNER..sqltrce_results (
  sql_exec_id number,
  sql_exec_status char(1),
  sql_exec_start date,
  last_active_time date,
  machine varchar2(64),
  parse_calls number,
  executions number,
  fetches number,
  rows_processed number,
  buffer_gets number,
  disk_reads number,
  elapsed_time number,
  cpu_time number,
  user_io_wait_time number,
  application_wait_time number,
  concurrency_wait_time number
) tablespace &P_TBS
/

create or replace package &P_OWNER..sqltrce_pkg as
  -- ***********************************************************************************
  -- "Trace" sql_id/child_number by 
  --   High Frequency sampling v$sql view:
  --   (hopefully) capturing individual sql executions
  -- ***********************************************************************************
  procedure sample_sql (
    sql_id                 in varchar2,               -- sql_id to trace
    child_number           in number,                 -- child_number to trace
    duration               in number := 60,           -- trace duration in seconds
    save_ash               in varchar2 := 'FALSE',    -- whether to save ASH data (for this cursor)
    sample_batch           in number := 1000,         -- (initial) # of times to query v$sql in the inner NL join
    exponential_sampling   in number := 2,            -- if > 0, increase batch size by if found no executions
    keep_in_memory         in varchar2 := 'TRUE',     -- 'TRUE' - keep the entire result set in memory, 
                                                      -- 'FALSE' - write to disk after each batch
    cleanup_previous       in varchar2 := 'TRUE'      -- Cleanup (truncate) previous results before starting
  );

  -- ***********************************************************************************
  -- "Trace" sql_id/child_number by 
  --   High Frequency sampling v$sql view:
  --   (hopefully) capturing individual sql executions
  -- Overloaded procedure:
  --   + return execution statistics
  -- ***********************************************************************************
  procedure sample_sql (
    sql_id               in varchar2,                 -- sql_id to trace
    child_number         in number,                   -- child_number to trace
    duration             in number := 60,             -- trace duration in seconds
    save_ash             in varchar2 := 'FALSE',      -- whether to save ASH data (for this cursor)
    sample_batch         in number := 1000,           -- (initial) # of times to query v$sql in the inner NL join
    exponential_sampling in number := 2,              -- if > 0, increase batch size by if found no executions
    keep_in_memory       in varchar2 := 'TRUE',       -- 'TRUE' - keep the entire result set in memory,
                                                      -- 'FALSE' - write to disk after each batch
    cleanup_previous     in varchar2 := 'TRUE',       -- Cleanup (truncate) previous results before starting
    executions_captured  out number,                  -- # of SQL executions captured by sampling
    executions_expected  out number,                  -- # of SQL exucutions recorded in v$SQL
    batches_executed     out number,                  -- # of "sample SQLs" executed
    ash_captured         out number,                  -- # of ASH events captured
    start_time           out date,                    -- Actual start time
    end_time             out date                     -- Actual end time
  );

  -- ***********************************************************************************
  -- "trace" sql_id by attaching MONITOR hint
  --   and recording individual executions from v$sql_monitor
  -- ***********************************************************************************
  procedure monitor_sql (
    sql_id           in varchar2,                 -- sql_id to trace
    duration         in number   := 60,           -- (max) trace duration in seconds
                                                  --   tracing will stop if max_executions has been collected
    wait_on_first    in number := 60,             -- seconds to wait for cursor with MONITOR hint to appear
                                                  --   check is done every second
    save_sqlmon      in varchar2 := 'TRUE',       -- whether to save v$sql_monitor data to sqltrce_sql_monitor
    save_ash         in varchar2 := 'FALSE',      -- whether to save ASH data to sqltrce_ash
    max_executions   in number   := 100,          -- MAX # of individual executions to collect
    cleanup_previous in varchar2 := 'TRUE'        -- Cleanup (truncate) previosly collected data
  );

  -- ***********************************************************************************
  -- "trace" sql_id by attaching MONITOR hint
  --   and recording individual executions from v$sql_monitor
  -- Overloaded procedure:
  --   + return execution statistics
  -- ***********************************************************************************
  procedure monitor_sql (
    sql_id           in varchar2,                 -- sql_id to trace
    duration         in number   := 60,           -- (max) trace duration in seconds
                                                  --   tracing will stop if max_executions has been collected
    wait_on_first    in number := 60,             -- seconds to wait for cursor with MONITOR hint to appear
                                                  --   check is done every second
    save_sqlmon      in varchar2 := 'TRUE',       -- whether to save v$sql_monitor data to sqltrce_sql_monitor
    save_ash         in varchar2 := 'FALSE',      -- whether to save ASH data to sqltrce_ash
    max_executions   in number   := 100,          -- MAX # of individual executions to collect
    cleanup_previous in varchar2 := 'TRUE',       -- Cleanup (truncate) previosly collected data
    seconds_before_first out number,              -- # of seconds before MONITOR cursor is detected
    sqlmon_captured      out number,              -- Actual # of sql_id executions captured in v$sql_monitor
    ash_captured         out number,              -- # of ASH records captured
    start_time           out date,                -- Actual start time
    end_time             out date                 -- Actual end time
  );
end sqltrce_pkg;
/

-- Setting debug mode
-- 0 = "disable", 1 = "enable"
alter session set plsql_ccflags = 'debug:&P_DEBUG';

create or replace package body &P_OWNER..sqltrce_pkg as

  -- ***********************************************************************************
  -- PRIVATE PROCEDURES
  -- ***********************************************************************************

  -- ***********************************************************************************
  -- Print debug message
  -- ***********************************************************************************
  procedure debug(msg in varchar2)
  as
  begin
    $IF 1 = $$debug
    $THEN
      dbms_output.put_line(to_char(sysdate, 'YYYY-MM-DD HH24:MI:SS')||' '||msg);
    $ELSE
      null;
    $END
  end debug;

  -- ***********************************************************************************
  -- "Trace" sql_id/child_number by 
  --   High Frequency sampling v$sql view:
  --   (hopefully) capturing individual sql executions
  --
  -- PRIVATE PROCEDURE: actually does all the work
  -- ***********************************************************************************
  procedure p_sample_sql (
    sql_id               in varchar2,                 -- sql_id to trace
    child_number         in number,                   -- child_number to trace
    duration             in number,                   -- trace duration in seconds
    save_ash             in varchar2,                 -- whether to save ASH data (for this cursor)
    sample_batch         in number,                   -- (initial) # of times to query v$sql in the inner NL join
    exponential_sampling in number,                   -- if > 0, increase batch size by if found no executions
    keep_in_memory       in varchar2,                 -- 'TRUE' - keep the entire result set in memory,
                                                      -- 'FALSE' - write to disk after each batch
    cleanup_previous     in varchar2,                 -- Cleanup (truncate) previous results before starting
    executions_captured  out number,                  -- # of SQL executions captured by sampling
    executions_expected  out number,                  -- # of SQL exucutions recorded in v$SQL
    batches_executed     out number,                  -- # of "sample SQLs" executed
    ash_captured         out number,                  -- # of ASH events captured
    start_time           out date,                    -- Actual start time
    end_time             out date                     -- Actual end time
  ) as
    type tResults_t is table of &P_OWNER..sqltrce_results%rowtype;
    tFinal tResults_t := tResults_t();
    tIntermediate tResults_t := tResults_t();

    dStartTime date;
    dCurStart  date;
    dEndTime   date;

    nExecsBegin v$sql.executions%type;
    nExecsEnd   v$sql.executions%type;
    nBatches    number := 0;

    nCaptured      number := 0;
    nCapturedDelta number;

    szSqlId      v$sql.sql_id%type := sql_id;
    nChildNumber v$sql.child_number%type := child_number;

    nSampleBatch number := sample_batch;
  begin
    -- Do the cleanup if requested
    if 'TRUE' = upper(cleanup_previous) then
      debug('Truncating sqltrce_ash and sqltrce_results');
      execute immediate 'truncate table &P_OWNER..sqltrce_ash';
      execute immediate 'truncate table &P_OWNER..sqltrce_results';
    end if;

    dStartTime := sysdate;
    dEndTime := sysdate;

    -- Capture 'BEFORE' executions
    select executions into nExecsBegin from v$sql s where s.sql_id=szSqlId and s.child_number = nChildNumber;
    debug('BEGIN executions '||to_char(nExecsBegin));

    while((dEndTime-dStartTime) < duration/(24*3600)) loop
      nBatches := nBatches +1;
      dCurStart := sysdate;
      debug('Batch #'||to_char(nBatches)||' start: '||to_char(dCurStart, 'YYYY-MM-DD HH24:MI:SS'));

      -- "Sample" into v$sql nSampleBatch times
      with i_gen as (
        select level as l from dual connect by level <= nSampleBatch
      ), target_sqls as (
        select /*+ ordered no_merge use_nl(s) */
          i.l,
          case when s.address=se.sql_address and s.plan_hash_value=se.sql_hash_value
            then se.sql_exec_id else se.prev_exec_id end as sql_exec_id,
          case when s.address=se.sql_address and s.plan_hash_value=se.sql_hash_value
            then '' else 'P' end as sql_exec_status,
          case when s.address=se.sql_address and s.plan_hash_value=se.sql_hash_value
            then se.sql_exec_start else se.prev_exec_start end as sql_exec_start,
          s.last_active_time,
          se.machine,
          s.parse_calls-lag(s.parse_calls,1) over (order by 1) as parse_calls,
          s.executions-lag(s.executions,1) over (order by 1) as executions,
          s.fetches-lag(s.fetches,1) over (order by 1) as fetches,
          s.rows_processed-lag(s.rows_processed,1) over (order by 1) as rows_processed,
          s.buffer_gets-lag(s.buffer_gets,1) over (order by 1) as buffer_gets,
          s.disk_reads-lag(s.disk_reads,1) over (order by 1) as disk_reads,
          s.elapsed_time-lag(s.elapsed_time,1) over (order by 1) as elapsed_time,
          s.cpu_time-lag(s.cpu_time,1) over (order by 1) as cpu_time,
          s.user_io_wait_time-lag(s.user_io_wait_time,1) over (order by 1) as user_io_wait_time,
          s.application_wait_time-lag(s.application_wait_time,1) over (order by 1) as application_wait_time,
          s.concurrency_wait_time-lag(s.concurrency_wait_time,1) over (order by 1) as concurrency_wait_time
        from i_gen i, gv$sql s, gv$session se
        where s.sql_id=szSqlId
          and s.child_number=nChildNumber
          and (
            (s.address=se.sql_address and s.plan_hash_value=se.sql_hash_value)
            or
            (s.address=se.prev_sql_addr)
        )
      )
      select sql_exec_id, sql_exec_status, sql_exec_start, last_active_time, machine,
        parse_calls, executions, fetches, rows_processed, buffer_gets, disk_reads,
        elapsed_time, cpu_time, user_io_wait_time, application_wait_time, concurrency_wait_time
      bulk collect into tIntermediate
      from target_sqls
      where executions > 0
      ;

      dEndTime := sysdate;
      debug('Batch #'||to_char(nBatches)||' end: '||to_char(dEndTime, 'YYYY-MM-DD HH24:MI:SS'));
      debug('Batch #'||to_char(nBatches)||' executions captured: '||to_char(tIntermediate.count()));
      
      -- Increase the sample size if we are using exponential sampling
      -- and could not find anything during current batch
      if exponential_sampling > 0 and 0 = tIntermediate.count() then
        if dStartTime + (dEndTime-dCurStart)*exponential_sampling < dStartTime + duration/(24*3600) 
        then
          debug('EXP: Increasing batch size '||nSampleBatch||' by '||to_char(exponential_sampling));
          nSampleBatch := nSampleBatch * exponential_sampling;
        else
          debug('EXP: Running final batch - size '||nSampleBatch||' is big enough');
        end if;
      end if;

      -- Merge with TOTAL results or dump to disk
      if tIntermediate.count() > 0 then
        -- Calculate # of executions captured (trick: each "row" might record multiple executions)
        -- nCaptured := nCaptured + tIntermediate.count();
        nCapturedDelta := 0;
        for i in tIntermediate.first .. tIntermediate.last loop
          nCapturedDelta := nCapturedDelta + tIntermediate(i).executions;
        end loop;
        nCaptured := nCaptured + nCapturedDelta;

        if 'TRUE' = upper(keep_in_memory) then
          tFinal := tFinal multiset union tIntermediate;
        else
          forall i in tIntermediate.first() .. tIntermediate.last()
            insert into &P_OWNER..sqltrce_results values tIntermediate(i);
          commit;
        end if;
      end if;
    end loop;

    -- Capture 'AFTER' # of exexutions from v$sql
    select executions into nExecsEnd from v$sql s where s.sql_id=szSqlId and s.child_number = nChildNumber;
    debug('END executions '||to_char(nExecsEnd));

    -- Final dump to disk
    if 'TRUE' = upper(keep_in_memory) and tFinal.count() > 0 then
      forall i in tFinal.first() .. tFinal.last()
        insert into &P_OWNER..sqltrce_results values tFinal(i);
      commit;
    end if;

    -- Capture ASH if requested
    ash_captured := 0;
    if 'TRUE' = upper(save_ash) then
      debug('Capturing ASH');
      insert into &P_OWNER..sqltrce_ash 
        (select *
         from v$active_session_history
         where sql_id=szSqlId
           and sql_child_number=nChildNumber
           and sample_time between dStartTime and dEndTime
        );
      ash_captured := sql%rowcount;
      commit;
    end if;

    executions_captured := nCaptured;
    executions_expected := nExecsEnd-nExecsBegin;
    batches_executed    := nBatches;
    start_time          := dStartTime;
    end_time            := dEndTime;

    -- Print execution statistics
    dbms_output.put_line('Executions captured: '||to_char(executions_captured));
    dbms_output.put_line('Executions expected: '||to_char(executions_expected));
    dbms_output.put_line('Batches executed: '||to_char(batches_executed));
    dbms_output.put_line('ASH events captured: '||to_char(ash_captured));
    dbms_output.put_line('Actual start time: '||to_char(start_time, 'YYYY-MM-DD HH24:MI:SS'));
    dbms_output.put_line('Actual end time: '||to_char(end_time, 'YYYY-MM-DD HH24:MI:SS'));
  end p_sample_sql;

  -- ***********************************************************************************
  -- "trace" sql_id by attaching MONITOR hint
  --   and recording individual executions from v$sql_monitor
  --
  -- PRIVATE PROCEDURE: actually does all the work
  -- ***********************************************************************************
  procedure p_monitor_sql (
    sql_id           in varchar2,                 -- sql_id to trace
    duration         in number,                   -- (max) trace duration in seconds
                                                  --   tracing will stop if max_executions has been collected
    wait_on_first    in number,                   -- seconds to wait for cursor with MONITOR hint to appear
                                                  --   check is done every second
    save_sqlmon      in varchar2,                 -- whether to save v$sql_monitor data to sqltrce_sql_monitor
    save_ash         in varchar2,                 -- whether to save ASH data to sqltrce_ash
    max_executions   in number,                   -- MAX # of individual executions to collect
    cleanup_previous in varchar2,                 -- Cleanup (truncate) previosly collected data
    seconds_before_first out number,              -- # of seconds before MONITOR cursor is detected
    sqlmon_captured      out number,              -- Actual # of sql_id executions captured in v$sql_monitor
    ash_captured         out number,              -- # of ASH records captured
    start_time           out date,                -- Actual start time
    end_time             out date                 -- Actual end time
  ) as
    szSqlId      v$sql.sql_id%type := sql_id;
    szSqlText    v$sqlarea.sql_fulltext%type;
    szSqlProfile v$sql.sql_profile%type;

    nMaxPlan       number;
    nCurMaxPlan    number;
    nChildNumber   v$sql.child_number%type;
    rChildAddress  v$sql.child_address%type;
    nExecsCaptured number;

    dStartTime date;
    dEndTime   date;

    i number;
  begin
    -- Do the cleanup if requested
    if 'TRUE' = upper(cleanup_previous) then
      debug('Cleaning sqltrce_ash and sqltrce_sql_monitor');
      execute immediate 'truncate table &P_OWNER..sqltrce_ash';
      execute immediate 'truncate table &P_OWNER..sqltrce_sql_monitor';
    end if;

    -- Adding MONITOR hint to sql_id
    szSqlProfile := 'PROFILE_'||szSqlId;
    debug('Building SQL profile: '||szSqlProfile);

    select sql_fulltext into szSqlText from v$sqlarea where sql_id = szSqlId;

    dStartTime := sysdate;
    debug('Start time: '||to_char(dStartTime, 'YYYY-MM-DD HH24:MI:SS'));

    dbms_sqltune.import_sql_profile(
      sql_text => szSqlText,
      profile => sqlprof_attr('MONITOR'),
      name => szSqlProfile,
      force_match => TRUE
    );
    debug('SQL profile: '||szSqlProfile||' added');

    -- Now, we wait until we can see a cursor with our PROFILE attached
    i := 1;
    while true loop
      begin
        select child_number, child_address into nChildNumber, rChildAddress
        from v$sql where sql_id=szSqlId and sql_profile=szSqlProfile;

        -- If we reached this point, we found our cursor - exit immediately
        exit;
      exception
        when no_data_found then
          if i <= wait_on_first then
            i := i + 1;
          else
            raise_application_error(-20001, 'Unable to find cursor with MONITOR in '||to_char(wait_on_first)||' seconds');
          end if;
      end;

      -- Wait 1 second between retries
      dbms_lock.sleep(1);
    end loop;

    debug('Found cursor with MONITOR in '||to_char(i)||' 1 second tries');
    seconds_before_first := i;

    -- Cursor with MONITOR exists - let's trace it until we capture max_executions
    i := 1;
    while true loop
      select count(1) into nExecsCaptured from v$sql_monitor where sql_id=szSqlId
      and sql_child_address = rChildAddress;

      exit when nExecsCaptured >= max_executions or i >= duration;
      
      -- Wait 1 second between retries
      dbms_lock.sleep(1);
      i := i + 1;
    end loop;

    dEndTime := sysdate;
    debug('End time: '||to_char(dEndTime, 'YYYY-MM-DD HH24:MI:SS'));

    debug('Dropping SQL profile: '||szSqlProfile);
    dbms_sqltune.drop_sql_profile(szSqlProfile);

    sqlmon_captured := nExecsCaptured;
    debug('(preliminary) Executions captured: '||to_number(nExecsCaptured));

    if 'TRUE' = upper(save_sqlmon) then
      debug('Dumping v$sql_monitor to sqltrce_sql_monitor');
      insert into &P_OWNER..sqltrce_sql_monitor
        (select *
         from v$sql_monitor
         where sql_id=szSqlId
           and sql_child_address = rChildAddress
           and sql_exec_start between dStartTime and dEndTime
        );
      sqlmon_captured := sql%rowcount;
      commit;
    end if;

    ash_captured := 0;
    if 'TRUE' = upper(save_ash) then
      debug('Capturing ASH');
      insert into &P_OWNER..sqltrce_ash 
        (select *
         from v$active_session_history
         where sql_id=szSqlId
           and sql_child_number = nChildNumber
           and sample_time between dStartTime and dEndTime
        );
      ash_captured := sql%rowcount;
      commit;
    end if;

    start_time := dStartTime; 
    end_time   := dEndTime;

    -- Print execution statistics
    dbms_output.put_line('Seconds until MONITOR cursor found: '||to_char(seconds_before_first));
    dbms_output.put_line('Executions captured: '||to_char(sqlmon_captured));
    dbms_output.put_line('ASH events captured: '||to_char(ash_captured));
    dbms_output.put_line('Actual start time: '||to_char(start_time, 'YYYY-MM-DD HH24:MI:SS'));
    dbms_output.put_line('Actual end time: '||to_char(end_time, 'YYYY-MM-DD HH24:MI:SS'));
  end p_monitor_sql;

  -- ***********************************************************************************
  -- PUBLIC PROCEDURES
  -- ***********************************************************************************

  -- ***********************************************************************************
  -- Sample_sql: Main procedure:
  --   Trace (hopefully) individual sql executions
  -- ***********************************************************************************
  procedure sample_sql (
    sql_id               in varchar2,
    child_number         in number,
    duration             in number := 60,
    save_ash             in varchar2 := 'FALSE',
    sample_batch         in number := 1000,
    exponential_sampling in number := 2,
    keep_in_memory       in varchar2 := 'TRUE',
    cleanup_previous     in varchar2 := 'TRUE'
  ) as
     nExecutionsCaptured number;
     nExecutionsRecorded number;
     nBatchesExecuted    number;
     nAshCaptured        number;
     dStartTime          date;
     dEndTime            date;
  begin
    p_sample_sql(
      sql_id, child_number, duration, save_ash, sample_batch, exponential_sampling,
      keep_in_memory, cleanup_previous,
      nExecutionsCaptured, nExecutionsRecorded, nBatchesExecuted, nAshCaptured, dStartTime, dEndTime
    );
  end sample_sql;

  -- ***********************************************************************************
  -- sample_sql: Overloaded procedure:
  --   Sample (hopefully) individual sql executions
  --   + return execution statistics
  -- ***********************************************************************************
  procedure sample_sql (
    sql_id               in varchar2,
    child_number         in number,
    duration             in number := 60,
    save_ash             in varchar2 := 'FALSE',
    sample_batch         in number := 1000,
    exponential_sampling in number := 2,
    keep_in_memory       in varchar2 := 'TRUE',
    cleanup_previous     in varchar2 := 'TRUE',
    executions_captured  out number,
    executions_expected  out number,
    batches_executed     out number,
    ash_captured         out number,
    start_time           out date,
    end_time             out date
  ) as
  begin
    p_sample_sql(
      sql_id, child_number, duration, save_ash, sample_batch, exponential_sampling,
      keep_in_memory, cleanup_previous,
      executions_captured, executions_expected, batches_executed, ash_captured, start_time, end_time
    );
  end sample_sql;

  -- ***********************************************************************************
  -- "trace" sql_id by attaching MONITOR hint
  --   and recording individual executions from v$sql_monitor
  -- ***********************************************************************************
  procedure monitor_sql (
    sql_id           in varchar2,                 -- sql_id to trace
    duration         in number   := 60,           -- (max) trace duration in seconds
                                                  --   tracing will stop if max_executions has been collected
    wait_on_first    in number := 60,             -- seconds to wait for cursor with MONITOR hint to appear
                                                  --   check is done every second
    save_sqlmon      in varchar2 := 'TRUE',       -- whether to save v$sql_monitor data to sqltrce_sql_monitor
    save_ash         in varchar2 := 'FALSE',      -- whether to save ASH data to sqltrce_ash
    max_executions   in number   := 100,          -- MAX # of individual executions to collect
    cleanup_previous in varchar2 := 'TRUE'        -- Cleanup (truncate) previosly collected data
  ) as
    nSecondsBeforeFirst number;
    nSqlmonCaptured     number;
    nAshCaptured        number;
    dStartTime          date;
    dEndTime            date;
  begin
    p_monitor_sql(
      sql_id, duration, wait_on_first, save_sqlmon, save_ash, max_executions, cleanup_previous,
      nSecondsBeforeFirst, nSqlmonCaptured, nAshCaptured, dStartTime, dEndTime
    );
  end monitor_sql;

  -- ***********************************************************************************
  -- "trace" sql_id by attaching MONITOR hint
  --   and recording individual executions from v$sql_monitor
  -- Overloaded procedure:
  --   + return execution statistics
  -- ***********************************************************************************
  procedure monitor_sql (
    sql_id           in varchar2,                 -- sql_id to trace
    duration         in number   := 60,           -- (max) trace duration in seconds
                                                  --   tracing will stop if max_executions has been collected
    wait_on_first    in number := 60,             -- seconds to wait for cursor with MONITOR hint to appear
                                                  --   check is done every second
    save_sqlmon      in varchar2 := 'TRUE',       -- whether to save v$sql_monitor data to sqltrce_sql_monitor
    save_ash         in varchar2 := 'FALSE',      -- whether to save ASH data to sqltrce_ash
    max_executions   in number   := 100,          -- MAX # of individual executions to collect
    cleanup_previous in varchar2 := 'TRUE',       -- Cleanup (truncate) previosly collected data
    seconds_before_first out number,              -- # of seconds before MONITOR cursor is detected
    sqlmon_captured      out number,              -- Actual # of sql_id executions captured in v$sql_monitor
    ash_captured         out number,              -- # of ASH records captured
    start_time           out date,                -- Actual start time
    end_time             out date                 -- Actual end time
  ) as
  begin
    p_monitor_sql(
      sql_id, duration, wait_on_first, save_sqlmon, save_ash, max_executions, cleanup_previous,
      seconds_before_first, sqlmon_captured, ash_captured, start_time, end_time
    );
  end monitor_sql;

end sqltrce_pkg;
/

select * from dba_errors where owner=upper('&P_OWNER') and name='SQLTRCE_PKG';

undef P_OWNER
undef P_TBS
undef P_DEBUG
