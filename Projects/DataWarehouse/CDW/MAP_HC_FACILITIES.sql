exec dbm.drop_tables('MAP_HC_FACILITIES');

CREATE TABLE map_hc_facilities
(
  source              VARCHAR2(30) NOT NULL,
  network             CHAR(3 BYTE) NOT NULL,
  src_facility_id     NUMBER(2) NOT NULL,
  facility_key        NUMBER(12) NOT NULL,
  load_dt             DATE DEFAULT SYSDATE NOT NULL,
  loaded_by           VARCHAR2(30 BYTE) DEFAULT SYS_CONTEXT('USERENV','OS_USER'),
  CONSTRAINT Pk_map_hc_facilities PRIMARY KEY(source, network, src_facility_id),
  CONSTRAINT fk_map_hc_facility_dim FOREIGN KEY(facility_key) REFERENCES dim_hc_facilities
) COMPRESS BASIC;

GRANT SELECT ON map_hc_facilities TO PUBLIC;

INSERT INTO map_hc_facilities(source, network, src_facility_id, facility_key) VALUES('UD_MASTER.FACILITY', 'CBN', 1, 15);
INSERT INTO map_hc_facilities(source, network, src_facility_id, facility_key) VALUES('UD_MASTER.FACILITY', 'CBN', 2, 16);
INSERT INTO map_hc_facilities(source, network, src_facility_id, facility_key) VALUES('UD_MASTER.FACILITY', 'CBN', 3, 45);
INSERT INTO map_hc_facilities(source, network, src_facility_id, facility_key) VALUES('UD_MASTER.FACILITY', 'CBN', 4, 17);
INSERT INTO map_hc_facilities(source, network, src_facility_id, facility_key) VALUES('UD_MASTER.FACILITY', 'CBN', 5, 18);
INSERT INTO map_hc_facilities(source, network, src_facility_id, facility_key) VALUES('UD_MASTER.FACILITY', 'GP1', 1, 10);
INSERT INTO map_hc_facilities(source, network, src_facility_id, facility_key) VALUES('UD_MASTER.FACILITY', 'GP1', 2, 11);
INSERT INTO map_hc_facilities(source, network, src_facility_id, facility_key) VALUES('UD_MASTER.FACILITY', 'GP1', 3, 44);
INSERT INTO map_hc_facilities(source, network, src_facility_id, facility_key) VALUES('UD_MASTER.FACILITY', 'GP1', 4, 46);
INSERT INTO map_hc_facilities(source, network, src_facility_id, facility_key) VALUES('UD_MASTER.FACILITY', 'GP2', 1, 36);
INSERT INTO map_hc_facilities(source, network, src_facility_id, facility_key) VALUES('UD_MASTER.FACILITY', 'GP2', 2, 37);
INSERT INTO map_hc_facilities(source, network, src_facility_id, facility_key) VALUES('UD_MASTER.FACILITY', 'NBN', 1, 7);
INSERT INTO map_hc_facilities(source, network, src_facility_id, facility_key) VALUES('UD_MASTER.FACILITY', 'NBN', 2, 8);
INSERT INTO map_hc_facilities(source, network, src_facility_id, facility_key) VALUES('UD_MASTER.FACILITY', 'NBX', 1, 4);
INSERT INTO map_hc_facilities(source, network, src_facility_id, facility_key) VALUES('UD_MASTER.FACILITY', 'NBX', 2, 5);
INSERT INTO map_hc_facilities(source, network, src_facility_id, facility_key) VALUES('UD_MASTER.FACILITY', 'QHN', 1, 1);
INSERT INTO map_hc_facilities(source, network, src_facility_id, facility_key) VALUES('UD_MASTER.FACILITY', 'QHN', 2, 2);
INSERT INTO map_hc_facilities(source, network, src_facility_id, facility_key) VALUES('UD_MASTER.FACILITY', 'SBN', 1, 21);
INSERT INTO map_hc_facilities(source, network, src_facility_id, facility_key) VALUES('UD_MASTER.FACILITY', 'SMN', 1, 27);
INSERT INTO map_hc_facilities(source, network, src_facility_id, facility_key) VALUES('UD_MASTER.FACILITY', 'SMN', 2, 43);
INSERT INTO map_hc_facilities(source, network, src_facility_id, facility_key) VALUES('UD_MASTER.FACILITY', 'SMN', 7, 32);
INSERT INTO map_hc_facilities(source, network, src_facility_id, facility_key) VALUES('UD_MASTER.FACILITY', 'SMN', 8, 33);
INSERT INTO map_hc_facilities(source, network, src_facility_id, facility_key) VALUES('UD_MASTER.FACILITY', 'SMN', 9, 34);

COMMIT;
