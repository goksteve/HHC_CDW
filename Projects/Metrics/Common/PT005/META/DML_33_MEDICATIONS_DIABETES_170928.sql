begin
  xl.open_log('META_OK', 'O. Khaykin: modifying Metadata', TRUE);
  
  insert into meta_changes(comments) values ('Few more Diabetes Diagnoses Steve Gorelik got from Warren Harding');
  
  etl.add_data
  (
    i_operation => 'MERGE',
    i_tgt => 'META_CONDITIONS',
    i_src => 'SELECT
       33 AS criterion_id,
       ''ALL'' AS network,
       ''NONE'' AS qualifier,
       t.column_value AS value,
       ''EI'' AS condition_type_cd,
       ''='' AS comparison_operator,
       ''I'' AS include_exclude_ind
      FROM TABLE(tab_v256(''%afrezza%'',''%invokamet%'',''%lispro%'',''%saxenda%'',''%symlin%'')) t',
    i_commit_at => -1
  );
  
  xl.close_log('Successfully completed');
exception
 when others then
  xl.close_log(SQLERRM);
  raise;
end;
/

