whenever sqlerror exit 1

begin
  for r in
  (
    select table_name
    from user_tables
    where table_name in ('META_CONDITIONS','META_CONDITION_TYPES','META_CRITERIA')
    order by table_name
  )
  loop
    execute immediate 'drop table '||r.table_name;
  end loop;
end;
/

alter session set nls_length_semantics = 'BYTE';  

@META_CONDITION_TYPES.sql
@META_CRITERIA.sql
@META_CONDITIONS.sql

copy from pt005/pt5123@higgsdv3 append meta_criteria using -
select * from meta_criteria;

copy from pt005/pt5123@higgsdv3 append meta_conditions using -
select * from meta_conditions;

exit
