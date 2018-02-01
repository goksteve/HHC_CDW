begin
  for r in
  (
    select object_type, owner, object_name
    from all_objects
    where owner = sys_context('userenv','current_schema')
    and object_type in ('TABLE','SEQUENCE')
    and object_name in ('DIM_HC_DEPARTMENTS','SEQ_DIM_HC_DEPARTMENTS_KEY')
  )
  loop
    execute immediate 'drop '||r.object_type||' '||r.owner||'.'||r.object_name||case when r.object_type = 'TABLE' then ' CASCADE CONSTRAINTS PURGE' end;
  end loop;
end;
/

CREATE SEQUENCE seq_dim_hc_departments_key;

CREATE TABLE dim_hc_departments
(
  department_key  NUMBER(10) CONSTRAINT pk_dim_hc_departments PRIMARY KEY,
  network         CHAR(3 BYTE) NOT NULL,
  location_id     VARCHAR2(12 BYTE) NOT NULL,
  facility_key    NUMBER(10) NOT NULL,
  division        VARCHAR2(256 BYTE),
  department      VARCHAR2(256 BYTE),
  zone            VARCHAR2(256 BYTE),
  is_bed          CHAR(1 BYTE),
  specialty_code  CHAR(3 BYTE),
  specialty       VARCHAR2(64 BYTE),
  service         VARCHAR2(64 BYTE),
  service_type    VARCHAR2(3 BYTE),
  source          VARCHAR2(100 BYTE),
  load_dt         DATE DEFAULT SYSDATE NOT NULL,
  loaded_by       VARCHAR2(30 BYTE) DEFAULT SYS_CONTEXT('USERENV', 'OS_USER'),
  CONSTRAINT uk_dim_hc_departments UNIQUE(network, location_id) USING INDEX COMPRESS,
  CONSTRAINT fk_dim_hc_department_facility FOREIGN KEY(facility_key) REFERENCES dim_hc_facilities
) COMPRESS BASIC;

GRANT SELECT ON dim_hc_departments TO PUBLIC;

CREATE OR REPLACE TRIGGER bir_dim_hc_departments
BEFORE INSERT ON dim_hc_departments FOR EACH ROW
BEGIN
  IF :new.department_key IS NULL THEN
    :new.department_key := seq_dim_hc_departments_key.NEXTVAL;
  END IF;
END;
/

INSERT INTO dim_hc_departments
(
  department_key, network, location_id, facility_key, division, department, zone,
  is_bed, specialty_code, specialty, service, service_type, source
)
SELECT
  seq_dim_hc_departments_key.NEXTVAL, network, location_id, facility_key, division, department,
  zone, is_bed, specialty_code, specialty, service, service_type, source
FROM
(
  SELECT * FROM v_dim_hc_departments
  ORDER BY network, location_id
);

COMMIT;
