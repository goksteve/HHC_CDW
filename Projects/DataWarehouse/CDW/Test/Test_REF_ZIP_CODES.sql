select state, municipality, count(1) cnt
from ref_municipalities
group by state, municipality
having count(1) > 1;

select * from ref_municipalities
where state = 'PR' and municipality = 'URB SANTA MARIA';

select *
from 
(
  select
    adr.street_addr, adr.city, adr.state, adr.zip_code, adr.data_source, adr.cnt, nvl(m.zip_code, zc.zip_code) resolved_zip_code,
    count(1) over(partition by adr.city, adr.state) dup_cnt 
  from
  (
    select
      street_addr, city, state, zip_code, min(data_source) data_source, count(1) cnt
    from imp_street_addresses
    group by street_addr, city, state, zip_code
  ) adr
  left join ref_municipalities m
    on m.state = adr.state and m.municipality = upper(adr.city)
  left join ref_zip_codes zc
    on zc.state = adr.state and zc.city = upper(adr.city)
  where adr.zip_code is null
)
where dup_cnt = 1
order by zip_code nulls first
;