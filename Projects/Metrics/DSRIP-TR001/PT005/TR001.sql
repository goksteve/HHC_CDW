set feedback off
/*
-- One-time DDL:
@TR001_VISITS.sql
@TR001_DIAGNOSES.sql
@TR001_PAYERS.sql
@TR001_PROVIDERS.sql
@REF_HEDIS_VALUE_SETS.sql
@DSRIP_REPORT_TR001.sql
@INSURANCE_TYPE.fnc
@V_DSRIP_REPORT_TR001.sql
*/

-- Run every month:
prompt Preparing DSRIP report TR001

exec xl.open_log('DSRIP-TR001', 'Preparing DSRIP report TR001', TRUE);

exec xl.begin_action('Truncating staging tables');
truncate table tst_ok_tr001_visits;
truncate table tst_ok_tr001_diagnoses;
truncate table tst_ok_tr001_providers;
truncate table tst_ok_tr001_payers;
exec xl.end_action;

@copy_table.sql TR001_VISITS
@copy_table.sql TR001_DIAGNOSES
@copy_table.sql TR001_PROVIDERS
@copy_table.sql TR001_PAYERS

DECLARE
  v_report_mon  VARCHAR2(20);
  n_cnt         PLS_INTEGER;
BEGIN
  xl.begin_action('Setting the report month');
  SELECT DISTINCT TRUNC(discharge_dt, 'MONTH') INTO v_report_mon
  FROM tst_ok_tr001_visits
  WHERE visit_type_cd = 'IP';
  xl.end_action('Set to '||v_report_mon);
  
  dbms_session.set_identifier(v_report_mon);
  
  xl.begin_action('Deleting old TR001 data (if any) for '||v_report_mon);
  DELETE FROM dsrip_report_tr001 WHERE report_period_start_dt = v_report_mon;
  n_cnt := SQL%ROWCOUNT;
  DELETE FROM dsrip_report_results WHERE report_cd = 'DSRIP-TR001' AND period_start_dt = v_report_mon;
  n_cnt := n_cnt+ SQL%ROWCOUNT;
  xl.end_action(n_cnt||' rows deleted');
  
  etl.add_data
  (
    i_operation => 'INSERT',
    i_tgt => 'DSRIP_REPORT_TR001',
    i_src => 'V_DSRIP_REPORT_TR001',
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
      FROM dsrip_report_tr001 r
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
