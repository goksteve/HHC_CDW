drop table ref_hedis_value_sets purge;

create table ref_hedis_value_sets
(
  Value_Set_Name        VARCHAR2(64) NOT NULL,
  Value_Set_OID         VARCHAR2(64) NOT NULL,
  Value_Set_Version     VARCHAR2(32) NOT NULL,
  Code                  VARCHAR2(16) NOT NULL,
  Definition            VARCHAR2(512),
  Code_System           VARCHAR2(16) NOT NULL,
  Code_System_OID       VARCHAR2(64) NOT NULL,
  Code_System_Version   VARCHAR2(32) NOT NULL
) compress basic;

grant select on ref_hedis_value_sets to public; 

select distinct value_set_oid, value_set_name, value_set_version
from ref_hedis_value_sets
where value_set_name = 'Mental Illness';

select code_system_oid, code_system, code_system_version, count(1) cnt
from ref_hedis_value_sets
where value_set_name = 'Mental Illness'
group by code_system_oid, code_system, code_system_version
order by 1, 2, 3;

select value_set_name, code_system, code, definition
from ref_hedis_value_sets
where value_set_name = 'Mental Illness'
order by 1, 2, 3;
