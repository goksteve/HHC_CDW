-- PQI 01: Diabetes Short-Term Complications:
select * from meta_conditions
where criterion_id = 6
and qualifier = 'ICD10'
and value in 
(
  'E10.10',
  'E11.00',
  'E10.11',
  'E11.01',
  'E10.641',
  'E11.641',
  'E10.65',
  'E11.65'
);

-- PQI 03: Diabetes Long-Term Complications:
select * from meta_conditions
where criterion_id = 6
and qualifier = 'ICD10'
and value in 
(
  'E10.21',
  'E11.21',
  'E10.22',
  'E11.22',
  'E10.29',
  'E11.29',
  'E10.311',
  'E11.311',
  'E10.319',
  'E11.319',
  'E10.321',
  'E11.321',
  'E10.329',
  'E11.329',
  'E10.331',
  'E11.331',
  'E10.339',
  'E11.339',
  'E10.341',
  'E11.341'
);

-- PQI 05: Chronic Obstructive Pulmonary Disease (COPD) or Asthma
-- COPD:

select c.criterion_cd, cnd.*
from meta_conditions cnd
left join meta_criteria c on c.criterion_id = cnd.criterion_id
where cnd.value in
(
  'J41.0',
  'J43.9',
  'J41.1',
  'J44.0',
  'J41.8',
  'J44.1',
  'J42.',
  'J44.9',
  'J43.0',
  'J47.0',
  'J43.1',
  'J47.1',
  'J43.2',
  'J47.9',
  'J43.8'
)
and cnd.criterion_id = 19
order by cnd.value, cnd.criterion_id;

-- Asthma:
select c.criterion_cd, cnd.*
from meta_conditions cnd
left join meta_criteria c on c.criterion_id = cnd.criterion_id
where 1=1 
/*and cnd.value in
(
  'J45.21',
  'J45.52',
  'J45.22',
  'J45.901',
  'J45.31',
  'J45.902',
  'J45.32',
  'J45.990',
  'J45.41',
  'J45.991',
  'J45.42',
  'J45.998',
  'J45.51'
)*/
and cnd.criterion_id = 21
order by cnd.value, cnd.criterion_id;

