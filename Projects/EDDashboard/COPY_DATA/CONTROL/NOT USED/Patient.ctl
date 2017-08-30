load data
into table dim_Patients
fields terminated by '|'
trailing nullcols
(
  PatientKey ,
  MRN CHAR(1000) "DECODE(:MRN, CHR(00), ' ', :MRN)",
  PatientName CHAR(1000) "DECODE(:PatientName, CHR(00), ' ', :PatientName)",
  Sex CHAR(1000) "DECODE(:Sex, CHR(00), ' ', :Sex)",
  DOB CHAR(1000) "DECODE(:DOB, CHR(00), ' ', :DOB)"
)
