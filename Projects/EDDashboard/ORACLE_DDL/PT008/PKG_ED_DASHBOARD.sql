CREATE OR REPLACE PACKAGE pkg_ed_dashboard AS 
  PROCEDURE process_new_data(p_source IN VARCHAR2 DEFAULT NULL);
END;
/

CREATE OR REPLACE PACKAGE BODY pkg_ed_dashboard AS 
 
  PROCEDURE process_new_data(p_source IN VARCHAR2 DEFAULT NULL) IS
    v_msg               VARCHAR2(2048);
    d_current_mon       DATE;
    d_epic_max_load_dt  DATE;
    d_epic_min_dt       DATE;
    d_qmed_min_dt       DATE;
    d_min_dt            DATE;
  BEGIN
    xl.open_log('PKG_ED_DASHBOARD.PROCESS_NEW_DATA', 'Processing ED data' ||CASE WHEN p_source IS NOT NULL THEN ' received from '||p_source END, TRUE);
    
    EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';
    
    d_current_mon := TRUNC(SYSDATE, 'MONTH');
    
    IF p_source IS NULL OR p_source = 'QMED' THEN
      xl.begin_action('Defining the starting date for QMED ED data processing');
      
      -- Let's recall what was the last month we processed QMED ED data for:
      SELECT TO_DATE(last_processed_value) INTO d_qmed_min_dt
      FROM edd_etl WHERE source = 'QMED';
      
      -- Let's define new starting point:
      d_qmed_min_dt := CASE
        WHEN d_qmed_min_dt IS NULL THEN DATE '2001-01-01'
        ELSE LEAST(ADD_MONTHS(d_current_mon, -1), ADD_MONTHS(d_qmed_min_dt, 1))
      END;
        
      xl.end_action(d_qmed_min_dt);  
    
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
        SELECT
          'MERGE /*+ USE_HASH(t)*/',
          'VW_EDD_QMED_VISITS',
          'EDD_FACT_VISITS',
          'WHERE arrival_dt >= '''||d_qmed_min_dt||'''',
          'ERR_EDD_FACT_VISITS'
        FROM dual
      )
      LOOP
        etl.add_data
        (
          i_operation => r.opr,
          i_src => r.src,
          i_tgt => r.tgt,
          i_whr => r.whr,
          i_errtab => r.errtab,
          i_commit_at => 0 -- no commit
        );
      END LOOP;
      
      UPDATE edd_etl t
      SET last_processed_value = ADD_MONTHS(d_current_mon, -1)
      WHERE source = 'QMED';
    END IF;
    
    IF p_source IS NULL OR p_source = 'EPIC' THEN
      xl.begin_action('Getting MAX load date and MIN arrival date for processing new EPIC ED data');
       
      SELECT MAX(v.load_dt), MIN(v.arrival_dt)
      INTO d_epic_max_load_dt, d_epic_min_dt
      FROM edd_etl etl
      JOIN vw_edd_epic_visits v ON v.load_dt > NVL(TO_DATE(etl.last_processed_value, 'YYYY-MM-DD HH24:MI:SS'), DATE '2001-01-01')
      WHERE etl.source = 'EPIC';
      
      IF d_epic_min_dt IS NOT NULL THEN
        xl.end_action('MAX_LOAD_DT: '||TO_CHAR(d_epic_max_load_dt, 'YYYY-MON-DD HH24:MI:SS')||'; MIN_DT: '||d_epic_min_dt);  
      
        etl.add_data
        (
          i_operation => 'MERGE /*+ USE_HASH(t)*/',
          i_tgt => 'EDD_FACT_VISITS',
          i_src => 'VW_EDD_EPIC_VISITS',
          i_whr => 'WHERE load_dt > '''||d_epic_max_load_dt||'''',
          i_errtab => 'ERR_EDD_FACT_VISITS',
          i_commit_at => 0 -- no commit
        );
        
        UPDATE edd_etl t
        SET last_processed_value = TO_CHAR(d_epic_max_load_dt, 'YYYY-MM-DD HH24:MI:SS')
        WHERE source = 'EPIC';
      ELSE
        xl.end_action('No new EPIC ED data');  
      END IF;
    END IF;
    
    xl.begin_action('Setting MIN_DT for statistics calculation');    
    d_min_dt := LEAST(d_qmed_min_dt, NVL(d_epic_min_dt, d_qmed_min_dt));
    
    IF d_min_dt IS NULL THEN
      Raise_Application_Error(-20000, 'D_MIN_DT is NULL!');
    END IF;

    dbms_session.set_identifier(d_min_dt); -- This value will be used by the views VW_EDD_STATS and VW_EDD_METRIC_VALUES
    xl.end_action(d_min_dt);
      
    FOR r IN
    (
      SELECT 'MERGE' opr, 'VW_EDD_STATS' src, 'EDD_FACT_STATS' tgt, NULL whr, 'ERR_EDD_FACT_STATS' errtab FROM dual
     UNION ALL
      SELECT 'MERGE', 'VW_EDD_METRIC_VALUES', 'EDD_FACT_METRIC_VALUES', NULL, NULL FROM dual
    )
    LOOP
      etl.add_data
      (
        i_operation => r.opr,
        i_src => r.src,
        i_tgt => r.tgt,
        i_whr => r.whr,
        i_errtab => r.errtab,
        i_commit_at => 0
      );
    END LOOP;
    
    COMMIT;
    
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
