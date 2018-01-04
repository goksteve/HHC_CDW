exec dbm.drop_tables('DIM_MEDICAL_VENUES');

CREATE TABLE dim_medical_venues
(
  facility_key        NUMBER(10) NOT NULL,
  medical_venue_num   NUMBER(3) NOT NULL,
  street_address      VARCHAR2(128),
  municipality        VARCHAR2(32),
  zip_code            VARCHAR(5),
  CONSTRAINT dim_med_venues_pk PRIMARY KEY(facility_key, medical_venue_num),
  CONSTRAINT dim_med_venues_fk_facility FOREIGN KEY(facility_key) REFERENCES dim_medical_facilities,
  CONSTRAINT dim_med_venues_fk_zip FOREIGN KEY(zip_code) REFERENCES ref_zip_codes
);

GRANT SELECT ON dim_medical_venues TO PUBLIC;