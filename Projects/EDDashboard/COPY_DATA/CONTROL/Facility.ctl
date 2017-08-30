load data
into table edd_stg_facilities truncate
fields terminated by '|'
trailing nullcols
(
  FacilityKey ,
  Facility CHAR(1000),
  FacilityCode CHAR(1000)
)
