select
  name, street_address, city, state, postal_code,
  'OTHER_FACILITY' src, network src_network, other_facility_id facility_id
from other_facility
where name not like 'z%' and name not like 'Department%' and lower(name) not like 'shell%' and name not like '%not use%'
union all
select
  name,
  null, null, null, null,
  'FACILITY' src, network src_network, facility_id 
from facility
where facility_id <> -1 and name not like 'zz%'
and (network <> 'QHN' or facility_id not in (4, 5)) -- Jacobi Medical Center and North Central Bronx Hospital are in NBX network  
order by name, src, src_network;

select --+ parallel(16) 
  count(1) cnt,
  count(pe.facility_id) evnt_fac_id_cnt, 
  count(p.facility_id) proc_fac_id_cnt,
  count(case when pe.facility_id = p.facility_id then 1 end) equal,
  count(case when pe.facility_id <> p.facility_id then 1 end) not_equal,
  count(case when pe.facility_id is null then 1 end) null_in_pe,
  count(case when p.facility_id is null then 1 end) null_in_proc
from proc_event pe
join visit v on v.network = pe.network and v.visit_id = pe.visit_id
join proc p on p.network = pe.network and p.proc_id = pe.proc_id; -- 1,682,876,081

select network, count(1) cnt, count(facility_id) fac_cnt, count(distinct facility_id) fac_uniq
from proc
group by network;
-- 99.99% rows have FACILITY_ID

select network, facility_id from proc where facility_id is not null
minus
select network, facility_id from facility;
-- No rows reterned

select --+ parallel(16) 
  network, facility_id from proc_event where facility_id is not null
minus
select network, facility_id from facility;
-- No rows returned

select --+ parallel(16)
 facility_id, count(1) cnt
from proc_event
where network = 'QHN'
group by facility_id; 