with cols as
(
  SELECT
    table_name, column_name, column_id,
    CASE
      WHEN data_type IN ('CHAR', 'VARCHAR2', 'RAW', 'NCHAR', 'NVARCHAR2') THEN data_type||'('||char_length||')'
      WHEN data_type = 'NUMBER' AND data_precision IS NULL AND data_scale IS NULL THEN 'NUMBER'
      WHEN data_type = 'NUMBER' AND data_precision IS NULL AND data_scale = 0 THEN 'INTEGER'
      WHEN data_type = 'NUMBER' AND data_scale = 0 THEN 'NUMBER('||data_precision||')'
      WHEN data_type = 'NUMBER' THEN 'NUMBER('||data_precision||','||data_scale||')'
      ELSE data_type
    END data_type,
    nullable
  FROM all_tab_columns
  WHERE owner = 'EPIC_CLARITY'
)
select * from cols
--where table_name = 'PATIENT'
--where column_name like '%LOC_ID%'
where column_name like '%DEP%'
order by table_name, column_name; 