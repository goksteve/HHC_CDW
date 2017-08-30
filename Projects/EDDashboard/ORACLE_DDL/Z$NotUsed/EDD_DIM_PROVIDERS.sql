exec dbm.drop_tables('EDD_DIM_PROVIDERS');

CREATE TABLE edd_dim_Providers
(
  ProviderKey NUMBER(10,0) CONSTRAINT pk_edd_dim_providers PRIMARY KEY,
  Provider    VARCHAR2(1000)
) ORGANIZATION INDEX;

GRANT ALL ON edd_dim_providers TO PUBLIC;
