ALTER SESSION FORCE PARALLEL DML PARALLEL 32;
ALTER SESSION FORCE PARALLEL DDL PARALLEL 32;
DROP TABLE visit_tmp;

CREATE TABLE visit_tmp
NOLOGGING
PARTITION BY LIST (NETWORK)

(  PARTITION CBN VALUES ('CBN')
		NOLOGGING
		COMPRESS BASIC ,
	PARTITION GP1 VALUES ('GP1')
		NOLOGGING
		COMPRESS BASIC ,
	PARTITION GP2 VALUES ('GP2')
		NOLOGGING
		COMPRESS BASIC ,
	PARTITION NBN VALUES ('NBN')
		NOLOGGING
		COMPRESS BASIC ,
	PARTITION NBX VALUES ('NBX')
		NOLOGGING
		COMPRESS BASIC ,
	PARTITION QHN VALUES ('QHN')
		NOLOGGING
		COMPRESS BASIC ,
	PARTITION SBN VALUES ('SBN')
		NOLOGGING
		COMPRESS BASIC ,
	PARTITION SMN VALUES ('SMN')
		NOLOGGING
		COMPRESS BASIC)
PARALLEL 32
COMPRESS BASIC AS
	SELECT /*+ PARALLEL(32) */
	 datenum,
	 vp.network,
	 vp.visit_id,
	 vp.visit_number,
	 pp.patient_key,
	 pp.patient_id,
	 vp.admission_date_time,
	 vp.discharge_date_time,
	 pp.name AS patient_name,
	 pp.birthdate,
	 pp.apt_suite,
	 pp.street_address,
	 pp.city,
	 pp.state,
	 pp.country,
	 pp.mailing_code,
	 pp.race_desc,
	 pp.religion_desc,
	 pp.pcp_provider_id pcp_provider_id,
	 pp.pcp_provider_name pcp_provider_name,
	 loc.location_id,
	 loc.area_name /*division*/
								location,
	 prov1.provider_id attending_provider_id,
	 prov1.provider_name attending_provider,
	 prov2.provider_id resident_provider_id,
	 prov2.provider_name resident_provider,
	 prov3.provider_id admitting_provider_id,
	 prov3.provider_name admitting_provider,
	 prov4.provider_id visit_emp_provider_id,
	 prov4.provider_name visit_emp_provider,
	 ff.facility_id,
	 ff.facility_name,
	 financial_class_id,
	 vp.physician_service_id,
	 vp.visit_subtype_id,
	 vp.payer_id,
	 vp.pay.payer_name,
	 vp.payer_number,
	 vp.plan_number
	FROM
	 fact_visit_payers vp
	 JOIN dim_patients pp ON pp.patient_key = vp.patient_key
	 LEFT JOIN /*dim_hc_departments*/
						z_dim_location loc ON loc.location_key = vp.location_key
	 LEFT JOIN dim_providers prov1 ON prov1.provider_key = vp.attending_provider_key
	 LEFT JOIN dim_providers prov2 ON prov2.provider_key = vp.resident_provider_key
	 LEFT JOIN dim_providers prov3 ON prov3.provider_key = vp.admitting_provider_key
	 LEFT JOIN dim_providers prov4 ON prov4.provider_key = vp.visit_emp_provider_key
	 LEFT JOIN dim_payers pay ON pay.network = vp.network AND pay.payer_id = vp.payer_id
	 LEFT JOIN /*dim_hc_facilities*/
						z_dim_facility ff ON ff.facility_key = vp.facility_key
	WHERE
	 vp.admission_date_time > DATE '2017-08-01' ---AND vp.network = 'CBN';