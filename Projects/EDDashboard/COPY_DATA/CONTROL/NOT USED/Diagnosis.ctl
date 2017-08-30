load data
into table dim_Diagnoses
fields terminated by '|'
trailing nullcols
(
  DiagnosisKey ,
  Diagnosis CHAR(1000) "DECODE(:Diagnosis, CHR(00), ' ', :Diagnosis)"
)
