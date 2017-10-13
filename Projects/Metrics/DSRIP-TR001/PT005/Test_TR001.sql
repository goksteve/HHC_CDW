SELECT * FROM v_dsrip_tr001_summary;

SELECT * FROM v_dsrip_tr001_epic_summary;

select * from dsrip_report_tr001 
where report_period_start_dt = trunc(sysdate, 'MONTH')
order by last_name, first_name, dob, network, visit_id;

select * from dsrip_epic_bh_follow_up_visits
where report_period_start_dt = trunc(sysdate, 'MONTH')
order by patient_name, patient_dob, visit_id;
