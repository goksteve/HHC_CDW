DROP TABLE tst_ok_tr016_payers PURGE;

CREATE TABLE tst_ok_tr016_payers
(
  NETWORK     VARCHAR2(3),
  VISIT_ID    NUMBER(12),
  PAYER_ID    NUMBER(12),
  PAYER_RANK  NUMBER, 
  CONSTRAINT pk_tr016_payers PRIMARY KEY(network, visit_id, payer_id)
) ORGANIZATION INDEX;

GRANT SELECT ON tst_ok_tr016_payers TO PUBLIC;