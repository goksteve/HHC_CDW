CREATE OR REPLACE VIEW v_dim_hc_departments AS
WITH
 -- 31-JAN-2018, OK: created
  loc AS
  (
    SELECT
      LEVEL lvl,
      network, facility_id, location_id, name,
      SYS_CONNECT_BY_PATH(NVL(name, 'NA'), '~') path_name,
      CASE WHEN UPPER(bed) = 'TRUE' THEN 'Y' else 'N' END is_bed
    FROM location
    CONNECT BY network = PRIOR network AND parent_location_id = PRIOR location_id AND location_id <> PRIOR location_id 
    START WITH parent_location_id IS NULL OR location_id = '-1'
  ),
  area AS
  (
    SELECT
      loc.*,
      REGEXP_SUBSTR(path_name,'[^~]+') division,
      NVL(REGEXP_SUBSTR(path_name,'[^~]+', 1, 2), 'N/A') department,
      NVL(REGEXP_SUBSTR(path_name,'[^~]+', 1, 3), 'N/A') zone
    FROM loc
  ),
  dep AS
  (
    SELECT
      ar.network, ar.location_id, f.facility_key, 
      f.facility_name AS facility, ar.division, ar.department, ar.zone, ar.is_bed,
      CASE
        WHEN(division LIKE '%Interface%' OR division LIKE '%I/F%') AND LOWER(department) NOT LIKE 'shell%'
          THEN NVL(REGEXP_SUBSTR(department, '([0-9]+) *$', 1, 1, 'c', 1), 'N/A')
        ELSE 'N/A'
      END specialty_code
    FROM area ar
    JOIN dim_hc_facilities f ON f.network = ar.network AND f.src_facility_id = ar.facility_id
  )
SELECT
  dep.*,
  NVL(hcc.description, 'N/A') AS specialty,
  NVL(hcc.service, 'N/A') service,
  NVL(rcc.service_type, 'N/A') service_type,
  'HHC_CUSTOM.HHC_CLINIC_CODES + CDW.REF_CLINIC_CODES'  AS source
FROM dep
LEFT JOIN
(
  SELECT
    code, description, service,
    ROW_NUMBER() OVER(PARTITION BY code ORDER BY NETWORK) rnum
  FROM hhc_clinic_codes
) hcc ON hcc.code = dep.specialty_code AND hcc.rnum = 1
LEFT JOIN
(
  SELECT LTRIM(TO_CHAR(code, '000')) code, MIN(category_id) service_type
  FROM ref_clinic_codes
  GROUP BY code  
) rcc ON rcc.code = dep.specialty_code;
