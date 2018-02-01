CREATE OR REPLACE PACKAGE BODY pkg_dw_maintenance AS
/*
  Procedures for Data Warehouse maintenance
   
  Change history
  ------------------------------------------------------------------------------
  01-FEB-2018, OK: created
*/
  PROCEDURE refresh_data(p_table_list VARCHAR2 DEFAULT NULL) IS
    rcur  SYS_REFCURSOR;
    rec   cnf_dw_refresh%ROWTYPE;
  BEGIN
    xl.open_log('DWM.REFRESH_DATA', 'Refreshing DW'||CASE WHEN p_table_list IS NOT NULL THEN ': '||p_table_list END, TRUE);
    
    OPEN rcur FOR
    'SELECT * FROM cnf_dw_refresh'||
    CASE WHEN p_table_list IS NOT NULL THEN '
    WHERE tgt IN ('''||REPLACE(UPPER(p_table_list), ',', ''',''')||''')' 
    END || '
    ORDER BY etl_step_num';
    
    LOOP
      FETCH rcur INTO rec;
      EXIT WHEN rcur%NOTFOUND;
      
      etl.add_data
      (
        p_operation => rec.opr,
        p_tgt => rec.tgt,
        p_src => rec.src,
        p_whr => rec.whr,
        p_uk_col_list => rec.uk_col_list,
        p_changes_only => rec.changes_only,
        p_commit_at => -1
      );
    END LOOP;
    
    CLOSE rcur;
    
    xl.close_log('Successfully completed');
  EXCEPTION
   WHEN OTHERS THEN
    ROLLBACK;
    xl.close_log(SQLERRM, TRUE);
    CLOSE rcur;
    RAISE;
  END;

END;
/
