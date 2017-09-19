truncate table ref_providers;

COPY FROM pt005/pt5123@higgsdv3 APPEND ref_providers using -
select -
  provider_id, -
  provider_name, -
  title_id, -
  title_name, -
  title_prefix, -
  title_suffix, -
  physician_flag, -
  emp_id, -
  emp_value, -
  license_id, -
  license_value, -
  social_security_id, -
  social_security_value, -
  sdg_emp_no_id, -
  sdg_emp_no_value, -
  prac_npi_id, -
  prac_npi_value, -
  npi_id, -
  npi_value, -
  license_exp_date_id, -
  license_exp_date_value, -
  physician_service_id, -
  physician_service_name, -
  physician_service_id_1, -
  physician_service_name_1, -
  physician_service_id_2, -
  physician_service_name_2, -
  physician_service_id_3, -
  physician_service_name_3, -
  physician_service_id_4, -
  physician_service_name_4, -
  physician_service_id_5, -
  physician_service_name_5, -
  load_date, -
  source -
FROM provider_dimension -
WHERE network = 'SMN';
