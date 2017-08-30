load data
infile 'data/AdmissionLocation.dat'
into table dim_AdmissionLocations
fields terminated by '|'
trailing nullcols
(
  AdmissionLocationKey ,
  AdmissionLocation CHAR(1000) "DECODE(:AdmissionLocation, CHR(00), ' ', :AdmissionLocation)"
)
