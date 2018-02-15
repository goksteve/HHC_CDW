select *
from
(
  select
    q.*,
    str_to_number(REGEXP_SUBSTR(q.value, '^[0-9\.]*')) num_value
  from
  (
    select --+ ordered noparallel use_nl(r) index_ss(r)
      r.network, r.visit_id, mc.criterion_id, r.value, row_number() over(partition by r.network, r.visit_id order by event_id desc) rnum 
    from meta_conditions mc 
    join result r on r.network = mc.network and r.data_element_id = mc.value and r.visit_id = 10401213
    where mc.criterion_id in (4, 10, 23) -- A1C, LDL, Glucose
  ) q
  where q.rnum = 1
)
pivot
(
  max(value) as final_str_value,
  max(num_value) as final_num_value 
  for criterion_id in (4 as a1c, 10 as ldl, 23 as glucose) 
);

select --+ noparallel ordered use_nl(rf) index(rf)
  m.criterion_cd, rf.name, r.* 
from meta_conditions mc
join meta_criteria m on m.criterion_id = mc.criterion_id 
join result r on r.network = mc.network and r.data_element_id = mc.value and r.visit_id = 10401213
join result_field rf on rf.network = r.network and rf.data_element_id = r.data_element_id 
where mc.criterion_id in (4, 10, 23) -- A1C, LDL, Glucose
order by event_id
;

select --+ ordered noparallel first_rows(10) use_nl(r) 
  r.network, r.visit_id, mc.criterion_id 
--  max(str_to_number(r.value)) keep (dense_rank first order by event_id desc) result_value
from meta_conditions mc 
join result_cbn r on r.network = mc.network and r.data_element_id = mc.value
where mc.criterion_id in (4, 10, 23) -- A1C, LDL, Glucose 
