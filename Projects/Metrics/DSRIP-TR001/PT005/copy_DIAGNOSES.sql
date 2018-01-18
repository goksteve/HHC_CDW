prompt Copying DSRIP_TR001_DIAGNOSES data from &1

CALL xl.begin_action('Copying DSRIP_TR001_DIAGNOSES data from &1');

COPY FROM khaykino/Window_12@&1.DW01 APPEND dsrip_tr001_diagnoses USING -
SELECT * FROM dsrip_tr001_diagnoses;

CALL xl.end_action();