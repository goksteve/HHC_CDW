prompt Populating table REF_ZIP_CODES ...

INSERT INTO ref_zip_codes
SELECT DISTINCT
  zip_code,
  city,
  county,
  state,
  area_code,
  latitude,
  longitude,
  time_zone,
  elevation,
  day_light_saving,
  city_mixed_case,
  city_type,
  county_mixed_case
FROM stg_municipalities
WHERE primary_record = 'P';

COMMIT;