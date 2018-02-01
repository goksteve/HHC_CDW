exec drop_tables('REF_PROC_TYPES');

CREATE TABLE ref_proc_types
(
  proc_type_id
);

select * from
(
  select proc_type_id, network, proc_type_name 
  from proc_type
)
pivot
(
  max(proc_type_name)
  for network in ('CBN','GP1','GP2','NBN','NBX','QHN','SBN','SMN')
);
-- All networks use the same PROC_TYPE values

select * from
(
  select kardex_group_id, network, name 
  from kardex_group
)
pivot
(
  max(name)
  for network in ('CBN','GP1','GP2','NBN','NBX','QHN','SBN','SMN')
);
-- All kind of discrepancies in KARDEX_GROUP values across networks

select * from
(
  select chart_review_group_id, network, name 
  from chart_review_group
)
pivot
(
  max(name)
  for network in ('CBN','GP1','GP2','NBN','NBX','QHN','SBN','SMN')
);
-- All kind of discrepancies in CHART_REVIEW_GROUP values across networks



-1	unknown
7	checkin
12	IV solution
6	physician/service change
5	transport
8	admit
1	discharge
3	LOA
2	transfer
13	critical care
11	medication
9	discharge reversal
0	standard
10	LOA with no release of bed
4	visit interrupt