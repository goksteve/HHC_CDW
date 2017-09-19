select
  cr.criterion_id, cr.criterion_cd, cr.description, c.network, c.condition_type_cd, c.qualifier, c.value
from meta_criteria cr
join meta_conditions c on c.criterion_id = cr.criterion_id
where cr.criterion_id 
--in (6, 31, 32, 33, 34*)
in (4, 10, 23)
order by 1, 2, 3 