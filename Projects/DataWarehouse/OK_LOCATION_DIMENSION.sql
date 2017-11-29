--  Check that PARENT_LOCATION_ID can be reliably used instead of parcing the LOCATION_ID: 
select l.*, regexp_substr(location_id, '^([0-9~]*)~[0-9]*$', 1, 1, 'c', 1) sub_str
from ud_master.location l
where parent_location_id <> nvl(regexp_substr(location_id, '^([0-9~A]*)~[0-9A]*$', 1, 1, 'c', 1), 'N/A');

drop table ok_location_dimension purge; 

-- Create another version of the LOCATION_DIMENSION table using one query:
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
     when area like '%Interface%' or area like '%I/F%' then nvl(regexp_substr(subarea, '([0-9]+) *$', 1, 1, 'c', 1), 'N/A')
     else 'N/A'
  end clinic_code
from pvt
left join ud_master.facility f on f.facility_id = pvt.facility_id;

-- Check the counts:
select count(1) cnt from hhc_custom.hhc_location_dimension; -- 21,727
select count(1) cnt from ok_location_dimension; -- 21,729

-- Compare datasets using FULL JOIN:  
select ok.*, hhc.*
from ok_location_dimension ok
full join hhc_custom.hhc_location_dimension hhc on hhc.location_id = ok.location_id
where hhc.location_id is null or ok.location_id is null
 or hhc.area <> ok.area or hhc.subarea <> ok.subarea or hhc.sub_subarea <> ok.sub_subarea
 or hhc.bed_flag <> ok.bed_flag or hhc.facility <> ok.facility or hhc.clinic_code <> ok.clinic_code
;

-- Compare datesets using ordered UNION:
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

select level, location_id, name, parent_location_id, bed, facility_id 
from ud_master.location
connect by location_id = prior parent_location_id and location_id <> prior location_id
start with location_id = '538~10~';

select code, description, service 
from hhc_custom.hhc_clinic_codes
order by 2;

select distinct service
from hhc_custom.hhc_clinic_codes;
--
select * from ok_location_dimension
where location_id in ('538','538~10','538~10~');