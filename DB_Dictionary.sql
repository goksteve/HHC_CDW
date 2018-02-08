alter session set current_schema = cdw;

select t.owner, t.table_name, t.num_rows, g.col_list
from
(
  select
    owner, table_name,
    listagg(lower(column_name), ', ') within group(order by column_id) col_list,
    count(1) cnt
  from all_tab_columns
  where 1=1
  and owner in (/*'EPIC_CLARITY','UD_MASTER','HHC_CUSTOM',*/'CDW'/*,'PT005'*/)
  and table_name = 'NEW_PROC_ORDER_DEF'
--  and column_name like 'FIN%CLASS%'
--  and column_name in ('FACILITY_KEY')
  group by owner, table_name
  --having count(1) > 1
) g
join all_tables t on t.owner = g.owner and t.table_name = g.table_name --and t.num_rows > 10 
order by col_list, table_name;

select index_name, status from user_indexes where status not in ('VALID', 'N/A')
union
select index_name, status from user_ind_partitions where status not in ('USABLE', 'N/A')
union
select index_name, status from user_ind_subpartitions where status <> 'USABLE';

SELECT * FROM user_indexes where index_name = 'KP_ADMIT_EVENT';

select * from
(
  select network, archive_type_id, name
  from proc_event_archive_type
)
pivot
(
  max(name)
  for network in ('CBN','GP1','GP2','NBN','NBX','QHN','SBN','SMN')
);

select archive_type_id, count(1) cnt, count(distinct name) name_cnt
from proc_event_archive_type
group by archive_type_id
having count(1) <> 8 or count(distinct name) <> 1;
-- Only 

alter session enable parallel dml;
alter session force parallel dml;
alter session enable parallel ddl;

exec dwm.refresh_data('REF_PROC_EVENT_ARCHIVE_TYPES');