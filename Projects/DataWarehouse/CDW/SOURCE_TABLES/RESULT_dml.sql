alter session enable parallel dml;

set timi on

insert /*+ parallel(32) */ into result
select r.network, r.visit_id, r.event_id, r.result_report_number, r.data_element_id, r.multi_field_occurrence_number, r.item_number, r.value, r.abnormal_state_id, r.used, r.cid
from event e
join result_cbn r on r.event_id = e.event_id and r.visit_id = e.visit_id and r.network = e.network
where e.date_time >= date '2014-01-01';

commit;

insert /*+ parallel(32) */ into result
select r.network, r.visit_id, r.event_id, r.result_report_number, r.data_element_id, r.multi_field_occurrence_number, r.item_number, r.value, r.abnormal_state_id, r.used, r.cid
from event e
join result_gp1 r on r.event_id = e.event_id and r.visit_id = e.visit_id and r.network = e.network
where e.date_time >= date '2014-01-01';

commit;

insert /*+ parallel(32) */ into result
select r.network, r.visit_id, r.event_id, r.result_report_number, r.data_element_id, r.multi_field_occurrence_number, r.item_number, r.value, r.abnormal_state_id, r.used, r.cid
from event e
join result_gp2 r on r.event_id = e.event_id and r.visit_id = e.visit_id and r.network = e.network
where e.date_time >= date '2014-01-01';

commit;

insert /*+ parallel(32) */ into result
select r.network, r.visit_id, r.event_id, r.result_report_number, r.data_element_id, r.multi_field_occurrence_number, r.item_number, r.value, r.abnormal_state_id, r.used, r.cid
from event e
join result_nbn r on r.event_id = e.event_id and r.visit_id = e.visit_id and r.network = e.network
where e.date_time >= date '2014-01-01';

commit;

insert /*+ parallel(32) */ into result
select r.network, r.visit_id, r.event_id, r.result_report_number, r.data_element_id, r.multi_field_occurrence_number, r.item_number, r.value, r.abnormal_state_id, r.used, r.cid
from event e
join result_nbx r on r.event_id = e.event_id and r.visit_id = e.visit_id and r.network = e.network
where e.date_time >= date '2014-01-01';

commit;

insert /*+ parallel(32) */ into result
select r.network, r.visit_id, r.event_id, r.result_report_number, r.data_element_id, r.multi_field_occurrence_number, r.item_number, r.value, r.abnormal_state_id, r.used, r.cid
from event e
join result_qhn r on r.event_id = e.event_id and r.visit_id = e.visit_id and r.network = e.network
where e.date_time >= date '2014-01-01';

commit;

insert /*+ parallel(32) */ into result
select r.network, r.visit_id, r.event_id, r.result_report_number, r.data_element_id, r.multi_field_occurrence_number, r.item_number, r.value, r.abnormal_state_id, r.used, r.cid
from event e
join result_sbn r on r.event_id = e.event_id and r.visit_id = e.visit_id and r.network = e.network
where e.date_time >= date '2014-01-01';

commit;

insert /*+ parallel(32) */ into result
select r.network, r.visit_id, r.event_id, r.result_report_number, r.data_element_id, r.multi_field_occurrence_number, r.item_number, r.value, r.abnormal_state_id, r.used, r.cid
from event e
join result_smn r on r.event_id = e.event_id and r.visit_id = e.visit_id and r.network = e.network
where e.date_time >= date '2014-01-01';

commit;

alter session force parallel dml parallel 64;

CREATE UNIQUE INDEX pk_result
ON result(visit_id, data_element_id, event_id, result_report_number, multi_field_occurrence_number, item_number, network)
LOCAL PARALLEL 32;

ALTER INDEX pk_result NOPARALLEL;

ALTER TABLE result ADD CONSTRAINT pk_result
 PRIMARY KEY(network, visit_id, event_id, data_element_id, result_report_number, multi_field_occurrence_number, item_number)
 USING INDEX pk_result;
