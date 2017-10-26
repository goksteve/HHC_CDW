SELECT * from dsrip_report_tr016
where report_period_start_dt = date '2017-10-01'
order by patient_name, patient_gid;

select period_start_dt, network, facility_name, denominator "# Of Patients", numerator_1 "# of screened ones", round(numerator_1/denominator, 2) "% screened" 
from dsrip_report_results
where report_cd = 'DSRIP-TR016'
and period_start_dt = date '2017-10-01'
order by case when network like 'ALL%' then 2 else 1 end, network, facility_name;
