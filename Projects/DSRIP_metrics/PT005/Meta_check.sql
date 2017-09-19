select * from meta_condition_types order by 1;

select * from meta_measures where measure_cd in ('NQMC_010520', 'NQMC_010521', 'NQMC_010524', 'NQMC_010525', 'NQMC_010537') order by 1;

select * from meta_criteria where criterion_id in (4,6,9,31,32,33,34) order by 1;

select criterion_id, network, count(1) cnt 
from meta_conditions
where criterion_id in (4,6,9,31,32,33,34)
group by grouping sets((criterion_id, network),())
order by 1, 2 nulls last;

select condition_type_cd, logical_operator, comparison_operator, hint_ind, count(1) cnt
from meta_conditions
where criterion_id = 4 and network = 'GP1'
group by condition_type_cd, logical_operator, comparison_operator, hint_ind
order by 1, 2, 3;

select * 
from meta_conditions
where criterion_id = 4 and network = 'GP1'
and logical_operator is not null
order by criterion_id, network, condition_type_cd, hint_ind, qualifier, value
;
