with
  epic as
  (
    select 'EPIC' src,
    f.facilityKey, 
    f.facilityCode,
      g.min_month, g.max_month
    from
    (
      select 
        DECODE(location_id, 1500, 4, 1100, 6, 2400, 11, -1) AS facility_key,
        trunc(min(arrived_time), 'MONTH') min_month,
        trunc(max(arrived_time), 'MONTH') max_month
      from epic_ed_dashboard.edd_stg_epic_visits v
      group by location_id
    ) g
    join edd_dim_facilities f on f.FacilityKey = g.facility_key
  ),
  qmed as
  (
    select
      'QMED' src, 
      f.FacilityKey, 
      f.facilityCode,
      trunc(tmin.date_, 'MONTH') min_month, 
      trunc(tmax.date_, 'MONTH') max_month
    from
    (
      select 
        FacilityKey,
        min(EDVisitOpenDTKey) min_key,
        max(EDVisitOpenDTKey) max_key
      from eddashboard.edd_stg_PatientVisitCorporate
      group by FacilityKey
    ) g
    join edd_dim_facilities f on f.FacilityKey = g.facilityKey
    join edd_dim_time tmin ON tmin.DimTimeKey = g.min_key
    join edd_dim_time tmax ON tmax.DimTimeKey = g.max_key
  )
select * from
(
  select * from qmed
  union all 
  select * from epic
)
pivot
(
  min(min_month) min_month,
  max(max_month) max_month
  for src in ('QMED','EPIC')
)
order by FacilityCode;

select
  f.FacilityKey, f.FacilityCode,
  trunc(min(v.arrival_dt), 'MONTH') min_month,
  trunc(max(v.arrival_dt), 'MONTH') max_month
from edd_fact_visits v
join edd_dim_facilities f
  on f.FacilityKey = v.facility_key
group by f.FacilityKey, f.FacilityCode
order by 2;

-- # of Patients with a Disposition not LWBS (#8):			
-- New data:
select * from
(
  select
    f.FacilityCode,
    d.disposition_name,
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
          or m.metric_name = '# of Patients Left Against Medical Advice' and v.disposition_name = 'Left Against Medical Advice'
          or m.metric_name = '# of Patients Walked Out During Evaluation / Eloped' and d.disposition_class = 'ELOPED'
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
  and f.facilityKey not in (6,11) and d.disposition_name <> 'Correctional Facility'
  and m.num = 8
  group by grouping sets ((f.FacilityCode, d.disposition_name),(f.FacilityCode))
)
pivot
(
  max(metric_value)
  for FacilityCode in ('BHC','CIH','HLM','JMC','KCHC','LHC','MHC','NCB','WHH')	
)  
order by disposition_name;

-- Old data:
select * from
(
  select
    f.FacilityCode,
    d.common_name, 
    d.disposition,
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
           (
             d.dispositionLookup not in ('Left Without Being Seen', 'Unknown')
             or d.dispositionLookup is null -- OK: should be added
           )
          or m.metric_name = '# of Patients Left Against Medical Advice' and v.disposition_key = 6
          or m.metric_name = '# of Patients Walked Out During Evaluation / Eloped' and v.disposition_key in (10, 15)
          or m.metric_name = '# of Patients Seen '||CHR(38)||' Discharged' and d.DispositionLookup in ('Discharged to Home or Self Care','Transferred to Skilled Nursing Facility','Transferred to Another Hospital','Transferred to Psych ED')
          or m.metric_name = '# of Patients Transferred to Another Hospital' and v.disposition_key = 8
          or m.metric_name = '# of ED Patients Who Were Admitted' and d.dispositionLookup = 'Admitted as Inpatient'
        then num_of_visits
        else 0
      end
    ) metric_value
  from edd_fact_stats_qmed_only v
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
  and m.num = 8
  group by grouping sets((d.disposition, d.common_name, f.FacilityCode),(d.common_name, f.FacilityCode),(f.FacilityCode))
) 
pivot
(
  max(metric_value)
  for FacilityCode in ('BHC','CIH','HLM','JMC','KCHC','LHC','MHC','NCB','WHH')	
)  
order by common_name, disposition;

select count(1) cnt
from edd_fact_visits
where facility_key not in (6, 11)
and facility_key = 4
and arrival_dt >= date '2017-01-01' and arrival_dt < date '2017-02-01'
and disposition_name = 'Admitted';


select d.disposition, count(1) cnt
-- facility_key, visit_number
from edd_fact_visits_qmed_only v
join edd_qmed_dispositions d
  on d.dispositionKey = v.disposition_key
 and d.common_name = 'Admitted'
where v.arrival_dt >= date '2017-01-01' and v.arrival_dt < date '2017-02-01' and v.facility_key = 4
group by d.disposition;
