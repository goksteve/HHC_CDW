-- Let's create the table EDD_TST_QMED_STATS_201701
-- with column DISPOSITION_KEY - used in QMED 
drop table edd_tst_qmed_stats_201701 purge;

create table edd_tst_qmed_stats_201701 as
SELECT
  TRUNC(arrival_dt) AS visit_start_dt,
  facility_key,
  esi_key,
  patient_age_group_id,
  patient_gender_cd,
  v.disposition_id Disposition_Key,
  progress_ind,
  COUNT(1) num_of_visits,
  SUM(arrival_to_triage) arrival_to_triage,
  SUM(arrival_to_first_provider) arrival_to_first_provider,
  SUM(arrival_to_disposition) arrival_to_disposition,
  SUM(arrival_to_exit) arrival_to_exit,
  SUM(triage_to_first_provider) triage_to_first_provider,
  SUM(triage_to_disposition) triage_to_disposition,
  SUM(triage_to_exit) triage_to_exit,
  SUM(first_provider_to_disposition) first_provider_to_disposition,
  SUM(first_provider_to_exit) first_provider_to_exit,
  SUM(disposition_to_exit) disposition_to_exit,
  SUM(dwell) dwell   
FROM edd_fact_visits v
WHERE v.source = 'QMED' AND v.arrival_dt >= date '2017-01-01' and v.arrival_dt < date '2017-02-01'
GROUP BY
 TRUNC(v.arrival_dt), facility_key, esi_key, patient_age_group_id, patient_gender_cd,
 v.disposition_id, progress_ind;

exec dbms_session.set_identifier('OLD');

-- Q1 - Volumes:
select metric_name, bhc, cih, hlm, jmc, kch, lhc, mhc, ncb, whh, "All"
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
          or m.metric_name = '# of Patients Left Before Triage' and bitand(v.progress_ind, 2) = 0 and v.Disposition_Key in (-1, 7)
          or m.metric_name = '# of Patients Triaged' and bitand(v.progress_ind, 2) = 2
          or m.metric_name = '# of Patients Claimed by a Provider' and bitand(v.progress_ind, 6) = 6
          or m.metric_name = '# of Patients with a Disposition of LWBS' and v.Disposition_Key = 7
          or m.metric_name = '# of Patients Left After Triage' and bitand(v.progress_ind, 2) = 2 and (bitand(v.progress_ind, 8) = 0 or v.disposition_key = 7)
          or m.metric_name = '# of Patients Left Without Being Seen' and (bitand(v.progress_ind, 8) = 0 or v.disposition_key = 7)
          or m.metric_name = '# of Patients with a Disposition not LWBS' and bitand(v.progress_ind, 8) = 8
            and
            (  -- OK: wrong:
              sys_context('userenv','client_identifier') = 'OLD'
              and d.dispositionLookup not in ('Left Without Being Seen', 'Unknown') and d.dispositionKey <> 51
             or  -- OK: correct:
              sys_context('userenv','client_identifier') = 'OK'
              and d.dispositionKey not in (-1, 7)
            ) 
          or m.metric_name = '# of Patients Left Against Medical Advice' and v.disposition_key = 6
          or m.metric_name = '# of Patients Walked Out During Evaluation / Eloped' 
            and
            ( -- OK: wrong:
              sys_context('userenv','client_identifier') = 'OLD'
              and v.disposition_key in (10, 15)
             or -- OK: correct:
              sys_context('userenv','client_identifier') = 'OK'
              and v.disposition_key in (10, 15, 51)
            )
          or m.metric_name = '# of Patients Seen '||CHR(38)||' Discharged'
            and
            (
              -- OK: wrong:
              sys_context('userenv','client_identifier') = 'OLD'
              and d.DispositionLookup in
              (
                'Transferred to Another Hospital',
                'Transferred to Skilled Nursing Facility',
                'Discharged to Home or Self Care',
                'Transferred to Psych ED'
              )
             or -- OK: correct:
              sys_context('userenv','client_identifier') = 'OK'
              and d.common_name in 
              (
                'Transfer to Another Facility',
                'Correctional Facility',
                'Discharged',
                'Left Against Medical Advice'
              )
            )
          or m.metric_name = '# of Patients Transferred to Another Hospital'
            and
            (
              -- OK: wrong:
              sys_context('userenv','client_identifier') = 'OLD'
              and v.disposition_key = 8
             or -- OK: correct:
              sys_context('userenv','client_identifier') = 'OK'
              and d.common_name in
              (
                'Ambulatory Surgery',
                'Extended monitoring',
                'Transfer to Psych ED',
                'Transferred'
              )
            )
          or m.metric_name = '# of ED Patients Who Were Admitted'
            and
            (
              -- OK: wrong:
              sys_context('userenv','client_identifier') = 'OLD'
              and d.dispositionLookup = 'Admitted as Inpatient'
             or -- OK: correct:
              sys_context('userenv','client_identifier') = 'OK'
              and d.common_name in ('Admitted','Observation')
            )
        then num_of_visits
        else 0
      end
    ) metric_value
  from edd_tst_qmed_stats_201701 v
  join edd_dim_facilities f on f.FacilityKey = v.Facility_Key
  join edd_qmed_dispositions d on d.DispositionKey = v.Disposition_Key
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
  group by grouping sets((m.num, m.metric_name, f.facilityCode), (m.num, m.metric_name)) 
)
pivot
(
  max(metric_value)
  for FacilityCode in 
  (
    'BHC' as bhc,
    'CIH' as cih,
    'HLM' as hlm,
    'JMC' as jmc,
    'KCHC' as kch,
    'LHC' as lhc,
    'MHC' as mhc,
    'NCB' as ncb,
    'WHH' as whh,
    'All' as "All"
  )
)
order by num;


