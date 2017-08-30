exec dbm.drop_tables('EDD_META_METRIC_USAGE');

CREATE TABLE edd_meta_metric_usage
(
  metric_id, esi_key, disposition_class, 
  CONSTRAINT pk_edd_meta_metric_usage PRIMARY KEY(metric_id, esi_key, disposition_class)
) ORGANIZATION INDEX MAPPING TABLE AS
SELECT
  m.metric_id,
  esi.esiKey AS esi_key,
  dt.COLUMN_VALUE AS disposition_class
FROM edd_meta_metrics m
JOIN edd_dim_esi esi
  ON m.metric_id = 5 AND esi.esiKey > 0 OR esi.esiKey = 0
JOIN TABLE(tab_v256('ADMITTED','DISCHARGED','ANY')) dt
  ON
  (
    m.metric_id IN (1, 5) AND dt.COLUMN_VALUE = 'ANY'
    OR m.metric_id = 2
    OR m.metric_id IN (3, 4, 7, 9) AND dt.COLUMN_VALUE <> 'ANY'
    OR m.metric_id IN (8, 11) AND dt.COLUMN_VALUE = 'ADMITTED'
  );

ALTER TABLE edd_meta_metric_usage ADD CONSTRAINT fk_edd_usage_metric FOREIGN KEY(metric_id) REFERENCES edd_meta_metrics ON DELETE CASCADE;
ALTER TABLE edd_meta_metric_usage ADD CONSTRAINT fk_edd_metuse_esi FOREIGN KEY(esi_key) REFERENCES edd_dim_esi ON DELETE CASCADE;

GRANT SELECT ON edd_meta_metric_usage TO PUBLIC;

exec dbms_stats.gather_table_stats(USER, 'EDD_META_METRIC_USAGE');