load data
into table dim_Attending
fields terminated by '|'
trailing nullcols
(
  AttendingKey ,
  Attending CHAR(1000) "DECODE(:Attending, CHR(00), ' ', :Attending)"
)
