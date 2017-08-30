load data
infile 'data/Destination.dat'
into table dim_Destinations truncate
fields terminated by '|'
trailing nullcols
(
  DestinationKey ,
  Destination CHAR(1000) "DECODE(:Destination, CHR(00), ' ', :Destination)",
  FacilityKey 
)
