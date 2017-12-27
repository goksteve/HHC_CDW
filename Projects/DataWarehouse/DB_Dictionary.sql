alter session set current_schema = ud_master;

select t.owner, t.table_name, t.num_rows, g.col_list
from
(
  select
    owner, table_name,
    listagg(lower(column_name), ', ') within group(order by column_id) col_list,
    count(1) cnt
  from dba_tab_columns
  where 1=1
  and owner in ('UD_MASTER'/*,'HHC_CUSTOM','CDW','PT005'*/)
--  and table_name = 'EMP_FACILITY_ADDL_ADDR'
--  and column_name like 'LOCATION_ID'
  and column_name like 'OTHER_FACILITY_ID'
--  and (column_name like 'ZIP%' or column_name like 'POSTAL%' or column_name like 'MAILING%' or column_name like '%ADDRESS%' or column_name like '%CITY%' or column_name like '%COUNTRY%' or column_name like 'STATE')
  --and column_name  'RX_ID'
  --and column_name in ('EMP_PROVIDER_ID', 'PATIENT_ID')
  group by owner, table_name
  --having count(1) > 1
) g
join all_tables t on t.owner = g.owner and t.table_name = g.table_name --and t.num_rows > 10 
order by num_rows desc, owner, table_name, col_list;
