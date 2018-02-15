alter session enable parallel dml;

insert /*+ parallel(32) */ into event
select network, visit_id, event_id, date_time, event_status_id, event_type_id, patient_schedule_display, cid, event_interface_id
from event_cbn
where date_time >= date '2014-01-01';

commit;


network, visit_id, event_id, order_span_id, order_span_state_id, proc_id, orig_schedule_begin_date_time, orig_schedule_end_date_time, final_schedule_begin_date_time, final_schedule_end_date_time, abnormal_state_id, modified_proc_name, facility_id, priority_id, corrected_flag, rx_flag, spec_recollect_flag, complete_result_rpt, order_visit_id, order_definition_id, proc_order_nbr, cid, orig_schedule_abs_string, final_schedule_abs_string