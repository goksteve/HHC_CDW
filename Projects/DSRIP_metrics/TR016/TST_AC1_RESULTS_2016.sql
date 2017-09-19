drop table TST_AC1_RESULTS_2016 purge;

create table TST_AC1_RESULTS_2016 parallel 2 compress basic as
select
  v.facility_id,
  v.patient_id,
  v.visit_id,
  e.date_time as event_date_time,
  rf.name as data_element_name,
  r.value as data_element_value
from v$database db
join meta_conditions lkp
  on lkp.network = SUBSTR(db.name, 1, 3)
 and lkp.criterion_id = 4 -- A1C results
join ud_master.result r
  on r.data_element_id = lkp.value
join ud_master.event e
  on e.visit_id = r.visit_id
 and e.event_id = r.event_id
 and e.date_time >= date '2016-01-01'
 and e.date_time < date '2017-01-01'
join ud_master.result_field rf
  on rf.data_element_id = r.data_element_id
join ud_master.visit v
  on v.visit_id = e.visit_id;
