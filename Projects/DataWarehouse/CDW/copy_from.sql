define DB=&1

prompt Copying &TABLE from &DB ... 
COPY FROM khaykino/Window_12@&DB.DW01 APPEND &TABLE USING -
SELECT SUBSTR(db.name, 1, 3) network, t.* FROM &SCHEMA..&TABLE t - 
CROSS JOIN v$database db;
