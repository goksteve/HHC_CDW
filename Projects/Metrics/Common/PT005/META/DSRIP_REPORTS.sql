CREATE TABLE dsrip_reports
(
  report_cd               VARCHAR2(16) CONSTRAINT pk_dsrip_reports PRIMARY KEY,
  description             VARCHAR2(512) NOT NULL,
  denominator_inclusion   VARCHAR2(1024),
  denominator_exclusion   VARCHAR2(1024),
  numerator_1_inclusion   VARCHAR2(1024),
  numerator_2_inclusion   VARCHAR2(1024),
  numerator_3_inclusion   VARCHAR2(1024),
  numerator_4_inclusion   VARCHAR2(1024),
  numerator_5_inclusion   VARCHAR2(1024)
);

GRANT SELECT ON dsrip_reports TO PUBLIC;
