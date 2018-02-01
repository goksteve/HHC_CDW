select --+ parallel(16) 
  count(1) cnt -- 40,011,440
from performed_by
--where other_facility_id is not null -- 28,172,799
--where facility_id is not null -- 11,805,066
where facility_id is null and other_facility_id is null -- 33,575
--where facility_id is not null and other_facility_id is not null -- 0
;

select --+ parallel(16)
  count(1) cnt, -- 40,001,863
  sum(cnt) sum_cnt, -- 40,011,440
  max(cnt) max_cnt, -- 4
  sum(other_fac_cnt) sum_other_fac_cnt, -- 28,172,799
  max(other_fac_cnt) max_other_fac_cnt, -- 2
  sum(fac_cnt) sum_fac_cnt, -- 11,805,066
  max(fac_cnt) max_fac_cnt, -- 4
  sum(case when other_fac_cnt > 0 and fac_cnt > 0 then 1 end) sum_comb -- 21
from
(
  select
    network, visit_id, event_id,
    count(1) cnt,
    count(distinct facility_id) fac_cnt,
    count(distinct other_facility_id) other_fac_cnt
  from performed_by
  group by network, visit_id, event_id
);

select
  pb.network, mf.facility_id main_facility_id, mf.name main_facility,
  pf.facility_id performed_in_facility_id, pf.name performed_in_facility,
  otf.other_facility_id, otf.name other_facility,
  count(1) cnt
from performed_by pb
join proc_event pe on pe.network = pb.network and pe.visit_id = pb.visit_id and pe.event_id = pb.event_id
join facility mf on mf.network = pe.network and mf.facility_id = pe.facility_id
left join facility pf on pf.network = pb.network and pf.facility_id = pb.facility_id
left join other_facility otf on otf.network = pb.network and otf.other_facility_id = pb.other_facility_id
group by pb.network, mf.facility_id, mf.name, pf.facility_id, pf.name, otf.other_facility_id, otf.name
order by 1, 2, 4, 6; 
