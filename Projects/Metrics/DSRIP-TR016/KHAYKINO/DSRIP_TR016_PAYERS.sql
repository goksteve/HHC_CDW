DROP TABLE dsrip_tr016_payers PURGE;

CREATE TABLE dsrip_tr016_payers
(
  VISIT_ID    NUMBER(12),
  PAYER_ID    NUMBER(12),
  PAYER_RANK  NUMBER, 
  CONSTRAINT pk_tr016_payers PRIMARY KEY(visit_id, payer_id)
) ORGANIZATION INDEX;

GRANT SELECT ON dsrip_tr016_payers TO PUBLIC;