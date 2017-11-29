select * from v_tr001_detail_cdw;
SELECT * FROM v_tr001_summary_cdw;

select * from v_tr001_detail_epic;
SELECT * FROM v_tr001_summary_epic;

exec set_month('OCT-17');

select count(follow_up_30_days)
from v_tr001_detail_cdw;

select * from v_dsrip_report_tr001_epic;
