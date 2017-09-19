prompt Copying TR001_DIAGNOSES data from &1

exec xl.begin_action('Copying TR001_DIAGNOSES data from &1')

COPY FROM khaykino/Window#07@&1.DW01 APPEND tst_ok_tr001_diagnoses USING -
SELECT * FROM tr001_diagnoses;

exec xl.end_action;