alter table visit_type add constraint pk_visit_type primary key(network, visit_type_id);

alter table visit_subtype add constraint pk_visit_subtype primary key(network, visit_type_id, visit_subtype_id) using index compress;

alter table financial_class add constraint pk_financial_class primary key(network, financial_class_id) using index compress;

alter table visit_status add constraint pk_visit_status primary key(network, visit_status_id);

create unique index uk_dim_provider on dim_provider(case when current_flag = 1 then network end, case when current_flag = 1 then provider_id end);  

create unique index uk_dim_location on dim_location(case when current_flag = 1 then network end, case when current_flag = 1 then location_id end);  

alter table dim_date_time add constraint pk_dim_date_time primary key(datenum);

alter table dim_date_time add constraint uk_dim_date_time unique(days_in_date);

---===================
alter table visit_service_type add constraint uk_visit_service_type unique(network, facility_id, visit_type_id, visit_service_type_id);

alter table discharge_type add constraint pk_discharge_type primary key(network, visit_type_id, discharge_type_id);
