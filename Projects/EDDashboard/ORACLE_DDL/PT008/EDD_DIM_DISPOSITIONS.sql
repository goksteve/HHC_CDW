exec dbm.drop_tables('EDD_DIM_DISPOSITIONS');

CREATE TABLE edd_dim_dispositions
(
  DispositionKey    NUMBER(10,0) CONSTRAINT pk_edd_dim_dispositions PRIMARY KEY,
  Disposition       VARCHAR2(1000) NOT NULL,
  DispositionLookup VARCHAR2(1000),
  disposition_class VARCHAR2(30) AS
  (
    CASE
      WHEN DispositionLookup in ('Discharged to Home or Self Care','Transferred to Skilled Nursing Facility','Transferred to Another Hospital','Transferred to Psych ED') THEN 'DISCHARGED'
      WHEN dispositionLookup = 'Admitted as Inpatient' THEN 'ADMITTED'
    END
  )
) COMPRESS BASIC;

GRANT SELECT ON edd_dim_dispositions TO PUBLIC;

/*
      WHEN LOWER(disposition) LIKE 'admit%'
        OR LOWER(disposition) LIKE '%ambulatory%'
        OR LOWER(disposition) LIKE '%observation%'
        OR LOWER(disposition) LIKE '%monitoring%'
        OR LOWER(disposition) LIKE '%unit%'
      THEN 'Admitted'
      WHEN LOWER(disposition) LIKE '%transfer%'
        OR LOWER(disposition) LIKE '%facility%'
      THEN 'Transferred'
      WHEN LOWER(disposition) LIKE '%left%'
        OR LOWER(disposition) LIKE '%walked%'
        OR DispositionKey = -1
      THEN 'Eloped'
      WHEN LOWER(disposition) LIKE '%expired%' THEN 'Expired'
      ELSE 'Discharged'
*/
