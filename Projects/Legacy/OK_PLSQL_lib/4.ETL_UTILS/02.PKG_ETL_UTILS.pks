prompt Creating package PKG_ETL_UTILS
 
CREATE OR REPLACE PACKAGE pkg_etl_utils AS
/*
  Package ETL_UTILS contains procedures for performing data transformation operations:
  add data or delete data to/from target tables based on the content of the source views.

  History of changes (newest to oldest):
  ------------------------------------------------------------------------------
  10-Nov-2015, OK: new version
*/

  -- Procedure RESOLVE_NAME resolves the given table/view/synonym name
  -- into complete description of the underlying table/view:
  -- schema, table/view name, DB link
  PROCEDURE resolve_name
  (
    i_name    IN  VARCHAR2,
    o_schema  OUT VARCHAR2,
    o_table   OUT VARCHAR2,
    o_db_link OUT VARCHAR2
  );
 
  -- Function GET_COL_LIST returns a comma-separated list of all the table column names.
  FUNCTION get_col_list(i_table IN VARCHAR2) RETURN VARCHAR2;
 
  -- Function GET_KEY_COL_LIST returns a comma-separated list of the table key column names.
  -- By default, describes the table PK.
  -- Optionally, can describe the given UK,
  FUNCTION get_key_col_list
  (
    i_table IN VARCHAR2,
    i_key   IN VARCHAR2 DEFAULT NULL -- optional name of the UK to be described
  ) RETURN VARCHAR2;

 
  -- Function GET_COLUMN_INFO returns a table-like structure with descriptions of all the table columns.
  -- See definition of the type RESULTSSTAGING.OBJ_COLUMN_INFO.
  FUNCTION get_column_info(i_table IN VARCHAR2) RETURN tab_column_info PIPELINED;


  -- Procedure ADD_DATA selects data from the specified source table or view (I_SRC)
  -- using optional WHERE (I_WHR) condition.
  -- Depending on I_OPERATION, it either merges or inserts the source data into the Target table (I_TGT).
  -- The output parameter O_ADD_CNT gets the number of rows added to the target table.
  -- O_ERR_CNT gets the number of source rows that have been rejected and placed in the error table (O_ERRTAB).
  -- Note: if O_ERRTAB is not specified, then this procedure errors-out
  -- if at least one source row cannot be placed in the target table.
  PROCEDURE add_data
  (
    i_operation   IN VARCHAR2, -- 'INSERT', 'UPDATE', 'MERGE', 'APPEND', 'REPLACE' or 'EQUALIZE'
    i_tgt         IN VARCHAR2, -- target table to add rows to
    i_src         IN VARCHAR2, -- source table or view
    i_whr         IN VARCHAR2 DEFAULT NULL, -- optional WHERE condition to apply to i_src
    i_errtab      IN VARCHAR2 DEFAULT NULL, -- optional error log table,
    i_hint        IN VARCHAR2 DEFAULT NULL, -- optional hint for the source query
    i_commit_at   IN NUMBER   DEFAULT 0, -- 0 - do not commit, otherwise commit
    i_uk_col_list IN VARCHAR2 DEFAULT NULL, -- optional UK column list to use in MERGE operation instead of PK columns
    o_add_cnt     IN OUT PLS_INTEGER, -- number of added/changed rows
    o_err_cnt     IN OUT PLS_INTEGER  -- number of errors
  );
 

  -- "Silent" version of the previous procedure - i.e. with no OUT parameters
  PROCEDURE add_data
  (
    i_operation   IN VARCHAR2, -- 'MERGE', 'APPEND', 'INSERT' 'REPLACE' or 'EQUALIZE'
    i_tgt         IN VARCHAR2, -- target table to add rows to
    i_src         IN VARCHAR2, -- source table or view
    i_whr         IN VARCHAR2 DEFAULT NULL, -- optional WHERE condition to apply to i_src
    i_errtab      IN VARCHAR2 DEFAULT NULL, -- optional error log table
    i_hint        IN VARCHAR2 DEFAULT NULL, -- optional hint for the source query
    i_commit_at   IN NUMBER   DEFAULT 0, -- 0 - do not commit, otherwise commit
    i_uk_col_list IN VARCHAR2 DEFAULT NULL -- optional UK column list to use in MERGE operation instead of PK columns
  );


  -- Procedure DELETE_DATA deletes from the Target table (I_TGT)
  -- the data that exists (I_NOT_IN='N') or not exists (I_NOT_IN='Y')
  -- in the source table/view (I_SRC)
  -- matching rows by either all the columns of the target table Primary Key (default)
  -- or by the given list of unique columns (I_UK_COL_LIST).
  PROCEDURE delete_data
  (
    i_tgt         IN VARCHAR2, -- target table to delete rows from
    i_src         IN VARCHAR2, -- list of rows to be deleted
    i_whr         IN VARCHAR2 DEFAULT NULL, -- optional WHERE condition to apply to i_src
    i_hint        IN VARCHAR2 DEFAULT NULL, -- optional hint for the source query
    i_commit_at   IN PLS_INTEGER DEFAULT 0,
    i_uk_col_list IN VARCHAR2 DEFAULT NULL, -- optional UK column list to use instead of PK columns
    i_not_in      IN VARCHAR2 DEFAULT 'N',
    o_del_cnt     IN OUT PLS_INTEGER -- number of deleted rows
  );

  -- "Silent" version - i.e. with no OUT parameter
  PROCEDURE delete_data
  (
    i_tgt         IN VARCHAR2, -- target table to delete rows from
    i_src         IN VARCHAR2, -- list of rows to be deleted
    i_whr         IN VARCHAR2 DEFAULT NULL, -- optional WHERE condition to apply to i_src
    i_hint        IN VARCHAR2 DEFAULT NULL, -- optional hint for the source query
    i_commit_at   IN PLS_INTEGER DEFAULT 0,
    i_uk_col_list IN VARCHAR2 DEFAULT NULL, -- optional UK column list to use instead of PK columns
    i_not_in      IN VARCHAR2 DEFAULT 'N'
  );
END;
/

CREATE OR REPLACE SYNONYM etl FOR pkg_etl_utils;
GRANT EXECUTE ON etl TO PUBLIC;
