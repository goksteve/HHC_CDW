select network, count(1) cnt 
from dsrip_tr016_a1c_glucose_rslt
group by network
;

SELECT * from dsrip_report_tr016_copy;
where report_period_start_dt = date '2017-10-01'
and patient_name = 'Silvestre,Maximo'
--and medical_record_number = '2083528'
order by patient_gid;

select *
from dsrip_report_results
where report_cd = 'DSRIP-TR016'
and period_start_dt = date '2017-10-01'
order by network, facility_name;

select distinct report_cd, period_start_dt from dsrip_report_results;

select * from dsrip_tr016_payers;


select *   from dsrip_report_tr016;