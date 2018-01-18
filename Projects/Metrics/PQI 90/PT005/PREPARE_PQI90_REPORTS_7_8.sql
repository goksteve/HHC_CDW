CREATE OR REPLACE PROCEDURE prepare_pqi90_reports_7_8(p_report_month IN DATE DEFAULT NULL) AS
/*
  2018-01-10, OK: created 
*/
  d_report_mon  DATE;
  n_cnt         PLS_INTEGER := 0;
BEGIN
  xl.open_log('PREPARE_PQI90_REPORTS_7_8', SYS_CONTEXT('USERENV','OS_USER')||': Generating PQI90 reports #7 and #8', TRUE);
  
  xl.begin_action('Setting the report month');
  d_report_mon := TRUNC(NVL(p_report_month, SYSDATE), 'MONTH');
  dbms_session.set_identifier(d_report_mon);
  xl.end_action('Set to '||d_report_mon);
  
  xl.begin_action('Deleting old data (if any) for '||d_report_mon);
  DELETE FROM dsrip_report_pqi_7_8_qmed WHERE report_period_start_dt = d_report_mon;
  n_cnt := SQL%ROWCOUNT;
  
  DELETE FROM dsrip_report_results
  WHERE report_cd = 'PQI90-78' AND period_start_dt = d_report_mon;
  n_cnt := n_cnt + SQL%ROWCOUNT;
  
  COMMIT;
  xl.end_action(n_cnt||' rows deleted');
  
  etl.add_data
  (
    i_operation => 'INSERT',
    i_tgt => 'DSRIP_REPORT_PQI_7_8_QMED',
    i_src => 'V_DSRIP_REPORT_PQI_7_8_QMED',
    i_commit_at => -1
  );
  
  etl.add_data
  (
    i_operation => 'INSERT',
    i_tgt => 'DSRIP_REPORT_RESULTS',
    i_src => 'SELECT 
        ''PQI90-78'' report_cd, 
        report_period_start_dt AS period_start_dt,
        DECODE(GROUPING(network), 1, ''ALL networks'', network) network,
        DECODE(GROUPING(hospitalization_facility), 1, ''ALL facilities'', hospitalization_facility) AS facility_name,
        COUNT(1) denominator,
        COUNT(hypertension_code) numerator_1,
        COUNT(heart_failure_code) numerator_2
      FROM dsrip_report_pqi_7_8_qmed r
      WHERE r.report_period_start_dt = '''||d_report_mon||'''
      GROUP BY GROUPING SETS((report_period_start_dt, network, hospitalization_facility),(report_period_start_dt))',
    i_commit_at => -1
  );
  
  xl.close_log('Successfully completed');
EXCEPTION
 WHEN OTHERS THEN
  xl.close_log(SQLERRM, TRUE);
  RAISE;
END;
/
