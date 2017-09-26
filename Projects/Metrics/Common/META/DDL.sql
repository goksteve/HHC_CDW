DROP SEQUENCE seq_meta_changes;
DROP TABLE meta_logic PURGE;
DROP TABLE meta_logic_h PURGE;
DROP TABLE meta_list_combo_h PURGE;
DROP TABLE meta_list_items_h PURGE;
DROP TABLE meta_lists PURGE;
DROP TABLE meta_lists_h PURGE;
DROP TABLE meta_changes PURGE;

@META_CHANGES.sql
@META_LISTS.sql
@META_LIST_ITEMS.sql
@META_LIST_COMBO.sql
@META_LOGIC.sql
