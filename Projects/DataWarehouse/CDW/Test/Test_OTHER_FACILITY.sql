select
  'OTHER_FACILITY' src, 
  name, short_name, network, other_facility_id facility_id, street_address, city, state, postal_code
from tst_ok_other_facilities
union all
select 'FACILITY' src, name, null short_name, network, facility_id, null, null, null, null
from facility
order by name, src, short_name, network;