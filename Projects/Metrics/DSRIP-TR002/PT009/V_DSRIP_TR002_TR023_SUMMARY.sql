CREATE OR REPLACE VIEW v_dsrip_tr002_tr023_summary AS
SELECT
  DECODE(GROUPING(t.facility_name), 1, 'All Facilities', t.facility_name) facility_name,
  COUNT(1) as "# Patients",
  COUNT(result_value) "# Results",
  ROUND(COUNT(result_value)/COUNT(1), 2) AS "% Results",
  COUNT(a1c_less_8) "# A1c < 8",
  CASE WHEN COUNT(result_value) > 0 THEN ROUND(COUNT(a1c_less_8)/COUNT(result_value), 2) ELSE 0 END AS "% A1c < 8",
  COUNT(a1c_more_8) "# A1c >= 8",
  COUNT(a1c_more_9) "# A1c >= 9",
  COUNT(a1c_more_9_null) "# A1c >= 9 or NULL"
FROM pt005.a1c_control_8_9 t
GROUP BY ROLLUP(t.facility_name)
ORDER BY GROUPING(t.facility_name), t.facility_name;
