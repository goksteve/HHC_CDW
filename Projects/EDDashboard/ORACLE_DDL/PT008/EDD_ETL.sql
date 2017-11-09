DROP TABLE edd_etl PURGE;

CREATE TABLE edd_etl
(
  source           CHAR(4)
   CONSTRAINT chk_edd_etl_source CHECK(source IN ('QMED','EPIC'))
   CONSTRAINT pk_edd_etl PRIMARY KEY,
  refresh_status   CHAR(1) CHECK(refresh_status IN ('C','R')),
  start_timestamp  DATE,
  end_timestamp    DATE,
  last_processed_value  VARCHAR2(20)
);

GRANT ALL ON edd_etl TO PUBLIC;

INSERT INTO edd_etl VALUES('QMED', 'C', SYSDATE-1, SYSDATE-1, NULL);
INSERT INTO edd_etl VALUES('EPIC', 'C', SYSDATE-1, SYSDATE-1, NULL);

COMMIT;
