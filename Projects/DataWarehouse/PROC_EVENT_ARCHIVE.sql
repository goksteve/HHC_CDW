select --+ parallel(16)
  network, visit_id, event_id, count(1) cnt
from proc_event_archive_cbn
group by network, visit_id, event_id
having count(1)>1;

select
  pe.network, pe.visit_id, pe.facility_id, v.facility_id visit_facility_id, 
  p.name proc_name, pea.event_id, 
  pea.archive_number, pea.archive_time,
  peat.name archive_name, es.name event_status, pea.result_report_nbr,
  pea.emp_provider_id, pea.spec_coll_emp_provider_id
from proc_event pe
join visit v on v.network = pe.network and v.visit_id = pe.visit_id
join proc p on p.network = pe.network and p.proc_id = pe.proc_id
join proc_event_archive_cbn pea
  on pea.network = pe.network and pea.visit_id = pe.visit_id and pea.event_id = pe.event_id
join proc_event_archive_type peat
  on peat.network = pea.network and peat.archive_type_id = pea.archive_type_id
join event_status es on es.network = pea.network and es.event_status_id = pea.event_status_id
where pe.network = 'CBN' and pe.visit_id = 8493882	and pe.event_id = 51520348200
order by archive_time
;


select * from TEXT_CARE_PROVIDER_archive_cbn;