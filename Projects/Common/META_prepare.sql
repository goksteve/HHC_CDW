truncate table meta_conditions;

insert into meta_conditions
select
  measure_id, network, category_id, 'NONE', crt_dtl, crt_desc, 'AND', decode(include_ind, 'Y' , 'LIKE', 'NOT LIKE')
--from goreliks1.meta_search_crt
from dsrip_spec_crt_lookup
where measure_id = 4
and network = 'GP1';

select * from meta_conditions;

commit;

insert into meta_conditions
select
  measure_id, network, category_id, 'NONE', crt_dtl, crt_desc, 'OR', '='
from dsrip_spec_crt_lookup
where measure_id = 4 and network <> 'GP1';

commit;

commit;

insert into meta_conditions
select
  case
    when lower(crt_desc) like '%diabet%' then 6
    when lower(crt_desc) like '%schizo%' then 31
    when lower(crt_desc) like '%bipolar%' then 32
  end criterion_id,
  network, category_id, crt_version, crt_dtl, crt_desc, 'OR', '='
from dsrip_spec_crt_lookup
where measure_id = 6
and category_id = 'DI';

commit;

create table stg_drugs(class varchar2(30), name varchar2(30));

insert into meta_conditions
select 
  case class
    when 'Diabetes' then 33
    when 'Antipsychotic ' then 34
  end,
  'ALL', 'MED', 'NONE', name, class||' medication', 'OR', '='
from stg_drugs;

commit;

select 
  cr.criterion_id, cr.criterion_cd, cr.description, c.network, c.condition_type_cd, c.logical_operator, c.comparison_operator, count(1) cnt
from meta_criteria cr
join meta_conditions c on c.criterion_id = cr.criterion_id
group by cr.criterion_id, cr.criterion_cd, cr.description, c.network, c.condition_type_cd, c.logical_operator, c.comparison_operator 
order by criterion_id, network, condition_type_cd;

select * from meta_conditions
where criterion_id in (6, 31, 32, 33, 34)
order by 1, 2, 3, 4, 5
;