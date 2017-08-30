load data
into table EDD_STG_PatientVisit_INFO truncate
fields terminated by '|'
trailing nullcols
(
  PatientVisitKey ,
  FacilityKey ,
  VisitNumber CHAR(1000) "DECODE(:VisitNumber, CHR(00), ' ', :VisitNumber)",
  ChiefComplaint CHAR(1000) "DECODE(:ChiefComplaint, CHR(00), ' ', :ChiefComplaint)",
  PatientComplaint CHAR(1000) "DECODE(:PatientComplaint, CHR(00), ' ', :PatientComplaint)",
  MRN CHAR(1000) "DECODE(:MRN, CHR(00), ' ', :MRN)",
  PatientName CHAR(1000) "DECODE(:PatientName, CHR(00), ' ', :PatientName)",
  Sex CHAR(1000) "DECODE(:Sex, CHR(00), ' ', :Sex)",
  DOB CHAR(1000) "DECODE(:DOB, CHR(00), ' ', :DOB)"
)
