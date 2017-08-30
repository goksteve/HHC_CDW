exec dbm.drop_tables('EDD_DIM_AGE_GROUPS');

CREATE TABLE edd_dim_age_groups
(
  age_group_key  NUMBER(10) CONSTRAINT pk_edd_age_groups PRIMARY KEY,
  age_group_name VARCHAR2(1000) NOT NULL
) ORGANIZATION INDEX;

GRANT SELECT ON edd_dim_age_groups TO PUBLIC;

INSERT INTO edd_dim_age_groups VALUES(-1, 'Unknown');
INSERT INTO edd_dim_age_groups VALUES(1, 'Adults');
INSERT INTO edd_dim_age_groups VALUES(2, 'Children');
INSERT INTO edd_dim_age_groups VALUES(3, 'Senior');

COMMIT;
