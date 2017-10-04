-- DSRIP_REPORTS:
select 'INSERT INTO dsrip_reports(report_cd, report_description) VALUES('''||REPLACE(report_cd, '_', '-')||''', '''||report_description||''', '||
nvl2(denominator_inclusion, ''''||denominator_inclusion||'''','NULL')||', '||
nvl2(denominator_exclusion, ''''||denominator_exclusion||'''','NULL')||', '||
nvl2(numerator_1_inclusion, ''''||numerator_1_inclusion||'''','NULL')||', '||
nvl2(numerator_2_inclusion, ''''||numerator_2_inclusion||'''','NULL')||', '||
nvl2(numerator_3_inclusion, ''''||numerator_3_inclusion||'''','NULL')||', '||
nvl2(numerator_4_inclusion, ''''||numerator_4_inclusion||'''','NULL')||', '||
nvl2(numerator_5_inclusion, ''''||numerator_5_inclusion||'''','NULL')||');'
from dsrip_reports
order by report_cd;

-- META_CRITERIA:
select 'INSERT INTO meta_criteria VALUES('||criterion_id||', '''||criterion_cd||''', '''||description||''');' ins
from meta_criteria order by criterion_id;

-- META_CONDITIONS:
select
  'INSERT INTO meta_conditions VALUES('||criterion_id||', '''||network||''', '''||qualifier||''', '''||value||''', '||
  nvl2(value_description, ''''||value_description||'''', 'NULL')||', '''||
  condition_type_cd||''', '''||comparison_operator||''', '''||include_exclude_ind||''');' ins
from meta_conditions
where criterion_id = 33
order by criterion_id, network, qualifier, value;

-- META_LOGIC:
select 'INSERT INTO meta_logic VALUES('''||report_cd||''', '||num||', '||criterion_id||', '''||denom_numerator_ind||''', '''||include_exclude_ind||''');' ins
from meta_logic
where report_cd = 'NQMC-010537'
order by report_cd, DECODE(denom_numerator_ind, 'D', 1, 2), decode(include_exclude_ind, 'I', 1, 2), criterion_id;

