select
  cr.criterion_cd, c.qualifier, c.value
from meta_criteria cr
join meta_conditions c on c.criterion_id = cr.criterion_id
where cr.criterion_id in (6, 32, 33)
order by 1 