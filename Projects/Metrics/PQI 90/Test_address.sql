select dq, count(1) cnt
from
(
  select
    case
      when city is null and zipcode is null then 'NO ADDRESS'
      when zipcode is null then 'NULL ZIP'
      else 'GOOD ADDR'
    end dq 
  --  eid, ssn, patientid, onmfirst, onmlast, facility_name, mrn, streetadr, city, state, zipcode  
  from DCONV.MDM_QCPR_PT_02122016
  --where zipcode is null and city is not null
)
group by dq 