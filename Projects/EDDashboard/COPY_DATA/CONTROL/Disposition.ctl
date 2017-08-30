load data
into table edd_stg_dispositions truncate
fields terminated by '|'
trailing nullcols
(
  DispositionKey ,
  Disposition CHAR(1000) "DECODE(:Disposition, CHR(00), ' ', :Disposition)",
  DispositionLookup CHAR(1000) "DECODE(:DispositionLookup, CHR(00), ' ', :DispositionLookup)"
)
