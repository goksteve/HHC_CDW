create table edd_tst_qmed_visits as
select * from edd_fact_visits_qmed_only
where rownum < 1;
EXEC DBMS_ERRLOG.CREATE_ERROR_LOG('edd_tst_qmed_visits','err_edd_tst_qmed_visits');
ALTER TABLE err_edd_tst_qmed_visits ADD entry_ts TIMESTAMP DEFAULT SYSTIMESTAMP;

create table edd_tst_qmed_stats as
select * from edd_fact_STATS_qmed_only
where rownum < 1;
EXEC DBMS_ERRLOG.CREATE_ERROR_LOG('edd_tst_qmed_stats','err_edd_tst_qmed_stats');
ALTER TABLE err_edd_tst_qmed_stats ADD entry_ts TIMESTAMP DEFAULT SYSTIMESTAMP;

create table edd_tst_qmed_metric_values as
select * from edd_fact_metric_values
where rownum < 1;


begin
  xl.open_log('TST_OK_EDD','Testing EDD logic using QMed data with original (wrong) Arrival_DT calculation', true);
/*  
  etl.add_data
  (
    i_operation => 'INSERT /*+APPEND PARALLEL(4)*',
    i_src => 'VW_EDD_TST_QMED_VISITS',
    i_tgt => 'EDD_TST_QMED_VISITS',
    i_errtab => 'ERR_EDD_TST_QMED_VISITS',
    i_commit_at => -1
  );
  
  etl.add_data
  (
    i_operation => 'REPLACE',
    i_src => 'VW_EDD_TST_QMED_STATS',
    i_tgt => 'EDD_TST_QMED_STATS',
    i_errtab => 'ERR_EDD_TST_QMED_STATS',
    i_commit_at => -1
  );
*/  
  etl.add_data
  (
    i_operation => 'REPLACE',
    i_src => 'VW_EDD_TST_QMED_METIRC_VALUES',
    i_tgt => 'EDD_TST_QMED_METRIC_VALUES',
    i_commit_at => -1
  );

  xl.close_log('Success');
exception
 when others then
  xl.close_log(sqlerrm, true);
  raise;
end;
/


alter session set current_schema=pt008;

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
            and d.dispositionLookup not in ('Left Without Being Seen', 'Unknown') -- OK: wrong
--            and d.dispositionKey not in (-1, 7) -- OK: should be 
          or m.metric_name = '# of Patients Left Against Medical Advice' and v.disposition_key = 6
          or m.metric_name = '# of Patients Walked Out During Evaluation / Eloped' 
            and v.disposition_key in (10, 15) -- OK: wrong
--            and v.disposition_key in (10, 15, 51) -- OK: should be
          or m.metric_name = '# of Patients Seen '||CHR(38)||' Discharged'
            and 
            -- OK: this whole list should be replaced with the one below:
            d.DispositionLookup in
            (
              'Transferred to Another Hospital',
              'Transferred to Skilled Nursing Facility',
              'Discharged to Home or Self Care',
              'Transferred to Psych ED'
            )
            /*
            -- OK: should be added:
            d.common_name in 
            (
              'Transfer to Another Facility',
              'Correctional Facility',
              'Discharged',
              'Left Against Medical Advice'
            )*/
          or m.metric_name = '# of Patients Transferred to Another Hospital'
            and 
            v.disposition_key = 8 -- OK: wrong
/*            -- OK: should be:
            d.common_name in
            (
              'Ambulatory Surgery',
              'Extended monitoring',
              'Transfer to Psych ED',
              'Transferred'
            )*/
          or m.metric_name = '# of ED Patients Who Were Admitted'
            and
            d.dispositionLookup = 'Admitted as Inpatient' -- OK: wrong
            --d.common_name in ('Admitted','Observation') -- OK: should be
        then num_of_visits
        else 0
      end
    ) metric_value
  from edd_tst_qmed_stats v
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
  where v.visit_start_dt >= '01-JAN-17' and v.visit_start_dt < '01-FEB-17'
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
select metric_id, metric_name, disposition_class, esi_key, bhc, cih, hlm, jmc, kch, lhc, mhc, ncb, whh, "All"
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
  left join edd_fact_stats_qmed_only v
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
