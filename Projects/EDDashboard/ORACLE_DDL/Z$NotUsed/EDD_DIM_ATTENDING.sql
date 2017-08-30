exec dbm.drop_tables('EDD_DIM_ATTENDING');

CREATE TABLE edd_dim_attending
(
  AttendingKey  NUMBER(10,0) CONSTRAINT pk_edd_dim_attending PRIMARY KEY ,
  Attending     VARCHAR2(1000)
) ORGANIZATION INDEX;

GRANT SELECT ON edd_dim_attending TO PUBLIC;
