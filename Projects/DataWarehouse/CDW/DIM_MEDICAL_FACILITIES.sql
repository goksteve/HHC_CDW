exec dbm.drop_tables('DIM_MEDICAL_FACILITIES,ERR_MEDICAL_FACILITIES');

CREATE TABLE dim_medical_facilities
(
  facility_key  NUMBER(10) CONSTRAINT dim_med_facilities_pk PRIMARY KEY,
  facility_cd   CHAR(2) CONSTRAINT dim_med_facilities_uk_cd UNIQUE,
  name          VARCHAR2(64) NOT NULL CONSTRAINT dim_med_facilities_uk_nm UNIQUE,
  network_cd    CHAR(3) NOT NULL,
  CONSTRAINT dim_med_facil_fk_network FOREIGN KEY(network_cd) REFERENCES dim_nyc_hc_networks
);

GRANT SELECT ON dim_medical_facilities TO PUBLIC;

exec dbms_errlog.create_error_log('dim_medical_facilities','err_medical_facilities');

drop sequence seq_facility_keys;
create sequence seq_facility_keys; 

--truncate table dim_medical_facilities;
/*
insert into dim_medical_facilities
select seq_facility_keys.nextval, name, network
from
(
  select f.*
  from facility f
  where facility_id <> -1 and name not like 'zz%'
  and (network <> 'QHN' or facility_id not in (4, 5)) 
  order by name, network
) q;
*/
commit;
