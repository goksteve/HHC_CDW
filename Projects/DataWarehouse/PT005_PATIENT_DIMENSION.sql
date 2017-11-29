select * from v_all_columns
where owner in ('PT005','DCONV')
and table_name like 'PATIENT_DIMENSION'
order by owner, table_name, column_Name
;