drop table exp_street_addresses purge;

CREATE TABLE exp_street_addresses AS
SELECT
  f.address_string|| 
  case when f.apartment_nbr is not null then ' '||f.apartment_nbr end ||
  case when f.building_name is not null then ' '||f.building_name end ||
  case when f.building_nbr is not null then ' '||f.building_nbr end
  AS street_addr,
  f.city,
  UPPER(SUBSTR(f.state, 1, 2)) state,
  SUBSTR(LTRIM(f.mailing_code), 1, 5) AS zip_code,
  db.name||'/EMP_FACILITY' data_source
FROM ud_master.emp_facility f
CROSS JOIN v$database db
WHERE f.state IS NOT NULL OR (f.city IS NOT NULL AND f.state IS NOT NULL) 
UNION
SELECT
  f.street_address,
  f.city,
  UPPER(SUBSTR(f.state, 1, 2)),
  SUBSTR(LTRIM(f.postal_code), 1, 5) AS zip_code,
  db.name||'/OTHER_FACILITY'
FROM ud_master.other_facility f
CROSS JOIN v$database db
WHERE f.state IS NOT NULL OR (f.city IS NOT NULL AND f.state IS NOT NULL)
UNION
SELECT
  f.mailing_address,
  f.mailing_city,
  UPPER(SUBSTR(f.mailing_state, 1, 2)),
  SUBSTR(LTRIM(f.mailing_code), 1, 5),
  db.name||'/OTHER_FACILITY/MAILING'
FROM ud_master.other_facility f
CROSS JOIN v$database db
WHERE f.mailing_state IS NOT NULL OR (f.mailing_city IS NOT NULL AND f.mailing_state IS NOT NULL);
