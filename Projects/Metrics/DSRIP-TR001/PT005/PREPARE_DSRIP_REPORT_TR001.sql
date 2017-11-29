CREATE OR REPLACE PROCEDURE prepare_dsrip_report_tr001(p_report_month IN DATE DEFAULT NULL) AS
  d_report_mon  DATE;
  n_cnt         PLS_INTEGER;
BEGIN
  xl.open_log('PREPARE_DSRIP_REPORT_TR001', SYS_CONTEXT('USERENV','OS_USER')||': Generating DSRIP report TR001', TRUE);
  
  xl.begin_action('Setting the report month');
  d_report_mon := TRUNC(NVL(p_report_month, SYSDATE), 'MONTH');
  dbms_session.set_identifier(d_report_mon);
  xl.end_action('Set to '||d_report_mon);
  
  xl.begin_action('Deleting old TR001 data (if any) for '||d_report_mon);
  DELETE FROM dsrip_report_tr001_qmed WHERE report_period_start_dt = d_report_mon;
  n_cnt := SQL%ROWCOUNT;
  
  DELETE FROM dsrip_report_tr001_epic WHERE report_period_start_dt = d_report_mon;
  n_cnt := n_cnt + SQL%ROWCOUNT;
  
  DELETE FROM dsrip_report_results
  WHERE report_cd LIKE 'DSRIP-TR001%' AND period_start_dt = d_report_mon;
  n_cnt := n_cnt + SQL%ROWCOUNT;
  
  COMMIT;
  xl.end_action(n_cnt||' rows deleted');
  
  etl.add_data
  (
    i_operation => 'INSERT',
    i_tgt => 'DSRIP_REPORT_TR001_QMED',
    i_src => 'V_DSRIP_REPORT_TR001_QMED',
    i_commit_at => -1
  );
  
  etl.add_data
  (
    i_operation => 'INSERT',
    i_tgt => 'DSRIP_REPORT_RESULTS',
    i_src => 'SELECT 
        ''DSRIP-TR001'' report_cd, 
        report_period_start_dt AS period_start_dt,
        DECODE(GROUPING(network), 1, ''ALL networks'', network) network,
        DECODE(GROUPING(hospitalization_facility), 1, ''ALL facilities'', hospitalization_facility) AS facility_name,
        COUNT(1) denominator,
        COUNT(follow_up_30_days) numerator_1,
        COUNT(follow_up_7_days) numerator_2
      FROM dsrip_report_tr001_qmed r
      WHERE r.report_period_start_dt = '''||d_report_mon||'''
      GROUP BY GROUPING SETS((report_period_start_dt, network, hospitalization_facility),(report_period_start_dt))',
    i_commit_at => -1
  );
  
  etl.add_data
  (
    i_operation => 'INSERT',
    i_tgt => 'DSRIP_REPORT_TR001_EPIC',
    i_src => 'V_DSRIP_REPORT_TR001_EPIC',
    i_whr => 'WHERE rnum = 1',
    i_commit_at => -1
  );
  
  etl.add_data
  (
    i_operation => 'INSERT',
    i_tgt => 'DSRIP_REPORT_RESULTS',
    i_src => 'SELECT 
      ''DSRIP-TR001-EPIC'' report_cd, 
      report_period_start_dt AS period_start_dt,
      ''EPIC'' network,
      DECODE(GROUPING(hospitalization_facility), 1, ''ALL facilities'', hospitalization_facility) AS facility_name,
      COUNT(1) denominator,
      COUNT(CASE WHEN thirtyday_followup <> ''0'' THEN 1 END) numerator_1,
      COUNT(CASE WHEN sevenday_followup <> ''0'' THEN 1 END) numerator_2
    FROM dsrip_report_tr001_epic
    WHERE report_period_start_dt = '''||d_report_mon||''' 
    GROUP BY GROUPING SETS((report_period_start_dt, hospitalization_facility), (report_period_start_dt))',
    i_commit_at => -1
  );
  
  xl.close_log('Successfully completed');
EXCEPTION
 WHEN OTHERS THEN
  xl.close_log(SQLERRM, TRUE);
  RAISE;
END;
/
