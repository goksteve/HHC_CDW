load data
into table dim_ClinicCodes
fields terminated by '|'
trailing nullcols
(
  ClinicCodeKey ,
  ClinicCode CHAR(1000) "DECODE(:ClinicCode, CHR(00), ' ', :ClinicCode)",
  ClinicCodeDesc CHAR(1000) "DECODE(:ClinicCodeDesc, CHR(00), ' ', :ClinicCodeDesc)"
)
