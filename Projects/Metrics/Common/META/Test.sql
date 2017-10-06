select cr.criterion_cd, count(1) cnt
from meta_criteria cr
join meta_conditions c on c.criterion_id = cr.criterion_id
group by cr.criterion_cd
order by 1;

DIAGNOSES:DIABETES	146
MEDICATIONS:ANTIPSYCHOTIC	55
MEDICATIONS:DIABETES	94
RESULTS:DIABETES A1C	116
RESULTS:GLUCOSE_LVL	97