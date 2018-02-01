whenever sqlerror exit 1

begin
  for r in
  (
    select table_name
    from user_tables
    where table_name in ('META_CONDITIONS','META_CONDITION_TYPES','META_LOGIC','META_CRITERIA_COMBO','META_CRITERIA','DSRIP_REPORTS')
    order by table_name
  )
  loop
    execute immediate 'drop table '||r.table_name||' cascade constraints purge';
  end loop;
end;
/

alter session set nls_length_semantics = 'BYTE';  

@DSRIP_REPORTS.sql
@META_CRITERIA.sql
@META_CRITERIA_COMBO.sql
@META_LOGIC.sql
@META_CONDITION_TYPES.sql
@META_CONDITIONS.sql

copy from pt005/pt5123@higgsdv3 append dsrip_reports using -
select * from dsrip_reports;

copy from pt005/pt5123@higgsdv3 append meta_criteria using -
select * from meta_criteria;

copy from pt005/pt5123@higgsdv3 append meta_criteria_combo using -
select * from meta_criteria_combo;

copy from pt005/pt5123@higgsdv3 append meta_logic using -
select * from meta_logic;

copy from pt005/pt5123@higgsdv3 append meta_conditions using -
select * from meta_conditions;

exit
