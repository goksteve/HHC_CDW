prompt Copying DSRIP_TR016_A1C_GLUCOSE_RSLT data from &1

call xl.begin_action('Copying DSRIP_TR016_A1C_GLUCOSE_RSLT data from &1');

COPY FROM khaykino/Window#09@&1.DW01 APPEND dsrip_tr016_a1c_glucose_rslt USING -
SELECT * FROM dsrip_tr016_a1c_glucose_rslt;

call xl.end_action();
