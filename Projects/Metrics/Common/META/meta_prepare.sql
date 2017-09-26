select distinct l.criterion_id, 'INSERT INTO meta_lists VALUES('||l.criterion_id||', '''||l.criterion_cd||''', '''||l.description||''', '''||c.condition_type_cd||''', '''||decode(instr(c.value, '%'), 0, '=', 'LIKE')||''');' ins 
from meta_criteria l
join meta_conditions c on c.criterion_id = l.criterion_id
where l.criterion_id = 34  
order by l.criterion_id;

select 'INSERT INTO meta_list_items VALUES ('||criterion_id||', '''||network||''', '''||qualifier||''', '''||value||''', NULL, NULL);' ins
from meta_conditions
where criterion_id = 34
order by criterion_id, network, qualifier, value;

select 'INSERT INTO dsrip_reports VALUES('''||REPLACE(measure_cd, '_', '-')||''', '''||description||''');'
from meta_measures
order by measure_cd;

select 'INSERT INTO meta_logic VALUES('''||REPLACE(measure_cd, '_', '-')||''', '||criterion_id||', '''||denom_numerator_ind||''', '''||include_exclude_ind||''');'
from meta_measure_logic
order by measure_cd, criterion_id;