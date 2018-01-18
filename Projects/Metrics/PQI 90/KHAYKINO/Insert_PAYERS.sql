set timi on
set feed on

prompt - Populating DSRIP_PQI_7_8_PAYERS ... 

INSERT /*+ parallel(4)*/ INTO dsrip_pqi_7_8_payers
SELECT
  v.visit_id,
  vsp.payer_id,
  MIN(vsp.payer_number) payer_rank
FROM dsrip_pqi_7_8_visits v
JOIN ud_master.visit_segment_payer vsp ON vsp.visit_id = v.visit_id
GROUP BY v.visit_id, vsp.payer_id;

COMMIT;

set feed off
set timi off

COMMIT;
