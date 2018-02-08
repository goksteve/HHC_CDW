begin
  for r in
  (
    select object_type, owner, object_name
    from all_objects
    where owner = sys_context('userenv','current_schema')
    and object_type in ('TABLE','SEQUENCE')
    and object_name in ('DIM_HC_FACILITIES','SEQ_DIM_FACILITY_KEY')
  )
  loop
    execute immediate 'drop '||r.object_type||' '||r.owner||'.'||r.object_name||case when r.object_type = 'TABLE' then ' CASCADE CONSTRAINTS PURGE' end;
  end loop;
end;
/

CREATE TABLE dim_hc_facilities
(
  facility_key    NUMBER(12) CONSTRAINT pk_dim_hc_facilities PRIMARY KEY,
  facility_cd     CHAR(2 BYTE) CONSTRAINT uk_dim_hc_facilities_cd UNIQUE,
  facility_name   VARCHAR2(64 BYTE) NOT NULL CONSTRAINT uk_dim_hc_facilities_nm UNIQUE,
  street_address  VARCHAR2(256 BYTE),
  city            VARCHAR2(32 BYTE),
  state_cd        CHAR(2 BYTE),
  zip_cd          VARCHAR2(10 BYTE),
  source          VARCHAR2(30) NOT NULL,
  network         CHAR(3 BYTE) NOT NULL,
  src_facility_id NUMBER(2) NOT NULL,
  load_dt         DATE DEFAULT SYSDATE NOT NULL,
  loaded_by       VARCHAR2(30 BYTE) DEFAULT SYS_CONTEXT('USERENV','OS_USER'),
  CONSTRAINT uk_dim_hc_facilities_id UNIQUE(network, src_facility_id, source) USING INDEX COMPRESS,
  CONSTRAINT fk_dim_hc_facil_network FOREIGN KEY(network) REFERENCES dim_hc_networks
) COMPRESS BASIC;

GRANT SELECT ON dim_hc_facilities TO PUBLIC;

set define off
INSERT INTO dim_hc_facilities(facility_key, facility_name, network, src_facility_id, source)
 VALUES(15, 'Health and Hospitals Corporation', 'CBN', 1, 'UD_MASTER.FACILITY');

INSERT INTO dim_hc_facilities(facility_key, facility_cd, facility_name, street_address, city, state_cd, zip_cd, network, src_facility_id, source)
 VALUES(1, 'EL', 'Elmhurst Hospital Center', '79-01 Broadway', 'Elmhurst', 'NY', '11373', 'QHN', 1, 'UD_MASTER.FACILITY');

INSERT INTO dim_hc_facilities(facility_key, facility_cd, facility_name, street_address, city, state_cd, zip_cd, network, src_facility_id, source)
 VALUES(2, 'QU', 'Queens Hospital Center', '82-68 164th Street', 'Jamaica', 'NY', '11432', 'QHN', 2, 'UD_MASTER.FACILITY');

INSERT INTO dim_hc_facilities(facility_key, facility_cd, facility_name, street_address, city, state_cd, zip_cd, network, src_facility_id, source)
 VALUES(4, 'JA', 'Jacobi Medical Center', '1400 Pelham Parkway South & Eastchester Road', 'Bronx', 'NY', '10461', 'NBX', 1, 'UD_MASTER.FACILITY');
 
INSERT INTO dim_hc_facilities(facility_key, facility_cd, facility_name, street_address, city, state_cd, zip_cd, network, src_facility_id, source)
 VALUES(5, 'NO', 'North Central Bronx Hospital', '3424 Kossuth Avenue', 'Bronx', 'NY', '10467', 'NBX', 2, 'UD_MASTER.FACILITY');

INSERT INTO dim_hc_facilities(facility_key, facility_cd, facility_name, street_address, city, state_cd, zip_cd, network, src_facility_id, source)
 VALUES(7, 'WO', 'Woodhull Medical and Mental Health Center', '760 Broadway', 'Brooklyn', 'NY', '11206', 'NBN', 1, 'UD_MASTER.FACILITY');

INSERT INTO dim_hc_facilities(facility_key, facility_cd, facility_name, street_address, city, state_cd, zip_cd, network, src_facility_id, source)
 VALUES(8, 'CU', 'Cumberland Diagnostic and Treatment Center', '39 Auburn Place', 'Brooklyn', 'NY', '11205', 'NBN', 2, 'UD_MASTER.FACILITY');

INSERT INTO dim_hc_facilities(facility_key, facility_cd, facility_name, street_address, city, state_cd, zip_cd, network, src_facility_id, source)
 VALUES(10, 'ME', 'Metropolitan Hospital Center', '1901 First Avenue', 'New York', 'NY', '10029', 'GP1', 1, 'UD_MASTER.FACILITY');

INSERT INTO dim_hc_facilities(facility_key, facility_cd, facility_name, street_address, city, state_cd, zip_cd, network, src_facility_id, source)
 VALUES(11, 'LI', 'Lincoln Medical and Mental Health Center', '234 East 149th Street', 'Bronx', 'NY', '10451', 'GP1', 2, 'UD_MASTER.FACILITY');

