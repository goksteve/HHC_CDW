DROP TABLE dsrip_report_results PURGE;

CREATE TABLE dsrip_report_results
(
  report_cd               VARCHAR2(16),
  period_start_dt         DATE CONSTRAINT chk_meta_reptotal_startdt CHECK(period_start_dt = TRUNC(period_start_dt, 'MONTH')),
  network                 VARCHAR(16),
  facility_name           VARCHAR2(64),
  denominator             NUMBER(12),
  numerator_1             NUMBER(12),
  numerator_2             NUMBER(12),
  numerator_3             NUMBER(12),
  numerator_4             NUMBER(12),
  numerator_5             NUMBER(12),
  CONSTRAINT pk_dsrip_rpt_results PRIMARY KEY(report_cd, period_start_dt, network, facility_name),
  CONSTRAINT fk_dsrip_results_reports FOREIGN KEY(report_cd) REFERENCES dsrip_reports
);

COMMENT ON TABLE dsrip_report_results IS 'Denominator and Numerator(s) values of DSRIP Reports and NQMC Measures per Report Period, Network and Facility';

GRANT SELECT ON dsrip_report_results TO PUBLIC;