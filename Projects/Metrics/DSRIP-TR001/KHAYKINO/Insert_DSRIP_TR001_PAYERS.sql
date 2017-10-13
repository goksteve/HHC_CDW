prompt Populating DSRIP_TR001_PAYERS ... 

TRUNCATE TABLE dsrip_tr001_payers;

INSERT INTO dsrip_tr001_payers
SELECT
  v.network,
  v.visit_id,
  vsp.payer_id,
  MIN(vsp.payer_number) payer_rank
FROM dsrip_tr001_visits v
JOIN ud_master.visit_segment_payer vsp ON vsp.visit_id = v.visit_id
GROUP BY v.network, v.visit_id, vsp.payer_id;

COMMIT;
