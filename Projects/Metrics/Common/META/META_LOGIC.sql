CREATE TABLE meta_logic
(
  report_cd             VARCHAR2(20),
  num                   NUMBER(2),
  criterion_id          NUMBER(6) NOT NULL,
  denom_numerator_ind   CHAR(1) NOT NULL
   CONSTRAINT chk_metalogic_denom_num CHECK(denom_numerator_ind IN ('D', 'N')),  
  include_exclude_ind   CHAR(1) NOT NULL
   CONSTRAINT chk_metalogic_inclexcl CHECK(include_exclude_ind IN ('I', 'E')),
  CONSTRAINT pk_meta_logic PRIMARY KEY(report_cd, num),
  CONSTRAINT uk_meta_logic UNIQUE(report_cd, criterion_id),
  CONSTRAINT fk_metalogic_report FOREIGN KEY(report_cd) REFERENCES dsrip_reports,
  CONSTRAINT fk_metalogic_criteria FOREIGN KEY(criterion_id) REFERENCES meta_criteria
) ORGANIZATION INDEX;

GRANT SELECT ON meta_logic TO PUBLIC;
