CREATE OR REPLACE VIEW v_ref_hc_specialties AS
SELECT
  -- 23-Feb-2018, OK: created
  code, description, service_type
FROM
(
  SELECT
    code, description, service_type,
    ROW_NUMBER() OVER(PARTITION BY code ORDER BY network, description) rnum
  FROM
  (
    SELECT code, network, description, 'BH' service_type FROM stg_bh_clinic_codes
    UNION ALL
    SELECT code, network, description, 'PCP' service_type FROM stg_pcp_clinic_codes
  )
)
WHERE rnum = 1;