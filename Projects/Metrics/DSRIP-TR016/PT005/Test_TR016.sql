-- By default, the data for the curent month will be shown:
SELECT * from v_tr016_detail;
SELECT * from v_tr016_summary;

-- You can set a different month to be shown:
exec set_month('OCT-2017')
