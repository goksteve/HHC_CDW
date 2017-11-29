alter session set current_schema = epic_clarity;

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
