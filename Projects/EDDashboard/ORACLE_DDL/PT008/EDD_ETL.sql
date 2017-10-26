exec dbm.drop_tables('EDD_ETL');

CREATE TABLE edd_etl
(
  source                VARCHAR2(10) NOT NULL
   CONSTRAINT chk_edd_etl_source CHECK(source IN ('QMED','EPIC')) CONSTRAINT pk_edd_etl PRIMARY KEY,
  last_processed_value  VARCHAR2(20)
) ORGANIZATION INDEX;

GRANT SELECT ON edd_etl TO PUBLIC;
