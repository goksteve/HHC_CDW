DROP TABLE dsrip_tr001_payers PURGE;

CREATE TABLE dsrip_tr001_payers
(
  network     VARCHAR2(3),
  visit_id    NUMBER(12),
  payer_id    NUMBER(12),
  payer_rank  NUMBER, 
  CONSTRAINT pk_tr001_payers PRIMARY KEY(visit_id, payer_id)
) ORGANIZATION INDEX;
