column xms_child_number             head Ch|ld format 99
column xms_id                       heading Op|ID format 999
column xms_id2                      heading Op|ID format a6
column xms_pred                     heading Pr|ed format a2
column xms_optimizer                heading Optimizer|Mode format a10
column xms_plan_step                heading Operation for a60
column xms_object_name              heading Object|Name for a30
column xms_opt_cost                 heading Optimizer|Cost for 999999999
column xms_opt_card                 heading "Estimated|output rows" for 999999999
column xms_opt_bytes                heading "Estimated|output bytes" for 999999999
column xms_predicate_info           heading "Predicate Information (identified by operation id):" format a100 word_wrap
column xms_cpu_cost                 heading CPU|Cost for 9999999
column xms_io_cost                  heading IO|Cost for 9999999
                                    
column xms_last_output_rows         heading "Real #rows|returned" for 999999999
column xms_last_starts              heading "Op. ite-|rations" for 999999999
column xms_last_cr_buffer_gets      heading "Consistent|gets" for 999999999
column xms_last_cu_buffer_gets      heading "Current|gets" for 999999999
column xms_last_disk_reads          heading "Physical|reads" for 999999999
column xms_last_disk_writes         heading "Physical|writes" for 999999999
column xms_last_elapsed_time_ms     heading "ms spent|in op." for 99999999.99

column xms_hash_value               new_value xms_hash_value
column xms_sql_address              new_value xms_sql_address

column xms_seconds_ago              for a75
column xms_sql_hash_value_text      for a20
column xms_cursor_address_text      for a35

select  
    case when p.access_predicates is not null then 'A' else ' ' end ||
    case when p.filter_predicates is not null then 'F' else ' ' end xms_pred,
    p.id        xms_id,
    lpad(' ',level*1,' ')|| p.operation || ' ' || p.options xms_plan_step, 
    p.object_name                   xms_object_name,
    p.cardinality                   xms_opt_card,    
    p.cost                          xms_opt_cost,
    p.io_cost                       xms_io_cost
from plan_table p
start with p.plan_id = (select max(plan_id) from plan_table) and id = 0
connect by prior id = parent_id and prior plan_id = plan_id
order by
    p.id asc
/

select * from (
    select
        lpad(id, 5, ' ')                        xms_id2,
        ' - access('|| substr(access_predicates, 1, 3989) || ')' xms_predicate_info
    from
        plan_table p
    where p.plan_id = (select max(plan_id) from plan_table)
      and access_predicates is not null
    union all
    select
        lpad(id, 5, ' ')                        xms_id2,
        ' - filter('|| substr(filter_predicates, 1, 3989) || ')' xms_predicate_info
    from
        plan_table p
    where p.plan_id = (select max(plan_id) from plan_table)
      and filter_predicates is not null
)
order by    
    to_number(xms_id2) asc,
    xms_predicate_info asc
/

prompt

set feedback 5

column xms_hash_value   clear
column xms_sql_address  clear
undefine xms_hash_value
undefine xms_sql_address
