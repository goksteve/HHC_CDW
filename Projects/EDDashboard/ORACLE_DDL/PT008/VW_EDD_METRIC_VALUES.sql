CREATE OR REPLACE VIEW vw_edd_metric_values AS
WITH
  metrics AS
  (
    SELECT --+ MATERIALIZE
      mu.metric_id, mu.esi_key, mu.disposition_class, d.disposition_id, d.source  
    FROM
    (
      SELECT
        'QMED' source, DispositionKey disposition_id, common_name
      FROM edd_qmed_dispositions
      UNION ALL
      SELECT 'EPIC', id, common_name
      FROM edd_epic_dispositions
    ) d
    JOIN edd_dim_dispositions dd
      ON dd.disposition_name = d.common_name
    JOIN edd_meta_metric_usage mu
      ON mu.disposition_class = 'ANY' OR mu.disposition_class = dd.disposition_class
  )
SELECT
 -- 26-Jun-2017, OK: used CLIENT_IDENTIFIER
 -- 07-Jun-2017, OK: created
 --+ LEADING(v) INDEX(v idx_edd_fact_visits_arrival)
  m.metric_id, m.esi_key, m.disposition_class,
  TRUNC(v.arrival_dt, 'MONTH') month_dt,
  DECODE(GROUPING(v.facility_key), 1, 0, v.facility_key) AS facility_key,
  MEDIAN
  (
    DECODE
    (
      m.metric_id,
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
FROM edd_fact_visits v
JOIN metrics m
  ON m.source = v.source AND m.disposition_id = v.disposition_id
 AND (m.esi_key = 0 OR m.esi_key = v.esi_key)
WHERE v.arrival_dt >= TRUNC(TO_DATE(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER')),'MONTH')
GROUP BY GROUPING SETS
(
  (TRUNC(v.arrival_dt, 'MONTH'), v.facility_key, m.esi_key, m.disposition_class, m.metric_id),
  (TRUNC(v.arrival_dt, 'MONTH'), m.esi_key, m.disposition_class, m.metric_id)
);

GRANT SELECT ON vw_edd_metric_values TO PUBLIC;
