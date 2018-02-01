select 'create table bkp_'||table_name||' as select * from '||table_name||';'
from user_tables where table_name like 'META%';

create table bkp_META_CHANGES as select * from META_CHANGES;
create table bkp_META_CONDITIONS as select * from META_CONDITIONS;
create table bkp_META_CONDITIONS_H as select * from META_CONDITIONS_H;
create table bkp_META_CONDITION_TYPES as select * from META_CONDITION_TYPES;
create table bkp_META_CRITERIA as select * from META_CRITERIA;
create table bkp_META_CRITERIA_COMBO as select * from META_CRITERIA_COMBO;
create table bkp_META_CRITERIA_COMBO_H as select * from META_CRITERIA_COMBO_H;
create table bkp_META_CRITERIA_H as select * from META_CRITERIA_H;
create table bkp_META_LOGIC_H as select * from META_LOGIC_H;
create table bkp_dsrip_reports as select * from dsrip_reports;
create table bkp_dsrip_report_results as select * from dsrip_report_results;

select 'insert into '||replace(table_name,'BKP_')||' select * from '||table_name||';'
from user_tables where table_name like 'BKP%';

alter table META_Changes disable all triggers;  
alter table META_CRITERIA disable all triggers;  
alter table META_CONDITIONS disable all triggers;  
alter table META_CRITERIA_COMBO disable all triggers;  
alter table META_LOGIC disable all triggers;  

insert into DSRIP_REPORTS select * from BKP_DSRIP_REPORTS;
insert into DSRIP_REPORT_RESULTS select * from BKP_DSRIP_REPORT_RESULTS;
insert into META_CHANGES select * from BKP_META_CHANGES;
insert into META_CONDITIONS_H select * from BKP_META_CONDITIONS_H;
insert into META_CRITERIA_COMBO_H select * from BKP_META_CRITERIA_COMBO_H;
insert into META_CRITERIA_H select * from BKP_META_CRITERIA_H;
insert into META_LOGIC_H select * from BKP_META_LOGIC_H;
insert into META_CONDITION_TYPES select * from BKP_META_CONDITION_TYPES;

insert into META_CRITERIA select * from BKP_META_CRITERIA;
insert into META_CONDITIONS select * from BKP_META_CONDITIONS;
insert into META_CRITERIA_COMBO select * from BKP_META_CRITERIA_COMBO;

insert into META_LOGIC 
select report_cd, num, criterion_id, denom_numerator_ind, include_exclude_ind
from
(
  select t.*, row_number() over(partition by report_cd, num order by change_id desc) rnum 
  from BKP_META_LOGIC_H t
)
where rnum = 1;

commit;

alter table META_Changes enable all triggers;  
alter table META_CRITERIA enable all triggers;  
alter table META_CONDITIONS enable all triggers;  
alter table META_CRITERIA_COMBO enable all triggers;  
alter table META_LOGIC enable all triggers;
