CREATE OR REPLACE VIEW v_dim_procedures AS
SELECT
 -- 1-FEB-2018, OK: created
  p.network,
  p.proc_id AS src_proc_id,
  p.name AS proc_name,
  f.facility_key,
  pt.proc_type_name AS proc_type,
  kg.name AS kardex_group,
  DECODE(primary_proc_flag, 'T', 'Y', 'F', 'N') is_primary,
  DECODE(nursing_proc_flag, 'T', 'Y', 'F', 'N') is_nursing, 
  'QCPR' AS source
FROM proc p
LEFT JOIN dim_hc_facilities f ON f.network = p.network AND f.facility_id = p.facility_id
LEFT JOIN proc_type pt ON pt.network = p.network AND pt.proc_type_id = p.proc_type_id 
LEFT JOIN kardex_group kg ON kg.network = p.network AND kg.kardex_group_id = p.kardex_group_id
WHERE p.name IS NOT NULL;
