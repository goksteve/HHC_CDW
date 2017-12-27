select
  mc.criterion_id, mc.network, mc.value, rf.name
from meta_conditions mc 
join ud_master.result_field rf on rf.data_element_id = mc.value 
where mc.criterion_id IN (25, 26)
--having count(1) > 1
; 

delete from meta_conditions where network  <> 'ALL'
and network <> (select substr(name, 1, 3) from v$database);

commit;

SELECT /*+ PARALLEL(16) */
  network,
   visit_id,
   event_id,
   provider_id,
   provider_name,
   order_span_id,
   order_span_state_id,
   proc_id,
   val_desc
FROM
(
  SELECT
    SUBSTR(ora_database_name, 1, 3) AS network,
    res.visit_id,
    res.event_id,
    res.VALUE AS provider_id,
    emp.name AS provider_name,
    pe.order_span_id,
    pe.order_span_state_id,
    pe.proc_id,
    val_desc
  FROM ud_master.proc_event pe
  JOIN
  (
    SELECT res.visit_id,
      res.event_id,
      res.data_element_id,
      res.value,
      DECODE(mc.criterion_id, 25, 'First MD', 'Last MD') AS val_desc,
      ROW_NUMBER() OVER(PARTITION BY res.visit_id, mc.criterion_id ORDER BY res.event_id) AS rn
    FROM  ud_master.result res
    JOIN meta_conditions mc
      ON res.data_element_id = mc.value
     AND mc.network = SUBSTR(ora_database_name, 1, 3)
     AND mc.criterion_id IN (25, 26)
     AND mc.condition_type_cd = 'EI'
     AND mc.include_exclude_ind = 'I'
  ) res
  ON res.visit_id = pe.visit_id AND res.event_id = pe.event_id AND REGEXP_LIKE(res.value, '^[[:digit:]]+$') AND rn = 1
  LEFT JOIN ud_master.emp_provider emp ON emp.emp_provider_id = TO_NUMBER(res.value) 
)
WHERE TRIM(provider_id) IS NOT NULL;