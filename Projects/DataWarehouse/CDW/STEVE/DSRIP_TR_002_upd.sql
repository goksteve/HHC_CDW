DROP TABLE dsrip_tr_002_test2;
CREATE TABLE dsrip_tr_002_test2
NOLOGGING
PARALLEL 32
COMPRESS BASIC AS
	WITH a1c_val AS
				 ( SELECT
					 network,
					 patient_key,
					 visit_id,
					 -- facility_key,
					 facility_name,
					 admission_date_time,
					 discharge_date_time,
					 (CASE WHEN res.a1c_final_calc_value < 8 THEN 1 ELSE NULL END) AS a1c_less_8,
					 (CASE WHEN (res.a1c_final_calc_value >= 8 and res.a1c_final_calc_value < 9 ) THEN 1 ELSE NULL END) AS a1c_more_8,
					-- (CASE WHEN res.a1c_final_calc_value >= 9 THEN 1 ELSE NULL END) AS a1c_more_9,
					 (CASE WHEN (NVL(res.a1c_final_calc_value, 9)) >= 9 THEN 1 ELSE NULL END) AS a1c_more_9_null,
					 a1c_final_orig_value,
					 a1c_final_calc_value
					 FROM
					 ( SELECT
						 res.network,
						 patient_key,
						 visit_id,
						 res.facility_key,
						 ff.facility_name,
						 admission_date_time,
						 discharge_date_time,
						 a1c_final_orig_value,
						 a1c_final_calc_value,
						 ROW_NUMBER() OVER(PARTITION BY res.network, patient_key ORDER BY admission_date_time DESC)
							 AS cnt
						 FROM
						 fact_visit_clinical res
						 LEFT JOIN dim_hc_facilities ff
							 ON res.network = ff.network AND res.facility_key = ff.facility_key) res
					 WHERE
					 cnt = 1),
			 tmp_pat AS
				 ( SELECT
					 network,
					 patient_key,
					 onset_date,
					 diag_code icd_code,
					 problem_comments
					 FROM
					 ( SELECT --+ PARALLEL(32)
						 dd.*,
						 ROW_NUMBER() OVER(PARTITION BY dd.network, dd.patient_key ORDER BY dd.onset_date DESC) AS cnt
						 FROM
						 fact_patient_diagnoses dd
						 JOIN meta_conditions mc
							 ON 		dd.diag_code = mc.VALUE
									AND mc.criterion_id = 1
									AND mc.condition_type_cd = 'DI'
									AND mc.include_exclude_ind = 'I'
						 WHERE
								 1 = 1
						 AND (dd.patient_key) NOT IN
									 ((
											 SELECT
											 patient_key
											 FROM
											 fact_patient_diagnoses pp
											 JOIN meta_conditions mc
												 ON 		pp.diag_code = mc.VALUE
														AND mc.criterion_id = 1
														AND mc.condition_type_cd = 'DI'
														AND mc.include_exclude_ind = 'E'
										))
						 AND dd.status_id IN (0, --- PROBLEM_STATUS_ID
																	6,
																	7,
																	8)
						 AND dd.network = 'CBN')
					 WHERE
					 cnt = 1)
	 SELECT --+ parallel(32)
	 tmp_pat.network,
	 tmp_pat.patient_key,
	 pp.medical_record_number AS mrn,
	 pp.name,
	 pp.birthdate,
	 a1c_val.visit_id,
	 -- a1c_val.facility_key,
	 a1c_val.facility_name,
	 a1c_val.admission_date_time,
	 a1c_val.discharge_date_time,
	 onset_date,
	 icd_code,
	 problem_comments,
	 a1c_val.a1c_less_8,
	 a1c_val.a1c_more_8,
	-- a1c_val.a1c_more_9,
	 a1c_val.a1c_more_9_null,
	 a1c_val.a1c_final_orig_value,
	 a1c_val.a1c_final_calc_value,
	 'Dsrip_Tr_002_Test' AS report,
	 TRUNC(SYSDATE, 'MONTH') report_date,
	 TRUNC(SYSDATE) load_date
	 FROM
	 tmp_pat
	 JOIN dim_patients pp ON pp.patient_key = tmp_pat.patient_key AND pp.network = tmp_pat.network
	 LEFT JOIN a1c_val ON tmp_pat.patient_key = a1c_val.patient_key AND tmp_pat.network = a1c_val.network
	 WHERE
	 FLOOR((TRUNC(SYSDATE, 'MONTH') - pp.birthdate) / 365) BETWEEN 18 AND 75