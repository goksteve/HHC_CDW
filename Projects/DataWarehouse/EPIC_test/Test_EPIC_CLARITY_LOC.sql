alter session set current_schema = epic_clarity;

-- From Uma:
select enc.pat_id,enc.department_id,x.facility_name,x.network ,loc.ADT_PARENT_ID 
from pat_enc enc
left join clarity_dep dep on dep.department_id = enc.department_id
left join clarity_loc loc on loc.loc_id = dep.rev_loc_id
left join x_loc_facility_mapping x on x.facility_id = loc.adt_parent_id 
where enc.department_id is not null
and pat_id = 'Z339509';

select * from x_loc_facility_mapping; -- This is actually the list of Facilities in EPIC 

-- Check REV_LOC_ID in CLARITY_DEP:
select rev_loc_id, count(1) cnt 
from clarity_dep
group by rev_loc_id
order by cnt;
-- Out of ~4000 rows, 17 have NULLs in REV_LOC_ID - i.e. they are "orphans".

select distinct rev_loc_id from clarity_dep
minus
select loc_id from clarity_loc;
-- No more "orphans" other than 17 with NULLs

select loc_id from clarity_loc
minus
select rev_loc_id from clarity_dep
;

-- Check the PK in CLARITY_DEP:
select department_id, count(1) cnt
from clarity_dep
group by department_id
having count(1)>1;


select distinct facility_id from clarity_loc; -- The only Only Facility_ID = 1 ???

-- Search CLARITY_LOC hierarchy top-down:
select level, loc_id, rpad(' ', (level-1)*2)||loc_name loc_name, pos_type, adt_parent_id
from clarity_loc
where loc_name like '%LABORATORY%CORP%'
connect by prior loc_id = adt_parent_id
start with adt_parent_id is null;

select --+ parallel(16)
 primary_loc_id from pat_enc
minus
select loc_id from clarity_loc;
-- No orphan Encounters - very good!

select loc_id, count(1) cnt
from clarity_loc
group by loc_id having count(1) > 1;

select distinct specialty
from clarity_dep
order by 1; 

select loc_id, loc_name, adt_parent_id
from clarity_loc
--where loc_id in (11, 1101)
where adt_parent_id = 24
;
