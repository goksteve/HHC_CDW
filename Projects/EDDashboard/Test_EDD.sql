alter session set current_schema=pt008;

-- New Data:
-- Q1 - Volumes:
select num, metric_name, bhc, cih, hlm, jmc, kch, lhc, mhc, ncb, whh, elm, qhc, "All"
from
(
  select
    m.num,
    m.metric_name,
    DECODE(GROUPING(f.FacilityCode), 1, 'All', f.FacilityCode)  FacilityCode, 
    SUM
    (
      case
        when m.metric_name = '# of Patients Arrived to ED'
          or m.metric_name = '# of Patients Left Before Triage' and bitand(v.progress_ind, 2) = 0 and v.Disposition_name in ('Unknown', 'Left Without Being Seen')
          or m.metric_name = '# of Patients Triaged' and bitand(v.progress_ind, 2) = 2
          or m.metric_name = '# of Patients Claimed by a Provider' and bitand(v.progress_ind, 6) = 6
          or m.metric_name = '# of Patients with a Disposition of LWBS' and v.disposition_name = 'Left Without Being Seen'
          or m.metric_name = '# of Patients Left After Triage' and bitand(v.progress_ind, 2) = 2 and (bitand(v.progress_ind, 8) = 0 or d.disposition_name = 'Left Without Being Seen')
          or m.metric_name = '# of Patients Left Without Being Seen' and (bitand(v.progress_ind, 8) = 0 or d.disposition_name = 'Left Without Being Seen')
          or m.metric_name = '# of Patients with a Disposition not LWBS' and bitand(v.progress_ind, 8) = 8
            and d.disposition_name not in ('Left Without Being Seen', 'Unknown')
          or m.metric_name = '# of Patients Left Against Medical Advice'
            and v.disposition_name = 'Left Against Medical Advice'
          or m.metric_name = '# of Patients Walked Out During Evaluation / Eloped'
            and d.disposition_name = 'Eloped'
          or m.metric_name = '# of Patients Seen '||CHR(38)||' Discharged' and d.disposition_class = 'DISCHARGED'
          or m.metric_name = '# of Patients Transferred to Another Hospital' and d.disposition_class = 'TRANSFERRED'
          or m.metric_name = '# of ED Patients Who Were Admitted' and d.disposition_class = 'ADMITTED'
        then num_of_visits
        else 0
      end
    ) metric_value
  from edd_fact_stats v
  join edd_dim_facilities f on f.FacilityKey = v.Facility_Key
  join edd_dim_dispositions d on d.disposition_name = v.disposition_name
  cross join
  (
    select 1 num, '# of Patients Arrived to ED' metric_name from dual union all
    select 2, '# of Patients Left Before Triage' from dual union all
    select 3, '# of Patients Triaged' from dual union all
    select 4, '# of Patients Claimed by a Provider' from dual union all
    select 5, '# of Patients with a Disposition of LWBS' from dual union all
    select 6, '# of Patients Left After Triage' from dual union all
    select 7, '# of Patients Left Without Being Seen' from dual union all
    select 8, '# of Patients with a Disposition not LWBS' from dual union all
    select 9, '# of Patients Left Against Medical Advice' from dual union all
    select 10, '# of Patients Walked Out During Evaluation / Eloped' from dual union all
    select 11, '# of Patients Seen '||CHR(38)||' Discharged' from dual union all
    select 12, '# of Patients Transferred to Another Hospital' from dual union all
    select 13, '# of ED Patients Who Were Admitted' from dual
  ) m
  where v.visit_start_dt >= '01-JAN-17' and v.visit_start_dt < '01-FEB-17'
--  and f.facilityKey not in (6, 11) 
  group by grouping sets((m.num, m.metric_name, f.facilityCode), (m.num, m.metric_name)) 
)
pivot
(
  max(metric_value)
  for FacilityCode in 
  (
    'BHC' as bhc,
    'CIH' as cih,
    'ELM' as elm,
    'HLM' as hlm,
    'JMC' as jmc,
    'KCHC' as kch,
    'LHC' as lhc,
    'MHC' as mhc,
    'NCB' as ncb,
    'QHC' as qhc,
    'WHH' as whh,
    'All' as "All"
  )
)
order by num;

