CREATE TABLE dsrip_pqi_7_8_payers
(
  network     CHAR(3),
  visit_id    NUMBER(12) NOT NULL,
  payer_id    NUMBER(12),
  payer_rank  NUMBER(2),
  CONSTRAINT dsrip_pqi_7_8_payers_pk PRIMARY KEY(network, visit_id, payer_id)
) ORGANIZATION INDEX COMPRESS;
