select * 
from meta_criteria
where criterion_cd like '%BIPOLAR%'
or criterion_cd like '%SCHIZO%' 
or criterion_cd like '%PSYCH%'
or criterion_cd like '%DIABET%' 
or criterion_cd like '%A1C%' 
or criterion_cd like '%LDL%' 
or criterion_cd like '%GLU%' 
order by 1
;