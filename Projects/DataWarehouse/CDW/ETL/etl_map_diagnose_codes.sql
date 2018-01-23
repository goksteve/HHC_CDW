ALTER SESSION FORCE PARALLEL DML;

truncate table map_diagnose_codes;

INSERT --+ parallel(16)
INTO map_diagnose_codes
SELECT * FROM v_etl_map_diagnose_codes;

COMMIT;
