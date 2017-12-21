with
  det as
  (
    select
      level lvl,
      network,
      facility_id, location_id, name,
      sys_connect_by_path(nvl(name, 'NA'), '~') path_name,
      case when upper(bed) = 'TRUE' then 'True' else 'False' end bed_flag
    from location
    connect by network = prior network and parent_location_id = prior location_id and location_id <> prior location_id 
    start with parent_location_id is null or location_id = '-1'
  )
select --+ parallel(16)
  *
from
(
  select
    d.lvl, d.network, sum(vl.cnt) cnt
  from
  (
    select network, location_id, count(1) cnt
    from visit_segment_visit_location
    group by network, location_id
  ) vl
  join det d on d.network = vl.network and d.location_id = vl.location_id
  group by d.lvl, d.network
)
pivot (max(cnt) for lvl in (1,2,3))
order by network;
