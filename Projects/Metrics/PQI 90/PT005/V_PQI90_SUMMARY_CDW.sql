CREATE OR REPLACE VIEW v_pqi90_summary_cdw AS
SELECT
  TO_CHAR(period_start_dt, 'Mon-YYYY') reporting_month,
  network, facility_name, 
  denominator "# Hospitalizations",
  numerator_1 "# Hypertension",
  round(numerator_1/denominator, 2) "% Hypertension",  
  numerator_2 "# Heart failure",  
  round(numerator_2/denominator, 2) "% Heart failure"  
FROM dsrip_report_results
WHERE report_cd = 'PQI90-78'
AND period_start_dt = NVL(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER'),(SELECT MAX(period_start_dt) FROM dsrip_report_results WHERE report_cd = 'PQI90-78'))
ORDER BY CASE WHEN network LIKE 'ALL%' THEN 'ZZZ' ELSE network END, CASE WHEN facility_name LIKE 'ALL%' THEN 'ZZZ' ELSE facility_name END;
