exec dbm.drop_tables('EDD_DIM_DESTINATIONS');

CREATE TABLE edd_dim_destinations
(
  DestinationKey  NUMBER(10,0),
  Destination     VARCHAR2(1000) NOT NULL,
  FacilityKey     NUMBER(10,0) NOT NULL,
  CONSTRAINT pk_dim_destinations PRIMARY KEY(FacilityKey, DestinationKey),
  CONSTRAINT fk_destination_facility FOREIGN KEY(FacilityKey) REFERENCES dim_facilities
) ORGANIZATION INDEX OVERFLOW TABLESPACE COMMON_DATA_01;

GRANT SELECT ON edd_dim_destinations TO PUBLIC;
