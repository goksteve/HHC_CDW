prompt Populating table DSRIP_TR016_PAYERS ... 

set timi on
set feedback on

INSERT INTO dsrip_tr016_payers
SELECT
  v.visit_id, vsp.payer_id,
  MIN(vsp.payer_number) payer_rank
FROM dsrip_tr016_a1c_glucose_rslt v
JOIN ud_master.visit_segment_payer vsp ON vsp.visit_id = v.visit_id
GROUP BY v.visit_id, vsp.payer_id;

set timi off
set feedback off

COMMIT;
