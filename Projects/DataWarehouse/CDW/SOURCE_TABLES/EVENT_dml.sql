alter session enable parallel dml;

insert /*+ parallel(32) */ into event
select network, visit_id, event_id, date_time, event_status_id, event_type_id, patient_schedule_display, cid, event_interface_id
from event_cbn
where date_time >= date '2014-01-01';

commit;

insert /*+ parallel(32) */ into event
select network, visit_id, event_id, date_time, event_status_id, event_type_id, patient_schedule_display, cid, event_interface_id
from event_gp1
where date_time >= date '2014-01-01';

commit;

insert /*+ parallel(32) */ into event
select network, visit_id, event_id, date_time, event_status_id, event_type_id, patient_schedule_display, cid, event_interface_id
from event_gp2
where date_time >= date '2014-01-01';

commit;

insert /*+ parallel(32) */ into event
select network, visit_id, event_id, date_time, event_status_id, event_type_id, patient_schedule_display, cid, event_interface_id
from event_nbn
where date_time >= date '2014-01-01';

commit;

insert /*+ parallel(32) */ into event
select network, visit_id, event_id, date_time, event_status_id, event_type_id, patient_schedule_display, cid, event_interface_id
from event_nbx
where date_time >= date '2014-01-01';

commit;

insert /*+ parallel(32) */ into event
select network, visit_id, event_id, date_time, event_status_id, event_type_id, patient_schedule_display, cid, event_interface_id
from event_qhn
where date_time >= date '2014-01-01';

commit;

insert /*+ parallel(32) */ into event
select network, visit_id, event_id, date_time, event_status_id, event_type_id, patient_schedule_display, cid, event_interface_id
from event_sbn
where date_time >= date '2014-01-01';

commit;

insert /*+ parallel(32) */ into event
select network, visit_id, event_id, date_time, event_status_id, event_type_id, patient_schedule_display, cid, event_interface_id
from event_smn
where date_time >= date '2014-01-01';

commit;

alter session force parallel dml parallel 32;

CREATE UNIQUE INDEX pk_event ON event(event_id, visit_id, network) LOCAL PARALLEL 32;
ALTER INDEX pk_event NOPARALLEL;

CREATE INDEX idx_event_cid ON event(cid, network) LOCAL PARALLEL 32;
ALTER INDEX idx_event_cid NOPARALLEL;

ALTER TABLE event ADD CONSTRAINT pk_event PRIMARY KEY(network, visit_id, event_id) USING INDEX pk_event;
