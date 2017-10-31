CREATE OR REPLACE VIEW v_tr016_detail AS
SELECT
  t.*,
  NVL2(result_dt, 'Y', 'N') screened
FROM dsrip_report_tr016 t
WHERE report_period_start_dt = (SELECT MAX(report_period_start_dt) FROM dsrip_report_tr016) 
ORDER BY patient_name;
