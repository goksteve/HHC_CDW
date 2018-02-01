exec dbm.drop_tables('CNF_DW_REFRESH');

CREATE TABLE cnf_dw_refresh
(
  etl_step_num  NUMBER(10) CONSTRAINT pk_cnf_dw_refresh PRIMARY KEY,
  opr           VARCHAR2(30 BYTE) NOT NULL,       
  tgt           VARCHAR2(30 BYTE) NOT NULL,
  tgt_part      VARCHAR2(256 BYTE),
  src           VARCHAR2(30 BYTE) NOT NULL,
  uk_col_list   VARCHAR2(256 BYTE),
  whr           VARCHAR2(2000 BYTE),
  changes_only  CHAR(1 BYTE) DEFAULT 'N' NOT NULL CONSTRAINT chk_cnf_dw_refresh_chg_only CHECK(changes_only IN ('Y', 'N'))
);

INSERT INTO cnf_dw_refresh VALUES(100, 'MERGE', 'DIM_HC_DEPARTMENTS', NULL, 'V_DIM_HC_DEPARTMENTS', 'NETWORK,LOCATION_ID', NULL, 'Y');

COMMIT;