-- Q2:
-- 1) Throughput Metrics - in Median Times (hh:mm)
-- 2) Triage to Provider Time / Median Wait Time - Triage to First Provider
WITH
  metrics AS
  (
    SELECT --+ MATERIALIZE
      mu.metric_id, mu.esi_key, mu.disposition_class, d.disposition_id, d.source  
    FROM
    (
      SELECT
        'QMED' source, DispositionKey disposition_id, common_name
      FROM edd_qmed_dispositions
      UNION ALL
      SELECT 'EPIC', id, common_name
      FROM edd_epic_dispositions
    ) d
    JOIN edd_dim_dispositions dd
      ON dd.disposition_name = d.common_name
    JOIN edd_meta_metric_usage mu
      ON mu.disposition_class = 'ANY' OR mu.disposition_class = dd.disposition_class
  ),
  metric_values as
  (
    SELECT
     --+ LEADING(v) INDEX(v idx_edd_fact_visits_arrival)
      m.metric_id, m.esi_key, m.disposition_class,
      TRUNC(v.arrival_dt, 'MONTH') month_dt,
      DECODE(GROUPING(v.facility_key), 1, 0, v.facility_key) AS facility_key,
      MEDIAN
      (
        DECODE
        (
          m.metric_id,
          1, v.arrival_to_triage,
          2, v.arrival_to_first_provider,
          3, v.arrival_to_disposition,
          4, v.arrival_to_exit,
          5, v.triage_to_first_provider,
          6, v.triage_to_disposition,
          7, v.triage_to_exit,
          8, v.first_provider_to_disposition,
          9, v.first_provider_to_exit,
          10, v.disposition_to_exit,
          11, v.dwell
        ) 
      ) metric_value
    FROM edd_fact_visits v
    JOIN metrics m
      ON m.source = v.source AND m.disposition_id = v.disposition_id
     AND (m.esi_key = 0 OR m.esi_key = v.esi_key)
    WHERE v.arrival_dt >= date '2017-01-01' and v.arrival_dt < date '2017-02-01'
    AND v.source = 'QMED'
    GROUP BY GROUPING SETS
    (
      (TRUNC(v.arrival_dt, 'MONTH'), v.facility_key, m.esi_key, m.disposition_class, m.metric_id),
      (TRUNC(v.arrival_dt, 'MONTH'), m.esi_key, m.disposition_class, m.metric_id)
    )
  )
select metric_id, metric_name, disposition_class, esi_key, bhc, cih, hlm, jmc, kch, lhc, mhc, ncb, whh, "All"
from
(
  select
    m.metric_id, m.description metric_name, mv.disposition_class, mv.esi_key, 
    f.FacilityCode facility_code,
    to_char(trunc(nvl(mv.metric_value,0)/60), '99')||':'||ltrim(to_char(mod(nvl(mv.metric_value,0),60),'09')) metric_value
  from metric_values mv
  join edd_meta_metrics m on m.metric_id = mv.metric_id
  left join edd_dim_facilities f on f.FacilityKey = mv.facility_key
)
pivot
(
  max(metric_value)
  for Facility_Code in 
  (
    'BHC' as bhc,
    'CIH' as cih,
    'HLM' as hlm,
    'JMC' as jmc,
    'KCHC' as kch,
    'LHC' as lhc,
    'MHC' as mhc,
    'NCB' as ncb,
    'WHH' as whh,
    'ALL' as "All"
  )
) order by esi_key, metric_id;

-- Q3 - Triage to Provider Time / # of Visits:
select
  esi, bhc, cih, hlm, jmc, kch, lhc, mhc, ncb, whh, "All"
from
(
  select
    v.esi_key, e.esi||' (ESI '||v.esi_key||') - # of Visits' esi,
    decode(grouping(f.FacilityCode), 1, 'All', f.FacilityCode) FacilityCode, 
    sum(v.num_of_visits) num_of_visits
  from edd_tst_qmed_stats v
  join edd_dim_facilities f on f.FacilityKey = v.Facility_Key
  join edd_dim_esi e on e.esiKey = v.esi_key 
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
    'HLM' as hlm,
    'JMC' as jmc,
    'KCHC' as kch,
    'LHC' as lhc,
    'MHC' as mhc,
    'NCB' as ncb,
    'WHH' as whh,
    'All' as "All"
  )
)
order by esi_key;

-- Q4 - Triage to Provider Time / # of Visits in Prescribed Time:
select
  esi, bhc, cih, hlm, jmc, kch, lhc, mhc, ncb, whh, "All"
from
(
  select
    e.esiKey, e.esi||' (ESI '||e.esiKey||') - # of Visits' esi,
    decode(grouping(f.FacilityCode), 1, 'All', f.FacilityCode) FacilityCode, 
    sum(nvl(v.num_of_visits, 0)) num_of_visits
  from edd_dim_facilities f 
  cross join edd_dim_esi e
  left join edd_tst_qmed_stats v
    on v.esi_key = e.esiKey
   and v.Facility_Key = f.FacilityKey
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
    'HLM' as hlm,
    'JMC' as jmc,
    'KCHC' as kch,
    'LHC' as lhc,
    'MHC' as mhc,
    'NCB' as ncb,
    'WHH' as whh,
    'All' as "All"
  )
)
order by esikey;
