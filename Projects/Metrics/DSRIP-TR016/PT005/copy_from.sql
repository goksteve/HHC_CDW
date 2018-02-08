prompt Copying &TABLE data from &1

call xl.begin_action('Copying &TABLE data from &1');

COPY FROM khaykino/Window_12@&1.DW01 APPEND &TABLE USING -
SELECT SUBSTR(db.name, 1, 3) network, t.*
FROM &TABLE t
CROSS JOIN v$database db;

call xl.end_action();
