alter session set current_schema = ud_master;

-- Thesee tables do not intersect:
SELECT visit_id, event_id, medication_component_id, dosage_atom_number FROM dosage_atom_temp
minus
SELECT visit_id, event_id, medication_component_id, dosage_atom_number FROM dosage_atom;

-- There are 7 dosage types - identical in all Networks:
select dosage_type_id, dosage_type_name, listagg(network, ', ') within group(order by network) nw_list 
from dosage_type
group by dosage_type_id, dosage_type_name;

-- Tables DOSAGE and DOSAGE_ATOM intersect by Visit/Event but do not match
select --+ parallel(8)
  d.*
from dosage d
left join dosage_atom da
  on da.network = d.network and da.visit_id = d.visit_id and da.event_id = d.event_id
--  and da.dosage_number = d.dosage_number and da.dosage_type_number = d.dosage_type_number
;

SELECT --+ parallel(16) 
  DISTINCT visit_id, event_id
FROM dosage
MINUS
SELECT DISTINCT visit_id, event_id
FROM dosage_atom
;

-- Only Dosage Type 3 is used in DOSAGE:
select --+ parallel(16)
  dt.dosage_type_name, g.*
from
(
  select * from
  (
    select network, dosage_type_id, count(distinct visit_id) cnt
    from dosage
    group by dosage_type_id, network
  )
  pivot (max(cnt) for network in ('CBN' cbn, 'GP1' gp1, 'GP2' gp2, 'NBN' nbn, 'NBX' nbx, 'QHN' qhn, 'SBN' sbn, 'SMN' snm))
) g
left join 
(
  select distinct dosage_type_id, dosage_type_name
  from dosage_type
) dt on dt.dosage_type_id = g.dosage_type_id;
-- 3	medication route	CBN: 12410813, GP1: 7734747, GP2: 2815729, NBN: 5083928, NBX: 7409921, QHN: 28121080, SBN: 5302701, SMN: 13568115

select --+ parallel(16)
  dt.dosage_type_name, g.*
from
(
  select * from
  (
    select network, dosage_type_id, count(distinct visit_id) cnt
    from dosage_atom
    group by dosage_type_id, network
  )
  pivot (max(cnt) for network in ('CBN' cbn, 'GP1' gp1, 'GP2' gp2, 'NBN' nbn, 'NBX' nbx, 'QHN' qhn, 'SBN' sbn, 'SMN' snm))
) g
left join 
(
  select distinct dosage_type_id, dosage_type_name
  from dosage_type
) dt on dt.dosage_type_id = g.dosage_type_id;

--ROUTE_ID, DOSAGE_TYPE_ID

SELECT --+ first_rows(100)
  orxp.visit_id,
  vt.name visit_type,
  oss.order_event_id,
  oss.start_date_time,
  orxp.order_span_id,
  orxp.order_span_state_id,
  orxp.order_definition_id,
  orxp.proc_order_nbr,
  pr.name proc_name,
  mdc.medf_drug_class_name drug_class,
  pmc.medication_component_name med_comp,
  md.medf_drug_name drug_name,
  p.product_name
from order_def_rx_product orxp
join visit v
  on v.visit_id = orxp.visit_id
join visit_type vt
  on vt.visit_type_id = v.visit_type_id
join order_span_state oss
  on oss.visit_id = orxp.visit_id
 and oss.order_span_id = orxp.order_span_id
 and oss.order_span_state_id = orxp.order_span_state_id
join proc_order_def_med_comp pomc
  on pomc.visit_id = orxp.visit_id
 and pomc.order_span_id = orxp.order_span_id
 and pomc.order_span_state_id = orxp.order_span_state_id
 and pomc.order_definition_id = orxp.order_definition_id
 and pomc.proc_order_nbr = orxp.proc_order_nbr
 and pomc.medication_component_id = orxp.medication_component_id
join procedure_medication_component pmc
  on pmc.proc_id = pomc.proc_id
 and pmc.medication_component_id = pomc.medication_component_id
join proc pr
  on pr.proc_id = pmc.proc_id
left join medf_drug_class mdc
  on mdc.medf_drug_class_id = pmc.medf_drug_class_id
left join product p
  on p.product_id = orxp.product_id
left join medf_drug md
  on md.medf_drug_id = orxp.medf_drug_id
where orxp.visit_id in (15276149, 15090014, 7029818)
order by visit_id, order_event_id;

select order_visit_id, order_event_id, order_span_id, order_time 
from prescription prscr
left join proc p on p.proc_id = prscr.proc_id 
--where prscr.order_visit_id in (15090014, 7029818)
--order by order_visit_id, order_event_id 
;

select * from dosage
where visit_id in (15276149, 15090014, 7029818);

select * from dosage_atom
where visit_id in (15276149, 15090014, 7029818);

select vt.name, count(1) cnt
from precription pr
left join event e on e.event_id = pr.order_event_id;

select * from prescription;
-- {RX_ID:3717645, PATIENT_ID:1934591, VISIT_ID:15276149, ORDER_SPAN_ID:1,ORDER_EVENT_ID:53337846601};

select * from order_span where visit_id = 15276149 and order_span_id = 1;
--RX_ID: 3717645 - matches

select * from visit where visit_id = 15276149;
-- PATIENT_ID: 1934591 - matches

select * from prescription where order_span_id is null and order_time <> date '1840-12-31';

select * from order_span where rx_id = 313484 ;

select 