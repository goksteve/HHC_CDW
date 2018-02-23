exec dbm.drop_tables('LOG_INCREMENTAL_DATA_LOAD');

CREATE TABLE log_incremental_data_load
(
  table_name    VARCHAR2(30 BYTE),
  network       CHAR(3 BYTE) NOT NULL,
  max_cid       NUMBER(14) NOT NULL,
  prev_max_cid  NUMBER(14),
  load_dt       DATE,
  CONSTRAINT pk_incremental_data_load_log PRIMARY KEY(table_name, network)
) ORGANIZATION INDEX;

GRANT SELECT ON log_incremental_data_load TO PUBLIC;
