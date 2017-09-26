prompt Copying TR016_A1C_GLUCOSE_LVL data from &1

exec xl.begin_action('Copying TR016_A1C_GLUCOSE_LVL data from &1')

COPY FROM khaykino/Window#07@&1.DW01 APPEND tst_ok_TR016_A1C_GLUCOSE_LVL USING -
SELECT * FROM TR016_A1C_GLUCOSE_LVL;

exec xl.end_action;