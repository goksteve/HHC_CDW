alter session enable parallel dml;
alter session enable parallel ddl;

drop table tst_ok_diabetes_supplies purge;

create table tst_ok_diabetes_supplies parallel 16 as
select
  drug_name, drug_description, 
  case
    when drug_description like '%accu%check%' or drug_name like '%accu%check%' then '%accu%check%'
    when drug_description like '%agamatrix%' or drug_name like '%agamatrix%' then '%agamatrix%'
    when drug_description like '%assure%' or drug_name like '%assure%' then '%assure%'
    when drug_description like '%breeze%' or drug_name like '%breeze%' then '%breeze%'
    when drug_description like '%contour%' or drug_name like '%contour%' then '%contour%'
    when drug_description like '%easymax%' or drug_name like '%easymax%' then '%easymax%'
    when drug_description like '%easy%touch%' or drug_name like '%easy%touch%' then '%easy%touch%'
    when drug_description like '%fora%' or drug_name like '%fora%' then '%fora%'
    when drug_description like '%fortis%care%' or drug_name like '%fortis%care%' then '%fortis%care%'
    when drug_description like '%free%style%' or drug_name like '%free%style%' then '%free%style%'
    when drug_description like '%good%sense%' or drug_name like '%good%sense%' then '%good%sense%'
    when drug_description like '%microdot%' or drug_name like '%microdot%' then '%microdot%'
    when drug_description like '%nova%' or drug_name like '%nova%' then '%nova%'
    when drug_description like '%one%touch%' or drug_name like '%one%touch%' then '%one%touch%'
    when drug_description like '%precision%' or drug_name like '%precision%' then '%precision%'
    when drug_description like '%prodigy%' or drug_name like '%prodigy%' then '%prodigy%'
    when drug_description like '%relion%' or drug_name like '%relion%' then '%relion%'
    when drug_description like '%smart%sense%' or drug_name like '%smart%sense%' then '%smart%sense%'
    when drug_description like '%test%strip%' or drug_name like '%test%strip%' then '%test%strip%'
    when drug_description like '%top%care%' or drug_name like '%top%care%' then '%top%care%'
    when drug_description like '%true%balance%' or drug_name like '%true%balance%' then '%true%balance%'
    when drug_description like '%true%metrix%' or drug_name like '%true%metrix%' then '%true%metrix%'
    when drug_description like '%true%test%' or drug_name like '%true%test%' then '%true%test%'
    when drug_description like '%true%track%' or drug_name like '%true%track%' then '%true%track%'
    when drug_description like '%wave%sense%' or drug_name like '%wave%sense%' then '%wave%sense%'
  end mask
from
(
  select distinct drug_name, drug_description
  from fact_prescriptions
  where drug_description like '%accu%check%'
  or drug_description like '%agamatrix%'
  or drug_description like '%assure%'
  or drug_description like '%breeze%'
  or drug_description like '%contour%'
  or drug_description like '%easymax%'
  or drug_description like '%easy%touch%'
  or drug_description like '%fora%'
  or drug_description like '%fortis%care%'
  or drug_description like '%free%style%'
  or drug_description like '%good%sense%'
  or drug_description like '%microdot%'
  or drug_description like '%nova%'
  or drug_description like '%one%touch%'
  or drug_description like '%precision%'
  or drug_description like '%prodigy%'
  or drug_description like '%relion%'
  or drug_description like '%smart%sense%'
  or drug_description like '%test%strip%'
  or drug_description like '%top%care%'
  or drug_description like '%true%balance%'
  or drug_description like '%true%metrix%'
  or drug_description like '%true%test%'
  or drug_description like '%true%track%'
  or drug_description like '%wave%sense%'
  or drug_name like '%accu%check%'
  or drug_name like '%agamatrix%'
  or drug_name like '%assure%'
  or drug_name like '%breeze%'
  or drug_name like '%contour%'
  or drug_name like '%easymax%'
  or drug_name like '%easy%touch%'
  or drug_name like '%fora%'
  or drug_name like '%fortis%care%'
  or drug_name like '%free%style%'
  or drug_name like '%good%sense%'
  or drug_name like '%microdot%'
  or drug_name like '%nova%'
  or drug_name like '%one%touch%'
  or drug_name like '%precision%'
  or drug_name like '%prodigy%'
  or drug_name like '%relion%'
  or drug_name like '%smart%sense%'
  or drug_name like '%test%strip%'
  or drug_name like '%top%care%'
  or drug_name like '%true%balance%'
  or drug_name like '%true%metrix%'
  or drug_name like '%true%test%'
  or drug_name like '%true%track%'
  or drug_name like '%wave%sense%'
);

alter table tst_ok_diabetes_supplies noparallel;

select * from pt005.tst_ok_diabetes_supplies
order by mask, drug_name, drug_description;
