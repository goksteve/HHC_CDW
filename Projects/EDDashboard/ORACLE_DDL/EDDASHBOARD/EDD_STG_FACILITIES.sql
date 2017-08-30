CREATE TABLE edd_stg_facilities 
(
  FacilityKey  NUMBER(10,0),
  Facility     VARCHAR2(1000),
  FacilityCode VARCHAR2(1000)
) COMPRESS BASIC;

GRANT SELECT ON edd_stg_Facilities TO PUBLIC;
