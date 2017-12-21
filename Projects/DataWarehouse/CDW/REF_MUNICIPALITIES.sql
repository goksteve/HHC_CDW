exec dbm.drop_tables('REF_MUNICIPALITIES');

CREATE TABLE ref_municipalities
(
  zip_code                      VARCHAR2(5) NOT NULL,
  municipality                  VARCHAR2(64) NOT NULL,
  state                         CHAR(2) NOT NULL,
  municipality_mixed_case       VARCHAR2(64) NOT NULL,
  municipality_abbr             VARCHAR2(32),
  municipality_code             CHAR(3),
  CONSTRAINT ref_mncpl_pk PRIMARY KEY(zip_code, municipality),
  CONSTRAINT ref_mncpl_fk_zipcode FOREIGN KEY(zip_code) REFERENCES ref_zip_codes
) COMPRESS BASIC;

GRANT SELECT ON ref_municipalities TO PUBLIC;
