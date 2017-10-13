DROP TABLE dsrip_tr001_providers PURGE;

CREATE TABLE dsrip_tr001_providers
(
  network      VARCHAR2(3),
  visit_id     NUMBER(12),
  provider_id  NUMBER(12), 
  CONSTRAINT pk_tr001_providers PRIMARY KEY (visit_id, provider_id)
) ORGANIZATION INDEX;
