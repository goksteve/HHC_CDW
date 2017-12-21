EXEC dbm.drop_tables('REF_ZIP_CODES');

CREATE TABLE ref_zip_codes
(
  ZIP_CODE                      VARCHAR2(5) CONSTRAINT ref_zip_codes_pk PRIMARY KEY,
  CITY                          VARCHAR2(32) NOT NULL,
  COUNTY                        VARCHAR2(32),
  STATE                         CHAR(2)    NOT NULL,
  AREA_CODE                     VARCHAR2(32),
  LATITUDE                      NUMBER(9,6),
  LONGITUDE                     NUMBER(9,6),
  TIME_ZONE                     NUMBER(2) NOT NULL,
  ELEVATION                     NUMBER,
  DAY_LIGHT_SAVING              CHAR(1),
  CITY_MIXED_CASE               VARCHAR2(32) NOT NULL,
  CITY_TYPE                     CHAR(1) NOT NULL,
  COUNTY_MIXED_CASE             VARCHAR2(32)
) COMPRESS BASIC;

GRANT SELECT ON ref_zip_codes TO PUBLIC;