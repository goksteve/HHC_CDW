prompt Copying TR016_PCP_INFO data from &1

call xl.begin_action('Copying DSRIP_TR016_PCP_INFO data from &1');

COPY FROM khaykino/Window#09@&1.DW01 APPEND dsrip_tr016_pcp_info USING -
SELECT * FROM dsrip_tr016_pcp_info;

call xl.end_action();