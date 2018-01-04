-- QMED Location stats:
with
  loc as
  (
    select
      level lvl,
      network,
      facility_id, location_id, name,
      sys_connect_by_path(nvl(name, 'NA'), '~') path_name,
      case when upper(bed) = 'TRUE' then 1 else 0 end bed_flag
    from location
    connect by network = prior network and parent_location_id = prior location_id and location_id <> prior location_id 
    start with parent_location_id is null or location_id = '-1'
  ),
  loc_stat as
  (
    select network, lvl, count(1) cnt, sum(bed_flag) bed_cnt
    from loc
    group by network, lvl
  ),
  vloc_stat as
  (
    select
      v.network, nvl(l.lvl, 0) lvl,
      count(distinct v.visit_id) visit_cnt,
      count(distinct vl.visit_id) vloc_cnt,
      count(distinct l.location_id) loc_cnt,
      count(distinct decode(l.bed_flag, 1, l.location_id)) bed_cnt
    from visit v
    left join visit_segment_visit_location vl on vl.network = v.network and vl.visit_id = v.visit_id
    left join loc l on l.network = vl.network and l.location_id = vl.location_id
    group by v.network, l.lvl
  )
--select * from loc where lvl = 3 and bed_flag = 0 or lvl = 2 and bed_flag = 1;
select /*+ parallel(16)*/ *
--from loc_stat pivot (max(cnt) cnt, max(bed_cnt) bed_cnt for lvl in (1,2,3))
from vloc_stat pivot(sum(visit_cnt) visits, sum(vloc_cnt) visits_with_loc, sum(loc_cnt) loc_cnt, sum(bed_cnt) bed_cnt for lvl in (0,1,2,3)) 
--from loc_stat pivot (max(cnt) cnt, max(bed_cnt) bed_cnt for lvl in (1,2,3))
order by network;

select count(1) -- 115,606,481
from visit;

