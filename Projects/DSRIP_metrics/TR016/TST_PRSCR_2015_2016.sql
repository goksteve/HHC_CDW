drop table tst_prscr_2015_2016 purge;

create table TST_PRSCR_2015_2016
(
  patient_id        number(12),
  order_dt          date,
  drug_name         varchar2(175),
  drug_description  varchar2(512),
  rx_quantity       number(12),
  dosage            varchar2(2048),
  frequency         varchar2(2048),
  rx_dc_dt          date,
  rx_exp_dt         date
)
partition by range(order_dt)
(
  partition p_2015 values less than(date '2016-01-01'),
  partition p_2016 values less than(date '2017-01-01')
) compress basic parallel 2;

COPY FROM pt008/pt8123@higgsdv3 APPEND TST_PRSCR_2015_2016 using -
select -
  patient_id, -
  order_time as order_dt, -
  lower(procedure_name) as drug_name, -
  lower(derived_product_name) as drug_description, -
  rx_quantity, -
  dosage, -
  frequency, -
  rx_dc_time as rx_dc_dt, - 
  rx_exp_date as rx_exp_dt -
FROM prescription_detail -
WHERE network = 'CBN' -
and order_time >= date '2015-01-01' and order_time < date '2017-01-01';

drop table tst_drug_names purge;

create table tst_drug_names
(
  drug_name constraint pk_tst_drug_names primary key,
  drug_type
) organization index
as
with
  nm as
  (
    select --+ materialize
     distinct drug_name from TST_PRSCR_2015_2016
  ) 
select /*+ noparallel */
  distinct
  nm.drug_name, replace(cr.criterion_cd, 'MEDICATIONS:') drug_type
from meta_conditions lkp
join meta_criteria cr on cr.criterion_id = lkp.criterion_id
join nm on nm.drug_name like lkp.value 
where lkp.criterion_id in (33, 34);

drop table tst_drug_descriptions purge;

create table tst_drug_descriptions
(
  drug_description constraint pk_tst_drug_descriptions primary key,
  drug_type 
) organization index as
with
  dscr as
  (
    select --+ materialize
      distinct drug_description
    from tst_prscr_2015_2016
  )
select --+ noparalel
  distinct dscr.drug_description, replace(cr.criterion_cd, 'MEDICATIONS:') drug_type
from meta_conditions lkp
join meta_criteria cr on cr.criterion_id = lkp.criterion_id
join dscr on dscr.drug_description like lkp.value 
where lkp.criterion_id in (33, 34);

create bitmap index bmi_prscr_name_type 
on tst_prscr_2015_2016(nm.drug_type)
from tst_prscr_2015_2016 pr, tst_drug_names nm
where nm.drug_name = pr.drug_name
local;

create bitmap index bmi_prscr_descr_type 
on tst_prscr_2015_2016(dscr.drug_type)
from tst_prscr_2015_2016 pr, tst_drug_descriptions dscr 
where dscr.drug_description = pr.drug_description
local;

select pr.*
from
(
  select --+ index(pr) 
    pr.rowid as row_id
  from tst_prscr_2015_2016 pr
  join tst_drug_names nm
    on nm.drug_name = pr.drug_name
   and nm.drug_type = 'DIABETES'
  union
  select --+ index(pr) 
    pr.rowid row_id
  from tst_prscr_2015_2016 pr
  join tst_drug_descriptions dscr
    on dscr.drug_description = pr.drug_description
   and dscr.drug_type = 'DIABETES'
) q
join tst_prscr_2015_2016 pr on pr.rowid = q.row_id;
 