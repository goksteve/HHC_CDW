CREATE OR REPLACE VIEW v_tr001_summary_cdw AS
SELECT
  TO_CHAR(period_start_dt, 'Mon-YYYY') reporting_month,
  network, facility_name, 
  denominator "# Patients",
  numerator_1 "# 30-day follow-up",
  round(numerator_1/denominator, 2) "% 30-day follow-up",  
  numerator_2 "# 7-day follow-up",  
  round(numerator_2/denominator, 2) "% 7-day follow-up"  
FROM dsrip_report_results
WHERE report_cd = 'DSRIP-TR001'
AND period_start_dt = NVL(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER'),(SELECT MAX(period_start_dt) FROM dsrip_report_results WHERE report_cd = 'DSRIP-TR001'))
ORDER BY CASE WHEN network LIKE 'ALL%' THEN 'ZZZ' ELSE network END, CASE WHEN facility_name LIKE 'ALL%' THEN 'ZZZ' ELSE facility_name END;
