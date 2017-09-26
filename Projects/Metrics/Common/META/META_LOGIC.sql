CREATE TABLE meta_logic
(
  report_cd             VARCHAR2(20),
  list_id               NUMBER(6),
  denom_numerator_ind   CHAR(1)
   CONSTRAINT chk_metalogic_denom_num CHECK(denom_numerator_ind IN ('D', 'N')),  
  include_exclude_ind   CHAR(1)
   CONSTRAINT chk_metalogic_inclexcl CHECK(include_exclude_ind IN ('I', 'E')),
  CONSTRAINT pk_meta_logic PRIMARY KEY(report_cd, list_id),
  CONSTRAINT fk_metalogic_report FOREIGN KEY(report_cd) REFERENCES dsrip_reports,
  CONSTRAINT fk_metalogic_list FOREIGN KEY(list_id) REFERENCES meta_lists
) ORGANIZATION INDEX;

GRANT SELECT ON meta_logic TO PUBLIC;
