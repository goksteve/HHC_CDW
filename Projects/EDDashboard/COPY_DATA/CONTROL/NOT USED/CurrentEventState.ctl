load data
into table lkp_CurrentEventStates
fields terminated by '|'
trailing nullcols
(
  CurrentEventStateKey ,
  CurrentEventState CHAR(1000) "DECODE(:CurrentEventState, CHR(00), ' ', :CurrentEventState)",
  CurrentEventStateSort 
)
