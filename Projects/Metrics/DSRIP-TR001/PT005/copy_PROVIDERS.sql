prompt Copying DSRIP_TR001_PROVIDERS data from &1

CALL xl.begin_action('Copying DSRIP_TR001_PROVIDERS data from &1');

COPY FROM khaykino/Window#09@&1.DW01 APPEND dsrip_tr001_providers USING -
SELECT * FROM dsrip_tr001_providers;

CALL xl.end_action();