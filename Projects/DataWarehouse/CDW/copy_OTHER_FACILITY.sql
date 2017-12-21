COPY FROM khaykino/Window_12@&1.DW01 APPEND tst_ok_other_facilities USING -
SELECT SUBSTR(db.name, 1, 3) network, f.* FROM ud_master.other_facility f - 
CROSS JOIN v$database db;
