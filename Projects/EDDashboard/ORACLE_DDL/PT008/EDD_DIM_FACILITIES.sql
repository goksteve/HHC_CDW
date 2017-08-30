exec dbm.drop_tables('EDD_DIM_FACILITIES');

CREATE TABLE edd_dim_facilities 
(
  FacilityKey  NUMBER(10,0) CONSTRAINT pk_edd_dim_facilities PRIMARY KEY,
  Facility     VARCHAR2(1000),
  FacilityCode VARCHAR2(1000) CONSTRAINT uk_edd_dim_facilities UNIQUE
) ORGANIZATION INDEX;

GRANT SELECT ON edd_dim_Facilities TO PUBLIC;

INSERT INTO edd_dim_facilities VALUES(0, 'All facilities together', 'ALL');
COMMIT;
