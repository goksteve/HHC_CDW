insert into dim_medical_facilities 
select distinct facility_key, facility_cd, facility_name, tgt_network
from stg_ok_locations;

insert into dim_medical_venues
select distinct facility_key, venue_num, street_address, city, zip_code
from stg_ok_locations;
