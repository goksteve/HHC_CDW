exec dbm.drop_tables('EDD_ETL');

CREATE TABLE edd_etl
(
  source                VARCHAR2(10) NOT NULL
   CONSTRAINT chk_edd_etl_source CHECK(source IN ('QMED','EPIC')) CONSTRAINT pk_edd_etl PRIMARY KEY,
  refresh_status        CHAR(1) CHECK(refresh_status IN ('C','R')),
  start_timestamp       DATE,
  end_timestamp         DATE,
  last_processed_value  VARCHAR2(20)
);

GRANT SELECT ON edd_etl TO PUBLIC;
GRANT INSERT, UPDATE ON edd_etl TO eddashboard, epic_ed_dashboard;
