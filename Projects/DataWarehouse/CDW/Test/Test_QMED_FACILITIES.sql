select
  name, 'OTHER_FACILITY' src,
  street_address, city, state, postal_code,
  network src_network, other_facility_id facility_id
from tst_ok_other_facilities
--where name not like 'z%' and name not like 'Department%' and lower(name) not like 'shell%' and name <> 'Do not use'
where city = 'Atlanta' and state = 'GA'
union all
select
  name, 'FACILITY' src,
  null, null, null, null,
  network, facility_id 
from facility
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
