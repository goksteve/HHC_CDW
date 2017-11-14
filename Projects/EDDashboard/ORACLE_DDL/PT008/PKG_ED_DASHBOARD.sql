CREATE OR REPLACE PACKAGE pkg_ed_dashboard AS 
  PROCEDURE process_new_data(p_source IN VARCHAR2 DEFAULT NULL);
END;
/

CREATE OR REPLACE PACKAGE BODY pkg_ed_dashboard AS 
 
  PROCEDURE process_new_data(p_source IN VARCHAR2 DEFAULT NULL) IS
    v_msg           VARCHAR2(2048);
    d_prev_load_dt  DATE;
    c_next_load_dt  CHAR(19);
    d_epic_min_dt   DATE;
    d_qmed_min_dt   DATE;
    d_min_dt        DATE;
  BEGIN
    xl.open_log('PKG_ED_DASHBOARD.PROCESS_NEW_DATA', 'Processing ED data' ||CASE WHEN p_source IS NOT NULL THEN ' received from '||p_source END, TRUE);
    
    EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';
    
    IF p_source IS NULL OR p_source = 'QMED' THEN
      xl.begin_action('Defining starting point for QMED ED data processing');
      
      -- Let's recall what is the last QMED data timestamp we've processed:
      SELECT TO_DATE(last_processed_value, 'YYYY-MM-DD HH24:MI:SS') INTO d_prev_load_dt
      FROM edd_etl WHERE source = 'QMED';
      
      -- This value is used in the logic of the view VW_EDD_QMED_VISITS:
      DBMS_SESSION.SET_IDENTIFIER(TO_CHAR(d_prev_load_dt, 'YYYY-MM-DD HH24:MI:SS')); 

      xl.end_action('PREV_LOAD_DT: '||SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER'));
      
      FOR r IN
      (
        SELECT
          'INSERT' opr,
          'EDD_STG_TIME' src,
          'EDD_DIM_TIME' tgt,
          'WHERE DimTimeKey > 0 AND DimTimeKey NOT IN (SELECT DimTimeKey FROM edd_dim_time)' whr,
          CAST(NULL AS VARCHAR2(30)) errtab
        FROM dual
       UNION ALL
        SELECT 'MERGE', 'EDDASHBOARD.EDD_STG_FACILITIES', 'EDD_DIM_FACILITIES', NULL, NULL FROM dual
       UNION ALL
        SELECT 'MERGE', 'EDDASHBOARD.EDD_STG_DISPOSITIONS', 'EDD_QMED_DISPOSITIONS', NULL, NULL FROM dual
       UNION ALL
        SELECT 'MERGE /*+ USE_HASH(t)*/', 'VW_EDD_QMED_VISITS', 'EDD_FACT_VISITS', NULL, 'ERR_EDD_FACT_VISITS' FROM dual
      )
      LOOP
        etl.add_data
        (
          i_operation => r.opr,
          i_src => r.src,
          i_tgt => r.tgt,
          i_whr => r.whr,
          i_errtab => r.errtab,
          i_commit_at => -1
        );
      END LOOP;
      
      xl.begin_action('Recording dates of the processed QMED data');
      
      SELECT MIN(arrival_dt), TO_CHAR(MAX(load_dt), 'YYYY-MM-DD HH24:MI:SS')
      INTO d_qmed_min_dt, c_next_load_dt
      FROM edd_fact_visits
      WHERE source = 'QMED' AND load_dt > d_prev_load_dt;
       
      UPDATE edd_etl t
      SET last_processed_value = c_next_load_dt
      WHERE source = 'QMED';
      
      COMMIT;
      
      xl.end_action('Latest LOAD_DT: '||c_next_load_dt||'; Earliest ARRIVAL_DT: ' ||d_qmed_min_dt);      
      
    END IF;
    
    IF p_source IS NULL OR p_source = 'EPIC' THEN
      xl.begin_action('Defining starting point for EPIC ED data processing');

      -- Let's recall what is the last EPIC ED data timestamp we've processed:
      SELECT TO_DATE(last_processed_value, 'YYYY-MM-DD HH24:MI:SS') INTO d_prev_load_dt
      FROM edd_etl WHERE source = 'EPIC';

      -- This value is used in the logic of the view VW_EDD_EPIC_VISITS:
      DBMS_SESSION.SET_IDENTIFIER(TO_CHAR(d_prev_load_dt, 'YYYY-MM-DD HH24:MI:SS')); 

      xl.end_action('PREV_LOAD_DT: '||SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER'));  
      
      etl.add_data
      (
        i_operation => 'MERGE /*+ USE_HASH(t)*/',
        i_tgt => 'EDD_FACT_VISITS',
        i_src => 'VW_EDD_EPIC_VISITS',
        i_errtab => 'ERR_EDD_FACT_VISITS',
        i_commit_at => -1
      );
      
      xl.begin_action('Recording Dates of the processed EPIC dataset');
      SELECT TO_CHAR(MAX(load_dt), 'YYYY-MM-DD HH24:MI:SS'), MIN(arrival_dt)
      INTO c_next_load_dt, d_epic_min_dt
      FROM edd_fact_visits
      WHERE source = 'EPIC' AND load_dt > d_prev_load_dt; 
      
      UPDATE edd_etl t
      SET last_processed_value = c_next_load_dt
      WHERE source = 'EPIC';
      
      COMMIT;
      
      xl.end_action('Latest LOAD_DT: '||c_next_load_dt||'; Earliest ARRIVAL_DT: '||d_epic_min_dt);  

    END IF;
    
    xl.begin_action('Setting MIN_DT for statistics calculation');    
    d_min_dt := LEAST(NVL(d_qmed_min_dt, d_epic_min_dt), NVL(d_epic_min_dt, d_qmed_min_dt));
    
    IF d_min_dt IS NULL THEN
      Raise_Application_Error(-20000, 'D_MIN_DT is NULL!');
    END IF;

    DBMS_SESSION.SET_IDENTIFIER(d_min_dt); -- This value will be used by the views VW_EDD_STATS and VW_EDD_METRIC_VALUES
    xl.end_action(d_min_dt);
      
    FOR r IN
    (
      SELECT 'MERGE' opr, 'VW_EDD_STATS' src, 'EDD_FACT_STATS' tgt, 'ERR_EDD_FACT_STATS' errtab FROM dual
     UNION ALL
      SELECT 'MERGE', 'VW_EDD_METRIC_VALUES', 'EDD_FACT_METRIC_VALUES', NULL FROM dual
    )
    LOOP
      etl.add_data
      (
        i_operation => r.opr,
        i_src => r.src,
        i_tgt => r.tgt,
        i_errtab => r.errtab,
        i_commit_at => -1
      );
    END LOOP;
    
    SELECT
      'Successfully completed'||CHR(10)||
      '-------------------------------------------------------------------------'||CHR(10)||
      concat_v2_set
      (
        CURSOR
        (
          SELECT action||':'||CHR(9)||comment_txt 
          FROM dbg_log_data
          WHERE proc_id = xl.get_current_proc_id
          AND action LIKE 'Adding data to%'
          AND comment_txt NOT LIKE 'Operation%'
          ORDER BY tstamp
        ),
        CHR(10)
      )
    INTO v_msg FROM dual;
    
    xl.close_log(v_msg);
  EXCEPTION
   WHEN OTHERS THEN
    ROLLBACK;
    xl.close_log(SQLERRM, TRUE);
    RAISE;
  END;
END;
/
