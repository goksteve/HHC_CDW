select ed_disposition_c, ed_disposition_name, disch_disp_c, discharge_dispo_name, count(1) cnt
from edd_stg_epic_visits
group by disch_disp_c, discharge_dispo_name, ed_disposition_c, ed_disposition_name
order by 1;

select id, name  -- 13, 14, 15, 17, 18, 21, 23
from stg_ed_dispositions 
minus
select ed_disposition_c, ed_disposition_name
from edd_stg_epic_visits;

select ed_disposition_c, ed_disposition_name -- *Unassigned
from edd_stg_epic_visits
minus
select id, name
from stg_ed_dispositions; 

select id, name
from stg_discharge_dispositions
minus
select disch_disp_c, discharge_dispo_name
from edd_stg_epic_visits;

select disch_disp_c, discharge_dispo_name -- Unassigned
from edd_stg_epic_visits
minus
select id, name
from stg_discharge_dispositions; 
