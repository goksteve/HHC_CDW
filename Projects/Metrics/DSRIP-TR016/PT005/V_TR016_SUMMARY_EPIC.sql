CREATE OR REPLACE VIEW v_tr016_summary_epic AS
SELECT
  TO_CHAR(period_start_dt, 'Mon-YYYY') reporting_month,
  network, facility_name, 
  denominator "# Patients",
  numerator_1 "# Screened",
  round(numerator_1/denominator, 2) "% Screened"  
FROM dsrip_report_results
WHERE report_cd = 'DSRIP-TR016-EPIC'
AND period_start_dt = NVL
(
  SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER'),
  (SELECT MAX(period_start_dt) FROM dsrip_report_results WHERE report_cd = 'DSRIP-TR016-EPIC')
)
ORDER BY
 CASE WHEN network LIKE 'ALL%' THEN 'ZZZ' ELSE network END,
 CASE WHEN facility_name LIKE 'ALL%' THEN 'ZZZ' ELSE facility_name END;
