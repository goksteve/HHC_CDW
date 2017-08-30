alter session set current_schema = pt008;

select
  proc_id, name,
--  comment_txt, 
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
    where name = 'SP_REFRESH_EDD_STATS'
    and start_time > systimestamp - interval '4' day
  )
)
order by proc_id desc;

select * from dbg_log_data
where proc_id = 76
order by tstamp;

select *
from
(
  select proc_id, action, seconds 
  from dbg_performance_data 
  where proc_id >= 50
  and action like 'Adding%'
  order by seconds desc
)
pivot 
(
  max(seconds)
  for proc_id in (50, 51, 55)
);

select ora_err_mesg$, count(1) cnt
from err_edd_fact_visits
where ora_err_tag$ = '29'
group by ora_err_mesg$;
--select * from err_edd_fact_stats
select ora_err_mesg$, count(1) cnt from err_edd_fact_metric_values
where ora_err_tag$ = '37'
group by ora_err_mesg$;
