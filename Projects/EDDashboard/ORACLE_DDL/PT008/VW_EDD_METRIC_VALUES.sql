CREATE OR REPLACE VIEW vw_edd_metric_values AS
SELECT
 -- 07-Jun-2017, OK: created
 -- 26-Jun-2017, OK: used CLIENT_IDENTIFIER
  mu.metric_id, mu.esi_key, mu.disposition_class,
  TRUNC(v.arrival_dt, 'MONTH') month_dt,
  DECODE(GROUPING(v.facility_key), 1, 0, v.facility_key) AS facility_key,
  MEDIAN
  (
    DECODE
    (
      mu.metric_id,
      1, v.arrival_to_triage,
      2, v.arrival_to_first_provider,
      3, v.arrival_to_disposition,
      4, v.arrival_to_exit,
      5, v.triage_to_first_provider,
      6, v.triage_to_disposition,
      7, v.triage_to_exit,
      8, v.first_provider_to_disposition,
      9, v.first_provider_to_exit,
      10, v.disposition_to_exit,
      11, v.dwell
    ) 
  ) metric_value
FROM edd_meta_metric_usage mu
JOIN edd_dim_dispositions d
  ON mu.disposition_class = 'ANY' OR d.disposition_class = mu.disposition_class
JOIN edd_fact_visits v
  ON (mu.esi_key = 0 OR v.esi_key = mu.esi_key) AND v.disposition_key = d.dispositionKey
 AND v.arrival_dt >= TRUNC(TO_DATE(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER')),'MONTH')  
GROUP BY GROUPING SETS
(
  (TRUNC(v.arrival_dt, 'MONTH'), v.facility_key, mu.esi_key, mu.disposition_class, mu.metric_id),
  (TRUNC(v.arrival_dt, 'MONTH'), mu.esi_key, mu.disposition_class, mu.metric_id)
);

GRANT SELECT ON vw_edd_metric_values TO PUBLIC;
