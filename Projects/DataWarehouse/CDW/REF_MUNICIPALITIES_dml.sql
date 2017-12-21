prompt Populating table REF_MUNICIPALITIES ...

INSERT INTO ref_municipalities
SELECT
  zip_code,
  municipality,
  state,
  municipality_mixed_case,
  municipality_abbr,
  municipality_code
FROM stg_municipalities;

COMMIT;
