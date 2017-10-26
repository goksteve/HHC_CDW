CREATE OR REPLACE PACKAGE pkg_ed_dashboard AS 
  PROCEDURE process_qmed_data;
  PROCEDURE process_epic_data;
END;
/

CREATE OR REPLACE PACKAGE BODY pkg_ed_dashboard AS 
  v_msg             VARCHAR2(2048);
  
  PROCEDURE prepare_email_message IS
  BEGIN
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
  END;

  PROCEDURE process_qmed_data IS
    n_min_qmed_key    NUMBER(10);
    n_max_qmed_key    NUMBER(10);
    d_min_qmed_dt     DATE;
  BEGIN
    xl.open_log('PKG_ED_DASHBOARD.PROCESS_QMED_DATA', 'Processing ED data received from QuadraMed', TRUE);
    
    EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';
    
    xl.begin_action('Getting MIN and MAX values to limit QMed EDD data processing');
    
    SELECT NVL(MIN(last_processed_value), '0') INTO n_min_qmed_key FROM edd_etl WHERE source = 'QMED';
    
    SELECT MAX(visit_key), MIN(arrival_dt)
    INTO n_max_qmed_key, d_min_qmed_dt
    FROM vw_edd_qmed_visits
    WHERE visit_key >= n_min_qmed_key;
    
    dbms_session.set_identifier(d_min_qmed_dt); -- This value will be used by the views VW_EDD_STATS and VW_EDD_METRIC_VALUES
    
    xl.end_action('MIN KEY: '||n_min_qmed_key||'; MAX KEY: '||n_max_qmed_key||'; MIN DATE: '||d_min_qmed_dt);  
    
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
      SELECT 'MERGE', 'EDDASHBOARD.EDD_STG_FACILITIES', 'EDD_DIM_FACILITIES', NULL, NULL FROM dual UNION ALL
      SELECT 'MERGE', 'EDDASHBOARD.EDD_STG_DISPOSITIONS', 'EDD_QMED_DISPOSITIONS', NULL, NULL FROM dual UNION ALL
      SELECT 'MERGE /*+ USE_HASH(t)*/', 'VW_EDD_QMED_VISITS', 'EDD_FACT_VISITS', 'WHERE visit_key >= '||n_min_qmed_key, 'ERR_EDD_FACT_VISITS' FROM dual UNION ALL
      SELECT 'MERGE', 'VW_EDD_STATS', 'EDD_FACT_STATS', NULL, 'ERR_EDD_FACT_STATS' FROM dual UNION ALL
      SELECT 'MERGE /*+ USE_HASH(t)*/', 'VW_EDD_METRIC_VALUES', 'EDD_FACT_METRIC_VALUES', NULL, NULL FROM dual
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
    
    MERGE INTO edd_etl t 
    USING
    (
      SELECT 'QMED' source, TO_CHAR(n_max_qmed_key) last_processed_value
      FROM dual 
    ) q
    ON (t.source = q.source)
    WHEN MATCHED THEN UPDATE SET t.last_processed_value = q.last_processed_value
    WHEN NOT MATCHED THEN INSERT VALUES(q.source, q.last_processed_value);
    
    COMMIT;
    
    prepare_email_message;
    
    xl.close_log(v_msg);
  EXCEPTION
   WHEN OTHERS THEN
    xl.close_log(SQLERRM, TRUE);
    RAISE;
  END;
  
  
  PROCEDURE process_epic_data IS
    d_min_dt     DATE;
  BEGIN
    xl.open_log('PKG_ED_DASHBOARD.PROCESS_EPIC_DATA', 'Processing ED data received from EPIC', TRUE);
    
    xl.begin_action('Getting MIN arrival date'); 
    SELECT MIN(arrival_dt)
    INTO d_min_dt
    FROM vw_edd_epic_visits;
    
    dbms_session.set_identifier(d_min_dt); -- This value will be used by the views VW_EDD_STATS and VW_EDD_METRIC_VALUES
    
    xl.end_action(d_min_dt);  
    
    FOR r IN
    (
      SELECT
        'MERGE /*+ USE_HASH(t)*/' opr,
        'VW_EDD_EPIC_VISITS' src,
        'EDD_FACT_VISITS' tgt,
        'ERR_EDD_FACT_VISITS' errtab
      FROM dual
     UNION ALL
      SELECT 'MERGE', 'VW_EDD_STATS', 'EDD_FACT_STATS', 'ERR_EDD_FACT_STATS' FROM dual
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
    
    prepare_email_message;
    
    xl.close_log(v_msg);
  EXCEPTION
   WHEN OTHERS THEN
    xl.close_log(SQLERRM, TRUE);
    RAISE;
  END;
END;
/
