alter session set current_schema = cdw;

select t.owner, t.table_name, t.num_rows, g.col_list
from
(
  select
    owner, table_name,
    listagg(lower(column_name), ', ') within group(order by column_id desc) col_list,
    count(1) cnt
  from all_tab_columns
  where 1=1
  and owner in (/*'EPIC_CLARITY','UD_MASTER','HHC_CUSTOM',*/'CDW'/*,'PT005'*/)
--  and table_name = 'PERFORMED_BY'
--  and column_name like 'FIN%CLASS%'
  and column_name in ('FACILITY_KEY')
  group by owner, table_name
  --having count(1) > 1
) g
join all_tables t on t.owner = g.owner and t.table_name = g.table_name --and t.num_rows > 10 
order by col_list, table_name;
