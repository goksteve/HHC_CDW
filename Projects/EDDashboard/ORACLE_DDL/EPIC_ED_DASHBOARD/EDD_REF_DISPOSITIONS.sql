drop table edd_ref_dispositions purge;

CREATE TABLE edd_ref_dispositions
(
  disposition_type VARCHAR2(10) NOT NULL CONSTRAINT chk_epic_disp_type CHECK(disposition_type IN ('ED','DISCHARGE')),
  id    NUMBER(4) NOT NULL,
  name  VARCHAR2(64) NOT NULL,
  title VARCHAR2(64) NOT NULL,
  abbr  VARCHAR2(30),
  CONSTRAINT pk_edd_ref_dispositions PRIMARY KEY(disposition_type, id)
);
  
GRANT SELECT ON edd_ref_dispositions TO PUBLIC;

CREATE TABLE stg_ed_dispositions as select id, name, title, abbr from edd_ref_dispositions;

CREATE TABLE stg_discharge_dispositions as select id, name, title, abbr from edd_ref_dispositions;
