CREATE TABLE ref_proc_event_archive_types
(
  archive_type_id  NUMBER(12) CONSTRAINT pk_proc_event_archive_types PRIMARY KEY,
  NAME           VARCHAR2(50 BYTE)
) ORGANIZATION INDEX;

GRANT SELECT ON ref_proc_event_archive_types TO PUBLIC;