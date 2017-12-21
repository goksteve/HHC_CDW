DROP TABLE dsrip_tr016_pcp_info PURGE;

CREATE TABLE dsrip_tr016_pcp_info
(
  network             VARCHAR2(3) NOT NULL,
  patient_id          NUMBER(12) NOT NULL,
  prim_care_provider  VARCHAR2(60),
  pcp_visit_facility  VARCHAR2(100),
  pcp_visit_number    VARCHAR2(40),
  pcp_visit_dt        DATE
) COMPRESS BASIC;

GRANT SELECT ON dsrip_tr016_pcp_info TO PUBLIC;