select * from pt005.facility_dimension order by network, facility_id;

drop table stg_ok_locations;

create table stg_ok_locations 
(
  tgt_network       char(3),
  FACILITY_KEY      number(10),
  FACILITY_CD       char(2),
  VENUE_NUM         number(3),
  DEPARTMENT_ID     varchar2(30),
  FACILITY_NAME     varchar2(128),
  DEPARTMRNT_NAME   varchar2(128),
  SRC               varchar2(30),
  STREET_ADDRESS    varchar2(64),
  CITY              varchar2(30),
  STATE             char(2),
  POSTAL_CODE       number(5),
  SRC_NETWORK       varchar2(5),
  FACILITY_ID       number(10)
);

truncate table stg_ok_locations;

