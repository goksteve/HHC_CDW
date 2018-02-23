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
          THEN TO_NUMBER(REGEXP_SUBSTR(department, '([0-9]+) *$', 1, 1, 'c', 1))
      END specialty_code
    FROM area ar
    JOIN dim_hc_facilities f ON f.network = ar.network AND f.facility_id = ar.facility_id
  )
SELECT
  dep.*,
  NVL(c.description, 'N/A') AS specialty,
  NVL(c.service, 'N/A') service,
  NVL(s.service_type, 'N/A') service_type,
  'QCPR' AS source
FROM dep
LEFT JOIN hhc_clinic_codes c
  ON c.network = dep.network AND c.code = dep.specialty_code
LEFT JOIN ref_hc_specialties s
  ON s.code = dep.specialty_code;
