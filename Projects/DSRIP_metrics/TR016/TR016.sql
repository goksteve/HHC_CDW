select * 
from meta_criteria
where criterion_cd like '%BIPOLAR%'
or criterion_cd like '%SCHIZO%' 
or criterion_cd like '%PSYCH%'
or criterion_cd like '%DIABET%' 
or criterion_cd like '%A1C%' 
or criterion_cd like '%LDL%' 
or criterion_cd like '%GLU%' 
order by 1
;

@tst_prscr_2015_2016.sql;
@TST_DIABETIC_PATIENTS.sql;
@TST_AC1_RESULTS_2016.sql
@DSRIP_TR016_DENOMINATOR.sql

First Name
Last Name
DOB
Age
Is Medicaid patient? – Yes/No (in lieu of CIN) – if Medicaid exists as any of the patients payer, flag yes
MRN
Facility
Speciality
Dates of service for any BH providers involved in care (e.g. Social Worker, Psychologist, Psychiatrist)
Name of BH Provider
Payer
Plan
PCP - General Med
Date of last PCP Visit
