ALTER SESSION FORCE PARALLEL DML PARALLEL 32;

CREATE TABLE fact_visit_clinical
COMPRESS BASIC
PARTITION BY LIST (network)
(
  PARTITION cbn VALUES ('CBN'),
	 PARTITION gp1 VALUES ('GP1'),
	 PARTITION gp2 VALUES ('GP2'),
	 PARTITION nbn VALUES ('NBN'),
	 PARTITION nbx VALUES ('NBX'),
	 PARTITION qhn VALUES ('QHN'),
	 PARTITION sbn VALUES ('SBN'),
	 PARTITION smn VALUES ('SMN')
)
PARALLEL(DEGREE 16) AS
	SELECT /*+   ordered parallel(32)  */
	 datenum,
	 network,
	 visit_id,
	 visit_number,
	 patient_key,
	 patient_id,
	 admission_date_time,
	 discharge_date_time,
	 patient_name,
	 birthdate,
	 apt_suite,
	 street_address,
	 city,
	 state,
	 country,
	 mailing_code,
	 race_desc,
	 religion_desc,
	 provider_id,
	 provider_name,
	 location_id,
	 location,
	 provider_id attending_provider_id,
	 provider_name attending_provider,
	 provider_id resident_provider_id,
	 provider_name resident_provider,
	 provider_id admitting_provider_id,
	 provider_name admitting_provider,
	 provider_id visit_emp_provider_id,
	 provider_name visit_emp_provider,
	 facility_id,
	 facility_name,
	 financial_class_id,
	 physician_service_id,
	 visit_subtype_id,
	 payer_id,
	 pay.payer_name,
	 payer_number,
	 plan_number,
	 a1c_final_orig_value,
	 a1c_final_calc_value,
	 ldl_final_orig_value,
	 ldl_final_calc_value,
	 glucose_final_orig_value,
	 glucose_final_calc_value,
	 bp_final_orig_value,
	 bp_final_calc_value
FROM visit_tmp v 
JOIN result_clinic rr ON rr.visit_id = v.visit_id AND v.network = rr.network;
	 
	--  FLOOR((TRUNC(SYSDATE, 'MONTH') - t.birthdate) / 365) AS age,