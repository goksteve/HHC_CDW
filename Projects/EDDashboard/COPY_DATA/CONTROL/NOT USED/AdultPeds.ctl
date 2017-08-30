load data
into table lkp_AdultPeds
fields terminated by '|'
trailing nullcols
(
  AdultPedsKey,
  AdultPedsInd CHAR(1000) "DECODE(:AdultPedsInd, CHR(00), ' ', :AdultPedsInd)"
)
