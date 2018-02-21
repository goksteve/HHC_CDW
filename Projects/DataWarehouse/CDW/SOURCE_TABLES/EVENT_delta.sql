begin
  xl.open_log('OK-ETL-EVENT-DELTA', 'Loading missing EVENT data', true);
  
  for r in
  (
    select network, max_cid
    from etl_max_cids
    where table_name = 'EVENT'
    order by network
  )
  loop
    xl.begin_action('Adding EVENT data', 'Network: '||r.network||', Starting CID: '||r.max_cid);

    etl.add_data
    (
      p_operation => 'MERGE',
      p_tgt => 'EVENT',
      p_src => 'SELECT /*+ index(t) */ * FROM event_'||r.network||' t WHERE network = '''||r.network||''' AND cid > '''||r.max_cid||'''',
      p_commit_at => -1,
      p_changes_only => 'Y'
    );
    
    xl.end_action;
  end loop;
  
  xl.close_log('Successfully completed');
exception
 when others then
  rollback;
  xl.close_log(sqlerrm, true);
  raise;
end;
/
