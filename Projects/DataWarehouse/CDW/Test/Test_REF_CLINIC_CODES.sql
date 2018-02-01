select *
from
(
  select 'REF_CLINIC_CODES' src, network, count(1) cnt
  from ref_clinic_codes
  group by network
  union 
  select 'HHC_CLINIC_CODES', network, count(1) cnt
  from hhc_clinic_codes
  group by network
)
pivot
(
  max(cnt) cnt
  for src in ('REF_CLINIC_CODES', 'HHC_CLINIC_CODES')
);

select code, description, service, count(1) cnt, listagg(network, ', ') within group (order by network) networks
from hhc_clinic_codes
group by code, description, service
having count(1) <> 8;

select v.*, cc.description cc_description
from
(
  select q.*, count(1) over(partition by code) dup_cnt
  from
  (
    select
      code, description, service,
      count(1) cnt,
      listagg(network, ', ') within group (order by network) networks
    from ref_clinic_codes
    group by code, description, service
  ) q
) v
left join
(
  select distinct code, description
  from hhc_clinic_codes
) cc
on cc.code = v.code
--where v.dup_cnt > 1
where v.dup_cnt = 1 and v.description <> cc.description
order by v.code;

select description, count(1) cnt
from
(
  select distinct code, description
  from hhc_clinic_codes
) cc
group by description
order by cnt desc;

with 
  det as
  (
    select code, listagg(network, ', ') within group(order by network) networks
    from ref_clinic_codes
    group by code
  )
select networks, count(1) cnt
from det group by networks
order by cnt desc, networks;

select
  code,
  count(distinct category_id) cat_cnt,
  listagg(category_id, ', ') within group(order by category_id) cat_list
from
(
  select distinct code, category_id
  from ref_clinic_codes
)
group by code
--having count(distinct category_id) > 1
;

select * from v_dim_hc_departments
where service_type <> 'N/A' and specialty_code like '0%'
order by location_id
;


SELECT COUNT(1) FROM dim_hc_departments; -- 124930

SELECT COUNT(1) FROM location l-- 124940
where facility_id <> -1 and (facility_id <> 2 or network <> 'SBN');

select *  -- these 10 locations are missing
from location where network = 'QHN'
--and location_id in ('573~18','573~19','573~20','573~21','573~22')
and parent_location_id in ('573~18','573~19','573~20','573~21','573~22')
order by location_id;
