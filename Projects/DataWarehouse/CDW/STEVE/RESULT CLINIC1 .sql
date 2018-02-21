DROP TABLE result_clinic PURGE;

ALTER SESSION FORCE PARALLEL DML PARALLEL 32;
ALTER SESSION FORCE PARALLEL DDL PARALLEL 32;

CREATE TABLE result_clinic
NOLOGGING
COMPRESS BASIC
PARTITION BY LIST (network)
 (PARTITION cbn VALUES ('CBN'),
	PARTITION gp1 VALUES ('GP1'),
	PARTITION gp2 VALUES ('GP2'),
	PARTITION nbn VALUES ('NBN'),
	PARTITION nbx VALUES ('NBX'),
	PARTITION qhn VALUES ('QHN'),
	PARTITION sbn VALUES ('SBN'),
	PARTITION smn VALUES ('SMN'))
PARALLEL 32 AS
SELECT /*+ parallel(32) */
  *
FROM
(
  SELECT
    q.*,
    REGEXP_SUBSTR(q.VALUE, '^[0-9\.<>%]*') AS extr_value
  FROM
  (
--WITH exclude_tmp AS
--									 (
--SELECT '%unable to calculate5%' w_card FROM DUAL
--										UNION
--										SELECT '%PLEASE REMIND PATIENT%' FROM DUAL
--										UNION
--										SELECT '%Test not done%' FROM DUAL
--										UNION
--										SELECT '%unable to perform%' FROM DUAL
--										UNION
--										SELECT '%no recorded A1c value%' FROM DUAL
--										UNION
--										SELECT '%na%' FROM DUAL
--										UNION
--										SELECT '%nn/a%' FROM DUAL
--										UNION
--										SELECT '%njone%' FROM DUAL
--										UNION
--										SELECT '%none%' FROM DUAL
--										UNION
--										SELECT '%rt foot%' FROM DUAL
--										UNION
--										SELECT '%rt arm%' FROM DUAL
--										UNION
--										SELECT '%yes%' FROM DUAL
--										UNION
--										SELECT '%nonediabetic%' FROM DUAL
--										UNION
--										SELECT '%unable to perform%' FROM DUAL
--										UNION
--										SELECT '%unable to obtain%' FROM DUAL
--										UNION
--										SELECT '%not applicable%' FROM DUAL)


						 SELECT --+ ordered  use_nl(r) index_ss(r)
									 r.network,
										r.visit_id,
										mc.criterion_id,
										r.VALUE,
										ROW_NUMBER()
										OVER(
										 PARTITION BY r.network, r.visit_id, mc.criterion_id
										 ORDER BY event_id DESC)
										 rnum
						 FROM meta_conditions mc
									JOIN result r  ON r.network = mc.network 	AND r.data_element_id = mc.VALUE AND r.network  = 'CBN'
											AND (r.network, r.visit_id) IN (SELECT network, visit_id FROM visit_tmp where network  = 'CBN' and admission_date_time  > date'2018-01-01'	 )
						 WHERE mc.criterion_id IN (4,
																			 10,
																			 23,
																			 13) -- A1C, LDL, Glucose,  BP
--									 AND r.value NOT LIKE (SELECT w_card FROM exclude_tmp)
									 
									 
									 ) q
			 WHERE q.rnum = 1)
			PIVOT
			 (MAX(VALUE) AS final_orig_value, MAX(extr_value) AS final_calc_value
			 FOR criterion_id
			 IN (4 AS a1c, 10 AS ldl, 23 AS glucose, 13 AS bp));

