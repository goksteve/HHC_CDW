-- Create anothe LOCATION_DIMENSION table uisng just one query:
create table ok_location_dimension as
with
  det as
  (
    select
      level lvl,
      network, facility_id, location_id, name,
      sys_connect_by_path(nvl(name, 'NA'), '~') path_name,
      case when upper(bed) = 'TRUE' then 'True' else 'False' end bed_flag
    from location
    connect by network = prior network and parent_location_id = prior location_id and location_id <> prior location_id 
    start with parent_location_id is null or location_id = '-1'
  ),
  ar as
  (
    select
      det.*,
      regexp_substr(path_name,'[^~]+') area,
      nvl(regexp_substr(path_name,'[^~]+', 1, 2), 'NA') subarea,
      nvl(regexp_substr(path_name,'[^~]+', 1, 3), 'NA') sub_subarea
    from det
  )
select
  ar.network, ar.location_id, ar.area, ar.subarea, ar.sub_subarea, ar.bed_flag,
  NVL(f.name, 'Unknown') AS facility,
  case
     when (area like '%Interface%' or area like '%I/F%') and lower(subarea) not like 'shell%'
       then nvl(regexp_substr(subarea, '([0-9]+) *$', 1, 1, 'c', 1), 'N/A')
     else 'N/A'
  end clinic_code
from ar
left join facility f on f.network = ar.network and f.facility_id = ar.facility_id;

-- Check the counts:
select count(1) cnt from hhc_location_dimension; -- 125,971
select count(1) cnt from ok_location_dimension; -- 125,971

-- Compare standard and Oleg's datesets:
select *
from
(
  select
    u.*,
    case
      when min(area) over(partition by network, location_id) <> max(area) over(partition by network, location_id) then 'AREA'
      when min(subarea) over(partition by network, location_id) <> max(subarea) over(partition by network, location_id) then 'SUBAREA'
      when min(sub_subarea) over(partition by network, location_id) <> max(sub_subarea) over(partition by network, location_id) then 'SUB_SUBAREA'
      when min(facility) over(partition by network, location_id) <> max(facility) over(partition by network, location_id) then 'FACILITY'
      when min(clinic_code) over(partition by network, location_id) <> max(clinic_code) over(partition by network, location_id) then 'CLINIC_CODE'
      when count(1) over(partition by network, location_id) < 2 then 'MISSING'
    end difference
  from
  (
    select 'OK' src, ok.* from ok_location_dimension ok
    union all
    select 'HHC', hhc.* from hhc_location_dimension hhc
  ) u
)
where difference is not null
order by network, location_id, src;

-- Going up the hierarchy:
select level, location_id, name, parent_location_id, bed, facility_id 
from ud_master.location
connect by location_id = prior parent_location_id and location_id <> prior location_id
start with location_id = '307~127~';

-- Not all Clinic Codes are used:
select cc.code, cc.description, cc.service, count(ld.clinic_code) cnt 
from hhc_custom.hhc_clinic_codes cc
left join hhc_custom.hhc_location_dimension ld on ld.clinic_code = cc.code 
group by cc.code, cc.description, cc.service
having count(ld.clinic_code) < 1
order by 1;

select service, listagg(network, ',') within group(order by network)
from 
(
  select distinct network, service
  from hhc_clinic_codes
)
group by service
;

select * from ok_location_dimension
where location_id in ('538','538~10','538~10~');
