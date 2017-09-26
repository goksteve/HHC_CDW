alter table meta_lists_h disable constraint fk_metalist_h_change;

truncate table meta_changes;

alter table meta_lists_h enable constraint fk_metalist_h_change;

insert into meta_changes(comments) values('Test change');

select * from meta_changes;

select * from meta_lists_h;

select * from meta_list_items_h;
