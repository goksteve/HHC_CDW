load data
into table dim_Providers
fields terminated by '|'
trailing nullcols
(
  ProviderKey,
  Provider CHAR(1000) "DECODE(:Provider, CHR(00), ' ', :Provider)"
)
