CREATE OR REPLACE PROCEDURE prepare_dsrip_report_tr016(p_report_month IN DATE DEFAULT NULL) AS
  d_report_mon  DATE;
  n_cnt         PLS_INTEGER;
BEGIN
  xl.open_log('PREPARE_DSRIP_REPORT_TR016', 'Preparing data of the DSRIP report TR016', TRUE);
  
  xl.begin_action('Setting the report month');
  d_report_mon := TRUNC(NVL(p_report_month, SYSDATE), 'MONTH');
  dbms_session.set_identifier(d_report_mon);
  xl.end_action('Set to '||d_report_mon);
  
  xl.begin_action('Deleting old TR016 data (if any) for '||d_report_mon);
  DELETE FROM dsrip_report_tr016 WHERE report_period_start_dt = d_report_mon;
  n_cnt := SQL%ROWCOUNT;
  
  DELETE FROM dsrip_report_results WHERE report_cd = 'DSRIP-TR016' AND period_start_dt = d_report_mon;
  n_cnt := n_cnt+ SQL%ROWCOUNT;
  xl.end_action(n_cnt||' rows deleted');
  
  etl.add_data
  (
    i_operation => 'INSERT',
    i_tgt => 'DSRIP_REPORT_TR016',
    i_src => 'SELECT * FROM v_dsrip_report_tr016 WHERE rnum = 1',
    i_commit_at => -1
  );
  
  etl.add_data
  (
    i_operation => 'INSERT',
    i_tgt => 'DSRIP_REPORT_RESULTS',
    i_src => 'SELECT 
        ''DSRIP-TR016'' report_cd, 
        report_period_start_dt AS period_start_dt,
        DECODE(GROUPING(network), 1, ''ALL networks'', network) network,
        DECODE(GROUPING(facility_name), 1, ''ALL facilities'', facility_name) AS facility_name,
        COUNT(DISTINCT patient_gid) denominator,
        COUNT(DISTINCT CASE WHEN result_dt IS NOT NULL THEN patient_gid END) numerator_1
      FROM dsrip_report_tr016 r
      GROUP BY GROUPING SETS((report_period_start_dt, network, facility_name),(report_period_start_dt))',
    i_commit_at => -1
  );
  
  xl.close_log('Successfully completed');
EXCEPTION
 WHEN OTHERS THEN
  xl.close_log(SQLERRM, TRUE);
  RAISE;
END;
/
