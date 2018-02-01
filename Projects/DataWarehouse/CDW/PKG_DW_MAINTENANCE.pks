CREATE OR REPLACE PACKAGE pkg_dw_maintenance AS
/*
  Procedures for Data Warehouse maintenance
   
  Change history
  ------------------------------------------------------------------------------
  01-FEB-2018, OK: created
*/

  PROCEDURE refresh_data(p_table_list VARCHAR2 DEFAULT NULL);
    
END;
/

CREATE OR REPLACE SYNONYM dwm FOR pkg_dw_maintenance;
