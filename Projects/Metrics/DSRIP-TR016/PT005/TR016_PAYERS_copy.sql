prompt Copying TR016_PAYERS data from &1

call xl.begin_action('Copying DSRIP_TR016_PAYERS data from &1');

COPY FROM khaykino/Window#07@&1.DW01 APPEND dsrip_tr016_payers USING -
SELECT * FROM dsrip_tr016_payers;

call xl.end_action();