INSERT INTO dim_hc_facilities(facility_key, facility_cd, facility_name, street_address, city, state_cd, zip_cd, network, src_facility_id, source)
 VALUES(16, 'KC', 'Kings County Hospital Center', '451 Clarkson Ave', 'Brooklyn', 'NY', '11203', 'CBN', 2, 'UD_MASTER.FACILITY');

INSERT INTO dim_hc_facilities(facility_key, facility_cd, facility_name, street_address, city, state_cd, zip_cd, network, src_facility_id, source)
 VALUES(17, 'SE', 'Sea View Hospital Rehabilitation Center and Home', '460 Brielle Avenue', 'Staten Island', 'NY', '10314', 'CBN', 4, 'UD_MASTER.FACILITY');

INSERT INTO dim_hc_facilities(facility_key, facility_cd, facility_name, street_address, city, state_cd, zip_cd, network, src_facility_id, source)
 VALUES(18, 'SU', 'Dr Susan Smith McKinney Nursing and Rehab Center', '594 Albany Ave', 'Brooklyn', 'NY', '11203', 'CBN', 5, 'UD_MASTER.FACILITY');

INSERT INTO dim_hc_facilities(facility_key, facility_cd, facility_name, street_address, city, state_cd, zip_cd, network, src_facility_id, source)
 VALUES(21, 'CI', 'Coney Island Hospital', '2601 Ocean Pkwy', 'Brooklyn', 'NY', '11235', 'SBN', 1, 'UD_MASTER.FACILITY');

INSERT INTO dim_hc_facilities(facility_key, facility_cd, facility_name, street_address, city, state_cd, zip_cd, network, src_facility_id, source)
 VALUES(27, 'BE', 'Bellevue Hospital Center', '462 1st Avenue', 'New York', 'NY', '10016', 'SMN', 1, 'UD_MASTER.FACILITY');

INSERT INTO dim_hc_facilities(facility_key, facility_cd, facility_name, street_address, city, state_cd, zip_cd, network, src_facility_id, source)
 VALUES(32, 'CL', 'Coler Memorial Hospital', '900 Main St', 'Roosevelt Island', 'NY', '10044', 'SMN', 7, 'UD_MASTER.FACILITY');

INSERT INTO dim_hc_facilities(facility_key, facility_cd, facility_name, street_address, city, state_cd, zip_cd, network, src_facility_id, source)
 VALUES(33, 'HC', 'Henry J. Carter Specialty Hospital and Nursing Facility', '1752 Park Ave', 'New York', 'NY', '10035', 'SMN', 8, 'UD_MASTER.FACILITY');

INSERT INTO dim_hc_facilities(facility_key, facility_cd, facility_name, street_address, city, state_cd, zip_cd, network, src_facility_id, source)
 VALUES(34, 'GS', 'Gouverneur Skilled Nursing Facility', '227 Madison St', 'New York', 'NY', '10002', 'SMN', 9, 'UD_MASTER.FACILITY');

INSERT INTO dim_hc_facilities(facility_key, facility_cd, facility_name, street_address, city, state_cd, zip_cd, network, src_facility_id, source)
 VALUES(36, 'HA', 'Harlem Hospital Center', '506 Lenox Ave', 'New York', 'NY', '10037', 'GP2', 1, 'UD_MASTER.FACILITY');

INSERT INTO dim_hc_facilities(facility_key, facility_cd, facility_name, street_address, city, state_cd, zip_cd, network, src_facility_id, source)
 VALUES(37, 'RN', 'Renaissance Diagnostic Treatment Center', '264 W 118th St', 'New York', 'NY', '10026', 'GP2', 2, 'UD_MASTER.FACILITY');

INSERT INTO dim_hc_facilities(facility_key, facility_cd, facility_name, street_address, city, state_cd, zip_cd, network, src_facility_id, source)
 VALUES(43, 'GV', 'Gouverneur Diagnostic & Treatment Center', '227 Madison St', 'New York', 'NY', '10002', 'SMN', 2, 'UD_MASTER.FACILITY');

INSERT INTO dim_hc_facilities(facility_key, facility_cd, facility_name, street_address, city, state_cd, zip_cd, network, src_facility_id, source)
 VALUES(44, 'MO', 'Morrisania Diagnostic & Treatment Center', '1225 Gerard Ave', 'Bronx', 'NY', '10452', 'GP1', 3, 'UD_MASTER.FACILITY');

INSERT INTO dim_hc_facilities(facility_key, facility_cd, facility_name, street_address, city, state_cd, zip_cd, network, src_facility_id, source)
 VALUES(45, 'EY', 'East New York D & TC', '2094 Pitkin Ave', 'Brooklyn', 'NY', '11207', 'CBN', 3, 'UD_MASTER.FACILITY');

INSERT INTO dim_hc_facilities(facility_key, facility_cd, facility_name, street_address, city, state_cd, zip_cd, network, src_facility_id, source)
 VALUES(46, 'BV', 'Segundo Ruiz Belvis Diagnostic & Treatment Center', '545 E 142nd St', 'Bronx', 'NY', '10454', 'GP1', 4, 'UD_MASTER.FACILITY');

COMMIT;
set define on

CREATE SEQUENCE seq_dim_facility_key START WITH 47;
