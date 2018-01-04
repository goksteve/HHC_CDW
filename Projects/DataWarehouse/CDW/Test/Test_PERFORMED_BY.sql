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