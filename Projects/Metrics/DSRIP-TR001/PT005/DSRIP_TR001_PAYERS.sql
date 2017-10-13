DROP TABLE dsrip_tr001_payers PURGE;

CREATE TABLE dsrip_tr001_payers
(
  NETWORK     VARCHAR2(3),
  VISIT_ID    NUMBER(12),
  PAYER_ID    NUMBER(12),
  PAYER_RANK  NUMBER, 
  CONSTRAINT pk_tr001_payers PRIMARY KEY(network, visit_id, payer_id)
) ORGANIZATION INDEX;

