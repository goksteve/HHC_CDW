exec dbm.drop_tables('REF_HC_SPECIALTIES');

CREATE TABLE ref_hc_specialties
(
  code         NUMBER(4) CONSTRAINT pk_ref_hc_specialties PRIMARY KEY,
  description  VARCHAR2(256 BYTE),
  service_type VARCHAR2(3 BYTE)
);

GRANT SELECT ON ref_hc_specialties TO PUBLIC;

COMMENT ON TABLE ref_hc_specialties IS 'List of so-called "Clinic Codes" with associated Descriptions and Categories. Loaded from Excel spreadsheets obtained by Uma.'; 