exec dbm.drop_tables('CNF_DW_REFRESH');

CREATE TABLE cnf_dw_refresh
(
  etl_step_num      NUMBER(10) CONSTRAINT pk_cnf_dw_refresh PRIMARY KEY,
  operation         VARCHAR2(30 BYTE) NOT NULL,       
  target_table      VARCHAR2(30 BYTE) NOT NULL,
  target_partition  VARCHAR2(256 BYTE),
  data_source       VARCHAR2(30 BYTE) NOT NULL,
  uk_col_list       VARCHAR2(256 BYTE),
  where_clause      VARCHAR2(2000 BYTE),
  changes_only      CHAR(1 BYTE) DEFAULT 'N' NOT NULL CONSTRAINT chk_cnf_dw_refresh_chg_only CHECK(changes_only IN ('Y', 'N')),
  delete_condition  VARCHAR2(2000 BYTE)
);

truncate table cnf_dw_refresh;

INSERT INTO cnf_dw_refresh VALUES(90, 'MERGE /*+ PARALLEL(16)*/', 'REF_DIAGNOSES', NULL, 'V_REF_DIAGNOSES', NULL, NULL, 'Y', 'DELETE_FLAG=''Y''');
INSERT INTO cnf_dw_refresh VALUES(95, 'EQUALIZE /*+ PARALLEL(16)*/', 'MAP_DIAGNOSES_CODES', NULL, 'V_MAP_DIAGNOSES_CODES', NULL, NULL, 'Y', NULL);
INSERT INTO cnf_dw_refresh VALUES(100, 'MERGE /*+ PARALLEL(16)*/', 'DIM_HC_DEPARTMENTS', NULL, 'V_DIM_HC_DEPARTMENTS', 'NETWORK,LOCATION_ID', NULL, 'Y', NULL);
INSERT INTO cnf_dw_refresh VALUES(105, 'MERGE /*+ PARALLEL(16)*/', 'DIM_PROCEDURES', NULL, 'V_DIM_PROCEDURES', 'NETWORK,SRC_PROC_ID', NULL, 'Y', NULL);

COMMIT;
