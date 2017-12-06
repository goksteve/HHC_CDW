alter session set current_schema = pt005;

UPDATE dbg_process_logs set result = 'Cancelled', end_time = systimestamp
where end_time is null
and proc_id < 121
;
commit;

select
  proc_id, name,
  comment_txt, 
  result,
  start_time,
  case when days > 1 then days||' days ' when days > 0 then '1 day ' end ||
  case when days > 0 or hours > 0 then hours || ' hr ' end ||
  case when days > 0 or hours > 0 or minutes > 0 then minutes || ' min ' end ||
  round(seconds)|| ' sec' time_spent
from
(
  select
    proc_id, name, comment_txt, result,
    start_time, end_time,
    extract(day from diff) days, extract(hour from diff) hours, extract(minute from diff) minutes, extract(second from diff) seconds
  from
  ( 
    select l.*, nvl(end_time, systimestamp) - start_time diff 
    from dbg_process_logs l
  )
)
order by proc_id desc;

select * from dbg_log_data
where proc_id = 3
order by tstamp desc;

select proc_id, action, cnt, seconds 
from dbg_performance_data 
where proc_id = 117
order by seconds desc;

select *
from
(
  select proc_id, action, cnt, seconds 
  from dbg_performance_data 
  where proc_id in (98, 100)
--  and action like 'Adding%'
)
pivot 
(
  max(cnt) cnt,
  max(seconds) sec
  for proc_id in (98, 100)
)
order by 3 desc;

select * from err_edd_fact_stats
where ora_err_tag$ = '118'; 