prompt Copying DSRIP_TR001_PAYERS data from &1

CALL xl.begin_action('Copying DSRIP_TR001_PAYERS data from &1');

COPY FROM khaykino/Window_12@&1.DW01 APPEND dsrip_tr001_payers USING -
SELECT * FROM dsrip_tr001_payers;

CALL xl.end_action();