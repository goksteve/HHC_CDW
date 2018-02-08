DROP TABLE dsrip_tr016_pcp_info PURGE;

CREATE TABLE dsrip_tr016_pcp_info
(
  patient_id          NUMBER(12) CONSTRAINT pk_dsrip_tr016_pcp_info PRIMARY KEY,
  prim_care_provider  VARCHAR2(60),
  pcp_visit_facility  VARCHAR2(100),
  pcp_visit_number    VARCHAR2(40),
  pcp_visit_dt        DATE
) COMPRESS BASIC;

GRANT SELECT ON dsrip_tr016_pcp_info TO PUBLIC;