begin
  for r in
  (
    select d.table_name, d.column_name, d.data_type
    from (select 'META_CONDITIONS' table_name, 'HINT_IND' column_name, 'CHAR(1)' data_type from dual) d
    left join user_tab_columns tc on tc.table_name = d.table_name and tc.column_name = d.column_name
    where tc.table_name is null
  )
  loop
    execute immediate 'alter table '||r.table_name||' add '||r.column_name||' '||r.data_type;
  end loop;
end;
/

alter table meta_conditions drop CONSTRAINT fk_condition_criterion;
alter table meta_conditions add CONSTRAINT fk_condition_criterion FOREIGN KEY(criterion_id) REFERENCES meta_criteria ON DELETE CASCADE;
alter table meta_conditions drop CONSTRAINT chk_condition_network;
alter table meta_conditions add CONSTRAINT chk_condition_network CHECK(network IN ('ALL','CBN','EPIC','GP1','GP2','NBN','NBX','QHN','SBN','SMN'));

alter table meta_measure_logic drop CONSTRAINT fk_logic_measure;
alter table meta_measure_logic add CONSTRAINT fk_logic_measure FOREIGN KEY(measure_cd) REFERENCES meta_measures ON DELETE CASCADE;

