CREATE TABLE edd_stg_dispositions
(
  DispositionKey    NUMBER(10,0) NOT NULL,
  Disposition       VARCHAR2(1000) NOT NULL,
  DispositionLookup VARCHAR2(1000)
) COMPRESS BASIC;

GRANT SELECT ON edd_stg_dispositions TO PUBLIC;