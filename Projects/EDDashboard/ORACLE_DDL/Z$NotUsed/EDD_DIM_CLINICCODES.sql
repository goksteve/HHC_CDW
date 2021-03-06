exec dbm.drop_tables('EDD_DIM_CLINICCODES');

CREATE TABLE edd_dim_clinicCodes
(
  ClinicCodeKey NUMBER(10,0) CONSTRAINT pk_edd_dim_ClinicCodes PRIMARY KEY,
  ClinicCode NVARCHAR2(1000),
  ClinicCodeDesc NVARCHAR2(1000)
) ORGANIZATION INDEX OVERFLOW TABLESPACE COMMON_DATA_01;

GRANT SELECT ON edd_dim_ClinicCodes TO PUBLIC;
