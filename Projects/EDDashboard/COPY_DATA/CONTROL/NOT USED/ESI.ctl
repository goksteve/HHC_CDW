load data
into table edd_dim_ESI
fields terminated by '|'
trailing nullcols
(
  ESIKey ,
  ESI CHAR(1000) "DECODE(:ESI, CHR(00), ' ', :ESI)"
)
