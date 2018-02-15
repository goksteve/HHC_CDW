begin
  xl.open_log('OK-ETL-EVENT-DELTA', 'Loading missing event data', true);
/*  
  for r in
  (
    select network, max_cid
    from tst_ok_max_cids
    where table_name = 'EVENT'
    order by network
  )
  loop
    xl.begin_action('Adding EVENT data', r.network||': '||r.max_cid);

    etl.add_data
    (
      p_operation => 'MERGE',
      p_tgt => 'EVENT',*/
--      p_src => 'SELECT /*+ index(t) */ * FROM event_'||r.network||' t WHERE network = '''||r.network||''' AND cid > '''||r.max_cid||'''',
/*      p_commit_at => -1,
      p_changes_only => 'Y'
    );
    
    xl.end_action;
  end loop;
*/  
  etl.add_data
  (
    p_operation => 'MERGE',
    p_tgt => 'TST_OK_MAX_CIDS',
    p_src => 'SELECT ''EVENT'' table_name, network, max(cid) max_cid FROM event GROUP BY network',
    p_commit_at => -1,
    p_changes_only => 'Y'
  );
  
  xl.close_log('Successfully completed');
exception
 when others then
  rollback;
  xl.close_log(sqlerrm, true);
  raise;
end;
/
