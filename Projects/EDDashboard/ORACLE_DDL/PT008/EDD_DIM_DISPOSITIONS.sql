exec dbm.drop_tables('EDD_DIM_DISPOSITIONS');

CREATE TABLE edd_dim_dispositions
(
  disposition_name        VARCHAR2(30) CONSTRAINT pk_edd_dim_dispositions PRIMARY KEY,
  disposition_class       VARCHAR2(30) NOT NULL
   CONSTRAINT chk_disp_class CHECK (disposition_class IN ('ADMITTED', 'DISCHARGED', 'ELOPED', 'EXPIRED', 'TRANSFERRED', 'UNKNOWN'))
) ORGANIZATION INDEX;

GRANT SELECT ON edd_dim_dispositions TO PUBLIC;

INSERT INTO edd_dim_dispositions VALUES ('Admitted', 'ADMITTED');
INSERT INTO edd_dim_dispositions VALUES ('Observation', 'ADMITTED');
INSERT INTO edd_dim_dispositions VALUES ('Correctional Facility', 'DISCHARGED');
INSERT INTO edd_dim_dispositions VALUES ('Discharged', 'DISCHARGED');
INSERT INTO edd_dim_dispositions VALUES ('Left Against Medical Advice', 'DISCHARGED');
INSERT INTO edd_dim_dispositions VALUES ('Transfer to Another Facility', 'DISCHARGED');
INSERT INTO edd_dim_dispositions VALUES ('Eloped', 'ELOPED');
INSERT INTO edd_dim_dispositions VALUES ('Left Without Being Seen', 'ELOPED');
INSERT INTO edd_dim_dispositions VALUES ('Expired', 'EXPIRED');
INSERT INTO edd_dim_dispositions VALUES ('Ambulatory Surgery', 'TRANSFERRED');
INSERT INTO edd_dim_dispositions VALUES ('Extended monitoring', 'TRANSFERRED');
INSERT INTO edd_dim_dispositions VALUES ('Transfer to Psych ED', 'TRANSFERRED');
INSERT INTO edd_dim_dispositions VALUES ('Transferred', 'TRANSFERRED');
INSERT INTO edd_dim_dispositions VALUES ('Unknown', 'UNKNOWN');

COMMIT;

Left Without Being Seen
Left Without Being Seen