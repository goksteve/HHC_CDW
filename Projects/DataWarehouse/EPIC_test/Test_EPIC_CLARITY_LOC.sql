alter session set current_schema = epic_clarity;

select * from x_loc_facility_mapping; 

select rev_loc_id from clarity_dep
minus
select loc_id from clarity_loc;

select loc_id from clarity_loc
minus
select rev_loc_id from clarity_dep
;

select department_id, count(1) cnt
from clarity_dep
group by department_id
having count(1)>1;

-- From Uma:
select enc.pat_id,enc.department_id,x.facility_name,x.network ,loc.ADT_PARENT_ID 
FROM PAT_ENC enc
left join clarity_dep dep on dep.department_id = enc.department_id
left join clarity_loc loc on loc.LOC_ID = dep.REV_LOC_ID
left join x_loc_facility_mapping x on x.facility_id = loc.adt_parent_id 
where enc.department_id is not null
and pat_id='Z339509';

select distinct facility_id from clarity_loc;

select level, loc_id, rpad(' ', (level-1)*2)||loc_name, pos_type
from clarity_loc
connect by prior loc_id = adt_parent_id
start with adt_parent_id is null
;

select --+ parallel(16)
 primary_loc_id from pat_enc
minus
select loc_id from clarity_loc;

select loc_id, count(1) cnt
from clarity_loc
group by loc_id having count(1) > 1;

select distinct specialty
from clarity_dep
order by 1; 
