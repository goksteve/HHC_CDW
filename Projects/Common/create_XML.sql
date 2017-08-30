select
  xmlelement
  (
    "META_CONDITIONS",
    xmlagg
    (
      xmlelement
      (
        "ROW",
        xmlforest
        (
          network, criterion_id, condition_type_cd, qualifier, value, value_description,
          logical_operator, comparison_operator, hint_ind
        )
      )
    )
  )
from 
(
  select *
  from meta_conditions
  where criterion_id = 4
  order by criterion_id, network, condition_type_cd, hint_ind, qualifier, value
); 