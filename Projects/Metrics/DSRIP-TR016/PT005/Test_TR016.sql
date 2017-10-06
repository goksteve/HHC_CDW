SELECT * from dsrip_report_tr016
where report_period_start_dt = date '2017-10-01'
order by patient_gid;

select *
from dsrip_report_results
where report_cd = 'DSRIP-TR016'
and period_start_dt = date '2017-10-01'
order by network, facility_name;

select distinct report_cd, period_start_dt from dsrip_report_results;

select * from dsrip_tr016_payers;