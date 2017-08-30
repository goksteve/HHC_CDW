exec dbm.drop_tables('EDD_FACT_METRIC_VALUES,ERR_EDD_FACT_METRIC_VALUES');

CREATE TABLE edd_fact_metric_values
(
  metric_id         NUMBER(2),
  esi_key           NUMBER(10) CONSTRAINT chk_edd_metval_esi_key CHECK (esi_key BETWEEN 0 AND 5),
  disposition_class VARCHAR2(20) CONSTRAINT chk_edd_metval_disp CHECK(disposition_class IN ('ADMITTED','DISCHARGED','ANY')),
  facility_key      NUMBER(10),
  month_dt          DATE,
  metric_value      NUMBER,
  CONSTRAINT pk_edd_fact_metric_values PRIMARY KEY(metric_id, esi_key, disposition_class, facility_key, month_dt)
) ORGANIZATION INDEX MAPPING TABLE;

GRANT SELECT ON edd_fact_metric_values TO PUBLIC;

ALTER TABLE edd_fact_metric_values ADD CONSTRAINT fk_metval_metuse FOREIGN KEY(metric_id, esi_key, disposition_class) REFERENCES edd_meta_metric_usage ON DELETE CASCADE; 
ALTER TABLE edd_fact_metric_values ADD CONSTRAINT fk_metval_facility FOREIGN KEY(facility_key) REFERENCES edd_dim_facilities ON DELETE CASCADE;

CREATE BITMAP INDEX bidx_edd_metval_facility ON edd_fact_metric_values(facility_key);   
CREATE BITMAP INDEX bidx_edd_metval_month ON edd_fact_metric_values(month_dt);   
 