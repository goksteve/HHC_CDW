select
  trunc(arrived_time, 'MONTH') mon,
  count(1) cnt,
  count(arrived_time) arrived_time_cnt,
  count(triage_time) triage_time_cnt,
  count(first_provider_assignment_time) first_prov_time_cnt,
  count(disposition_time) disposition_time_cnt,
  count(ed_disposition_c) disposition_cnt
from edd_stg_epic_visits
group by trunc(arrived_time, 'MONTH') 
order by mon;

select count(1) from edd_stg_epic_visits; 

select count(1) cnt
from
(
  select pat_csn, count(1) cnt
  from epic_ed_dashboard
  group by pat_csn
  having count(1)>1
);

select * from edd_stg_epic_visits
where 1=1
and empi_number = 32002322
--and rn > 1 
order by arrived_time, rn
;

select empi_number, count(distinct mrn) cnt
from edd_stg_epic_visits
group by empi_number
having count(distinct mrn) > 1;

select
  case
    when grouping(acuity_name) = 1 then 'Total'
    else nvl(acuity_name, 'N/A') 
  end acuity_name, 
  regexp_replace(acuity_name, '[^0-9]', '') esi_id,
  count(1) cnt 
from edd_stg_epic_visits
group by rollup(acuity_name)
order by esi_id
; 

select g.*, nvl2(edd.id, 'Y', 'N') in_edd_list, nvl2(dd.id, 'Y', 'N') in_dd_list
from
(
  select
    ed_disposition_c,
    ed_disposition_name,
    disch_disp_c,
    discharge_dispo_name,
    count(1) cnt
  from edd_stg_epic_visits
  group by ed_disposition_c, ed_disposition_name, disch_disp_c, discharge_dispo_name
) g
left join stg_ed_dispositions edd on edd.id = g.ed_disposition_c
left join stg_discharge_dispositions dd on dd.id = g.disch_disp_c
order by 1, 3
;
