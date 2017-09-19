DROP TABLE tst_ok_tr001_providers PURGE;

CREATE TABLE tst_ok_tr001_providers
(
  NETWORK      VARCHAR2(3),
  VISIT_ID     NUMBER(12),
  PROVIDER_ID  NUMBER(12), 
  CONSTRAINT pk_tr001_providers PRIMARY KEY(network, visit_id, provider_id)
) ORGANIZATION INDEX;