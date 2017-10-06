SELECT * from dsrip_report_tr016
order by patient_gid;

select *
from dsrip_report_results
where report_cd = 'DSRIP-TR016'
and period_start_dt = date '2017-10-01'
order by network, facility_name;

