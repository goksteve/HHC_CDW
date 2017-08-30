exec dbm.drop_tables('EDD_DIM_ADMISSIONLOCATIONS');

CREATE TABLE edd_dim_AdmissionLocations
(
  AdmissionLocationKey  NUMBER(10,0) CONSTRAINT pk_AdmissionLocation PRIMARY KEY,
  AdmissionLocation     VARCHAR2(1000)
) ORGANIZATION INDEX;

GRANT SELECT ON edd_dim_AdmissionLocations TO PUBLIC;
