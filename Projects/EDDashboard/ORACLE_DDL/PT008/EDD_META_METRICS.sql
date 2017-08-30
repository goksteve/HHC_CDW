exec dbm.drop_tables('EDD_META_METRICS');

CREATE TABLE edd_meta_metrics
(
  metric_id   NUMBER(10),
  description VARCHAR2(200) NOT NULL,
  CONSTRAINT pk_Edd_metric PRIMARY KEY(metric_id)
) ORGANIZATION INDEX;

GRANT SELECT ON edd_meta_metrics TO PUBLIC;

INSERT INTO edd_meta_metrics VALUES(1, 'Arrival to Triage');
INSERT INTO edd_meta_metrics VALUES(2, 'Arrival to First Provider');
INSERT INTO edd_meta_metrics VALUES(3, 'Arrival to Disposition');
INSERT INTO edd_meta_metrics VALUES(4, 'Arrival to Exit (ED LOS)');
INSERT INTO edd_meta_metrics VALUES(5, 'Triage to First Provider');
INSERT INTO edd_meta_metrics VALUES(6, 'Triage to Disposition');
INSERT INTO edd_meta_metrics VALUES(7, 'Triage to Exit');
INSERT INTO edd_meta_metrics VALUES(8, 'First Provider to Disposition');
INSERT INTO edd_meta_metrics VALUES(9, 'First Provider to Exit');
INSERT INTO edd_meta_metrics VALUES(10, 'Disposition to Exit');
INSERT INTO edd_meta_metrics VALUES(11, 'Dwell');

COMMIT;
