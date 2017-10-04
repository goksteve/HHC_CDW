DROP TABLE meta_logic PURGE;
DROP TABLE meta_criteria_combo PURGE;
DROP TABLE meta_conditions PURGE;
DROP TABLE meta_criteria PURGE;
DROP TABLE dsrip_reports PURGE;

@META_CRITERIA.sql
@META_CONDITIONS.sql
@META_CRITERIA_COMBO.sql
@DSRIP_REPORTS.sql
@META_LOGIC.sql

-- Only in PT005:
DROP TABLE dsrip_report_results PURGE;
DROP TABLE meta_logic_h PURGE;
DROP TABLE meta_conditions_h PURGE;
DROP TABLE meta_criteria_combo_h PURGE;
DROP TABLE meta_criteria_h PURGE;
DROP TABLE meta_changes PURGE;
DROP SEQUENCE seq_meta_changes;

@DSRIP_REPORT_RESULTS.sql
@PKG_METADATA_ADMIN.sql
@META_CHANGES.sql
@META_CRITERIA_H.sql
@META_CRITERIA_COMBO_H.sql
@META_CONDITIONS_H.sql
@META_LOGIC_H.sql
