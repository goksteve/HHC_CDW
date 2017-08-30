-- To see SQL statements executed in Toad by user KHAYKINO in the last 24 hours:
select s.sql_id, s.sql_text
from
( 
  select distinct s.top_level_sql_id sql_id
  from dba_users u
  join dba_hist_active_sess_history sh on sh.user_id = u.user_id
  where u.username = 'KHAYKINO'
  and sh.snap_id >= 
  (
    select min(snap_id)
    from dba_hist_snapshot
    where begin_interval_time > systimestamp - interval '24' hour
  )
  and sh.program = 'Toad.exe'
) h
join dba_hist_sqltext s on s.sql_id = h.sql_id;

-- To see the list of execution plans generated for a particular SQL
-- (can be several different plans for one statement):
select distinct dbid, sql_id, plan_hash_value
from dba_hist_sql_plan
where sql_id = '6mmau7h67db7j';

-- To see the details of a particular execution plan:
SELECT * FROM table
(
  DBMS_XPLAN.DISPLAY_AWR
  (
    sql_id => '6mmau7h67db7j',
    plan_hash_value => 1614722850,
    db_id => 1939191588,
    format => 'TYPICAL'
  )
);
desc v$sqlAREA;
