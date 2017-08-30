load data
into table dim_Nurses
fields terminated by '|'
trailing nullcols
(
  NurseKey ,
  Nurse CHAR(1000) "DECODE(:Nurse, CHR(00), ' ', :Nurse)"
)
