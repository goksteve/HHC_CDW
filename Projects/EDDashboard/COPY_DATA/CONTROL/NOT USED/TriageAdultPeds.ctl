load data
into table lkp_TriageAdultPeds
fields terminated by '|'
trailing nullcols
(
  TriageAdultPedsKey,
  TriageAdultPedsInd CHAR(1000) "DECODE(:TriageAdultPedsInd, CHR(00), ' ', :TriageAdultPedsInd)"
)
