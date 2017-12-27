alter session set current_schema = ud_master;

with
  asdu as
  (
    select
      d.asdu_dictionary_id, d.name dictionary_name, 
      de.name dictionary_element, de.active elem_active,
      df.asdu_field_id, df.name field_name, df.active field_active 
    from asdu_dictionary d
    join asdu_dictionary_element de on de.asdu_dictionary_id = d.asdu_dictionary_id
    join asdu_dictionary_field df on df.asdu_element_id = de.asdu_element_id
  )
--select * from asdu order by asdu_dictionary_id, dictionary_element, field_name;
select
  f.name facility_name,
  ms.name service_name,
  icd.if_code_link_id, icd.name if_name,
  icf.name, icf.if_code_field_parameter if_field_id, icf.name if_field_name, 
  msc.if_code_item_nbr num
from facility f
join medical_specialty ms on ms.facility_id = f.facility_id
join medical_specialty_if_code msc on msc.physician_service_id = ms.physician_service_id
join if_code_field icf on icf.if_code_link_id = msc.if_code_link_id and icf.if_code_field_parameter = msc.if_code_field_parameter
join if_code_definition icd on icd.if_code_link_id = icf.if_code_link_id
left join asdu on asdu.asdu_field_id = icf.asdu_field_id;
