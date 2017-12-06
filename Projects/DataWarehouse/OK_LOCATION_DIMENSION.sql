-- Check that PARENT_LOCATION_ID can be reliably used instead of parcing the LOCATION_ID: 
-- Only on 2 rows PARENT_LOCATION_ID and the leading part of the LOCATION_ID do not match: 
select l.*, regexp_substr(location_id, '^([0-9~]*)~[0-9]*$', 1, 1, 'c', 1) sub_str
from ud_master.location l
--where parent_location_id <> nvl(regexp_substr(location_id, '^([0-9~A]*)~[0-9A]*$', 1, 1, 'c', 1), 'N/A')
;

-- Create another version of the LOCATION_DIMENSION table using one query:
drop table ok_location_dimension purge; 

create table ok_location_dimension as
with
  det as
  (
    select
      level lvl,
      facility_id, location_id, name,
      sys_connect_by_path(nvl(name, 'NA'), '~') path_name,
      case when upper(bed) = 'TRUE' then 'True' else 'False' end bed_flag
    from ud_master.location
    connect by parent_location_id = prior location_id and location_id <> prior location_id 
    start with parent_location_id is null or location_id = '-1'
  ),
  pvt as
  (
    select
      det.*,
      regexp_substr(path_name,'[^~]+') area,
      nvl(regexp_substr(path_name,'[^~]+', 1, 2), 'NA') subarea,
      nvl(regexp_substr(path_name,'[^~]+', 1, 3), 'NA') sub_subarea
    from det
  )
select
  location_id, area, subarea, sub_subarea, bed_flag,
  NVL(f.name, 'Unknown') AS facility,
  case
     when (area like '%Interface%' or area like '%I/F%')
          and lower(subarea) not like 'shell%'
     then nvl(regexp_substr(subarea, '([0-9]+) *$', 1, 1, 'c', 1), 'N/A')
     else 'N/A'
  end clinic_code
from pvt
left join ud_master.facility f on f.facility_id = pvt.facility_id;

-- Check the counts:
select count(1) cnt from hhc_custom.hhc_location_dimension;
select count(1) cnt from ok_location_dimension;

-- Compare the datesets:
select *
from
(
  select
    u.*,
    case
      when min(area) over(partition by location_id) <> max(area) over(partition by location_id) then 'AREA'
      when min(subarea) over(partition by location_id) <> max(subarea) over(partition by location_id) then 'SUBAREA'
      when min(sub_subarea) over(partition by location_id) <> max(sub_subarea) over(partition by location_id) then 'SUB_SUBAREA'
      when min(facility) over(partition by location_id) <> max(facility) over(partition by location_id) then 'FACILITY'
      when min(clinic_code) over(partition by location_id) <> max(clinic_code) over(partition by location_id) then 'CLINIC_CODE'
      when count(1) over(partition by location_id) < 2 then 'MISSING'
    end difference
  from
  (
    select 'OK' src, ok.* from ok_location_dimension ok
    union all
    select 'HHC', hhc.* from hhc_custom.hhc_location_dimension hhc
  ) u
)
where difference is not null
order by location_id, src;

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

select distinct service
from hhc_custom.hhc_clinic_codes;

select * from ok_location_dimension
where location_id in ('538','538~10','538~10~');
