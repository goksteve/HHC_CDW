select * from v_all_columns
where owner in ('PT005','DCONV')
and table_name = 'MDM_QCPR_PT_02122016' 
order by owner, table_name, column_Name
;