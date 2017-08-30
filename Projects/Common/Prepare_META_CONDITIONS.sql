select
  '  SELECT '''||network||''', '||criterion_id||', '''||condition_type_cd||''', '''||qualifier||''', '''||
  value||''', '''||value_description||''', '''||
  NVL(logical_operator, DECODE(hint_ind, 'N', 'AND', 'OR'))||''', '''||
  NVL(comparison_operator, DECODE(hint_ind, 'N', '<>', '='))||''', '''||
  UPPER(hint_ind)||''' FROM dual UNION ALL' line
from meta_conditions
where criterion_id in (4,6,31,32,33,34)
order by criterion_id, network, condition_type_cd, hint_ind, qualifier, value;