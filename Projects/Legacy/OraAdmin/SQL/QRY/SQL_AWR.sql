-- To see SQL statements executed in Toad by user OK in the last 24 hours:
select s.dbid, s.sql_id, s.sql_text
from
(
  select distinct sh.top_level_sql_id sql_id
  from dba_users u
  join dba_hist_active_sess_history sh on sh.user_id = u.user_id
  where u.username = 'OK'
  and sh.snap_id >= 
  (
    select min(snap_id)
    from dba_hist_snapshot /* or dba_hist_ash_snapshot*/
    where begin_interval_time > systimestamp - interval '24' hour
  )
  and sh.program = 'Toad.exe'
) h
join dba_hist_sqltext s on s.sql_id = h.sql_id;

/* From the previous query I got:
DBID        SQL_ID          SQL_TESXT
----------  --------------  -----------------------------
1937289485	91mhcwz2h69k8	  'Select cols.column_id,  ...'
*/

-- To see the list of execution plans generated for this particular SQL
-- (It can be several different plans for one statement):
select distinct dbid, sql_id, plan_hash_value
from dba_hist_sql_plan
where dbid = 1937289485
and sql_id = '91mhcwz2h69k8';
/*
  Here is what I got:
  
  DBID	      SQL_ID	      PLAN_HASH_VALUE
  ----------  ------------- ---------------
  1937289485	91mhcwz2h69k8	2800819538
  1937289485	91mhcwz2h69k8	609874468
*/

-- To see the details of a particular execution plan:
SELECT * FROM table
(
  DBMS_XPLAN.DISPLAY_AWR
  (
    sql_id => '91mhcwz2h69k8',
    plan_hash_value => 609874468,
    db_id => 1937289485,
    format => 'TYPICAL'
  )
);

-- To see the details of all the executions of that statement: 
select s.begin_interval_time, s.end_interval_time, ss.* 
from dba_hist_sqlstat ss
join dba_hist_snapshot s on s.snap_id = ss.snap_id and s.dbid = ss.dbid and s.instance_number = ss.instance_number
where 1=1
and ss.dbid = 1937289485
and ss.sql_id = '91mhcwz2h69k8'
--and ss.plan_hash_value = 609874468 -- you may skip this conditions if you want to see execution statistics for all execution plans
order by 1
;
