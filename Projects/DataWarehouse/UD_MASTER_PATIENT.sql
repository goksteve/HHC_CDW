alter session set current_schema=ud_master;

select * 
from khaykino.v_all_columns
where table_name like 'PATIENT'
order by owner, table_name, column_Name;

select * from ud_master.title;
select * from ud_master.emp_title;

SELECT distinct title_id
from patient;

select distinct current_location
from patient;

select * from location
--where location_id = '2A01BB'
;