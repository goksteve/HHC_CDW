col dfo_number                      format 999
col tq_id                           format 999
col server_type                     format a11
col num_rows                        format 999,999,999
col num_rows_pct                    format 999                heading 'Num rows, %'
col bytes                           format 999,999,999,999
col process                         format a11
col instance                        format 999

break on dfo_number skip 1

select dfo_number
     , tq_id
     , server_type
     , process
     , num_rows
     , num_rows * 100 / sum(num_rows) over (partition by dfo_number, tq_id, server_type) num_rows_pct
     , bytes
     , instance 
  from v$pq_tqstat
 order by dfo_number desc, tq_id desc, server_type, process;
