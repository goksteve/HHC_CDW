exec dbm.drop_tables('EDD_DIM_NURSES');

CREATE TABLE edd_dim_Nurses
(
  NurseKey  NUMBER(10,0) CONSTRAINT pk_edd_dim_nurses PRIMARY KEY,
  Nurse     VARCHAR2(1000)
) ORGANIZATION INDEX;

GRANT SELECT ON edd_dim_Nurses TO PUBLIC;
