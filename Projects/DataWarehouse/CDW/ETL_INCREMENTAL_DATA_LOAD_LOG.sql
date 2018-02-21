CREATE TABLE bkp_incremental_data_load_log as select * from etl_incremental_data_load_log;

exec dbm.drop_tables('ETL_INCREMENTAL_DATA_LOAD_LOG');

CREATE TABLE etl_incremental_data_load_log
(
  table_name    VARCHAR2(30 BYTE),
  network       CHAR(3 BYTE) NOT NULL,
  max_cid       NUMBER(14) NOT NULL,
  prev_max_cid  NUMBER(14),
  load_dt       DATE,
  CONSTRAINT pk_incremental_data_load_log PRIMARY KEY(table_name, network)
) ORGANIZATION INDEX;

GRANT SELECT ON etl_incremental_data_load_log TO PUBLIC;