-- Q2:
-- 1) Throughput Metrics - in Median Times (hh:mm)
-- 2) Triage to Provider Time / Median Wait Time - Triage to First Provider
select metric_id, metric_name, disposition_class, esi_key, bhc, cih, hlm, jmc, kch, lhc, mhc, ncb, whh, elm, qhc, "All"
from
(
  select
    m.metric_id, m.description metric_name, v.disposition_class, v.esi_key, 
    f.FacilityCode facility_code,
    to_char(trunc(nvl(v.metric_value,0)/60), '99')||':'||ltrim(to_char(mod(nvl(v.metric_value,0),60),'09')) metric_value
  from edd_fact_metric_values v
  join edd_meta_metrics m on m.metric_id = v.metric_id
  left join edd_dim_facilities f on f.FacilityKey = v.facility_key
  where v.month_dt = date '2017-01-01'
)
pivot
(
  max(metric_value)
  for Facility_Code in 
  (
    'BHC' as bhc,
    'CIH' as cih,
    'ELM' as elm,
    'HLM' as hlm,
    'JMC' as jmc,
    'KCHC' as kch,
    'LHC' as lhc,
    'MHC' as mhc,
    'NCB' as ncb,
    'QHC' as qhc,
    'WHH' as whh,
    'ALL' as "All"
  )
) order by esi_key, metric_id;

select * from edd_etl;


-- Q3 - Triage to Provider Time / # of Visits:
select
  esi, bhc, cih, hlm, jmc, kch, lhc, mhc, ncb, whh, "All"
from
(
  select
    v.esi_key, e.esi||' (ESI '||v.esi_key||') - # of Visits' esi,
    decode(grouping(f.FacilityCode), 1, 'All', f.FacilityCode) FacilityCode, 
    sum(v.num_of_visits) num_of_visits
  from edd_fact_stats_qmed_only v
  join edd_dim_facilities f on f.FacilityKey = v.Facility_Key
  join edd_dim_esi e on e.esiKey = v.esi_key 
  where v.visit_start_dt >= date '2017-01-01' and v.visit_start_dt < date '2017-02-01'
  and esi_key > 0
  and bitand(v.progress_ind, 2) = 2
  group by grouping sets((v.esi_key, e.esi, f.FacilityCode),(v.esi_key, e.esi))
)
pivot
(
  max(num_of_visits)
  for FacilityCode in 
  (
    'BHC' as bhc,
    'CIH' as cih,
    'ELM' as elm,
    'HLM' as hlm,
    'JMC' as jmc,
    'KCHC' as kch,
    'LHC' as lhc,
    'MHC' as mhc,
    'NCB' as ncb,
    'QHC' as qhc,
    'WHH' as whh,
    'All' as "All"
  )
)
order by esi_key;

-- Q4 - Triage to Provider Time / # of Visits in Prescribed Time:
select
  esi, bhc, cih, hlm, jmc, kch, lhc, mhc, ncb, whh, elm, qhc, "All"
from
(
  select
    e.esiKey, e.esi||' (ESI '||e.esiKey||') - # of Visits' esi,
    decode(grouping(f.FacilityCode), 1, 'All', f.FacilityCode) FacilityCode, 
    sum(nvl(v.num_of_visits, 0)) num_of_visits
  from edd_dim_facilities f 
  cross join edd_dim_esi e
  left join edd_fact_stats v
    on v.esi_key = e.esiKey
   and v.Facility_Key = f.FacilityKey
   and v.visit_start_dt >= date '2017-01-01' and v.visit_start_dt < date '2017-02-01'
   and bitand(v.progress_ind, 32) = 32
  where e.esikey > 0
  group by grouping sets((e.esiKey, e.esi, f.FacilityCode),(e.esiKey, e.esi))
)
pivot
(
  max(num_of_visits)
  for FacilityCode in 
  (
    'BHC' as bhc,
    'CIH' as cih,
    'ELM' as elm,
    'HLM' as hlm,
    'JMC' as jmc,
    'KCHC' as kch,
    'LHC' as lhc,
    'MHC' as mhc,
    'NCB' as ncb,
    'QHC' as qhc,
    'WHH' as whh,
    'All' as "All"
  )
)
order by esikey;

exec DBMS_SESSION.SET_IDENTIFIER('25-JUN-17');
select * from vw_edd_metric_values;

-- Intersection:
SELECT DISTINCT
  pvc.FacilityKey,
  trunc(t.date_, 'MONTH')
from eddashboard.edd_stg_patientvisitcorporate pvc
join edd_dim_time t on t.dimtimekey = pvc.patientarrivaldtkey
where pvc.FacilityKey in (4, 11)
intersect
select distinct
  DECODE(location_id, 1500, 4, 1100, 6, 2400, 11, -1) AS facility_key,
  trunc(arrived_time, 'MONTH')
from EPIC_ED_DASHBOARD.EDD_STG_EPIC_VISITS
where location_id in (1500, 2400)
;