select
  --s.name schema_name, t.name table_name
  'select * from '+s.name+'.'+t.name+';' cmd
from sys.tables t
join sys.schemas s on s.schema_id = t.schema_id
where s.name = 'fact' and t.name not in
(
  'Facility_tmp2',
  'PatientVisitHistory_BK',
  'PatientVisitHistory_Hier_del'
)
order by t.name;

-- Small referencve tables:
select * from dim.ESI;	-- emergency levels
select * from dim.TriageAdultPeds; -- Adult/Ped types of the Patients who are still waiting for triage: 5 rows
select * from dim.AdultPeds; -- -- Adult/Ped types of the Patients who have been seen: 3 rows
select * from dim.ValueState; -- 1-Red, 2-Yellow, -1-Unknown
select * from dim.ClinicCode; -- Types of the Clinc: 10 rows
select * from dim.CurrentEventState; -- Types of Events: 1-Waiting for Triage, 2-Waiting for Provider, 3-In Treatment; 7 rows in total
select * from dim.Event; -- similar to previous table but 12 rows;
select * from dim.Disposition; -- what can happen to the Patient after ED: 51 rows
select * from dim.Facility; -- list of 12 facilities
select * from dim.FacilityBeds; -- Number of beds for the 12 facilities

select * from dim.AdmissionLocation; -- ED units/rooms admitting patients: 1820 rows
select * from dim.Destination; -- ??? 5.8 K rows
select * from dim.Diagnosis; -- 28.5 K rows

select * from dim.Time;
select * from dim.Hour;
select * from dim.Attending; -- doctors only? 5K rows
select * from dim.Provider; -- all medical personal? doctors only? 11K rows
select * from dim.Nurse; -- 2K rows
select * from dim.PatientVisitMapping; -- almost 1M rows what is it for?

-- Note: the following 3 tables are structurally identical
select * from dim.PatientVisit; -- 10K rows
select count(1) cnt from dim.PatientVisitCorporate; -- 5.8 M rows
select count(1) cnt from dim.PatientVisitHistory; -- 23.6 M rows

-- Fact tables:
select count(1) cnt from fact.PatientVisit; -- 0 rows ???
select count(1) cnt from fact.PatientVisit_Event; -- 0 rows ??? -- raw detail data

select h.cnt, mn.Date min_date, mx.Date max_date  -- 7758 rows, 02/15/2017 - 02/18/2017
from
(
  select count(1) cnt, min(EDVisitOpenDTKey) min_dt, max(EDVisitOpenDTKey) max_dt
  from fact.PatientVisitHistory12NRT
) h
left join dim.Time mn on mn.DimTimeKey = h.min_dt
left join dim.Time mx on mx.DimTimeKey = h.max_dt;

select h.cnt, mn.Date min_date, mx.Date max_date  -- 5.3 M rows, 06/11/2011 - 02/18/2017
from
(
  select count(1) cnt, min(EDVisitOpenDTKey) min_dt, max(EDVisitOpenDTKey) max_dt
  from fact.PatientVisitCorporate
  where EDVisitOpenDTKey > 0
) h
left join dim.Time mn on mn.DimTimeKey = h.min_dt
left join dim.Time mx on mx.DimTimeKey = h.max_dt;

select h.cnt, mn.Date min_date, mx.Date max_date  -- 37 M rows, 07/01/2011 - 02/18/2017
from
(
  select count(1) cnt, min(EDVisitOpenDTKey) min_dt, max(EDVisitOpenDTKey) max_dt
  from fact.PatientVisitHistory
) h
left join dim.Time mn on mn.DimTimeKey = h.min_dt
left join dim.Time mx on mx.DimTimeKey = h.max_dt;


select * from dim.Time where [Date] >= '2017-02-18';

select f.* 
from from dim.Time t
join fact.PatientVisitHistory f on f.
where t.[Date] >= '2017-02-18';


select * from fact.PatientVisitCorporate_Agg_tf; -- 43 rows; statistics on Facility/Month level

with
  col_det as
  (
	select t.name table_name, c.name column_name, c.system_type_id, st.name data_type
	from sys.tables t
	join sys.columns c on c.object_id = t.object_id
	join sys.schemas s on s.schema_id = t.schema_id
	join sys.systypes st on st.type = c.system_type_id
	where s.name = 'fact' and t.name in ('PatientVisit', 'PatientVisitHistory', 'PatientVisitCorporate', 'PatientVisitHistory12NRT')
  ),
  col_list as
  (
    select distinct column_name from col_det
  )
select
  cl.column_name,
  c1.data_type InPatientVisit,
  c2.data_type In12NRT,
  c3.data_type InPatientVisitHistory,
  c4.data_type InPatientVisitCorporate
from col_list cl
left join col_det c1 on c1.column_name = cl.column_name and c1.table_name = 'PatientVisit'
left join col_det c2 on c2.column_name = cl.column_name and c2.table_name = 'PatientVisitHistory12NRT'
left join col_det c3 on c3.column_name = cl.column_name and c3.table_name = 'PatientVisitHistory'
left join col_det c4 on c4.column_name = cl.column_name and c4.table_name = 'PatientVisitCorporate'
order by 1;

-- Lookup tables:
select * from lkp.ClinicCodeGroup order by ClinicCode; -- 95 rows; how does it correlate with dim.ClinicCode? What is NRT?

select distinct ClinicCode from lkp.ClinicCodeGroup lkp
where ClinicCode not in
(
  select ClinicCode from dim.ClinicCode
);

select * from lkp.DestinationGroup; -- 650 rows
select * from lkp.DimensionValueMapping; -- 5 rows ???
select * from lkp.MeasureGroups; -- metadata table to support dashboard UI

-- Landing tables:
select count(1) cnt, max(WSMessageReceivedDT) -- 53 M rows, last update: 2017-02-19 04:57:38.633
from dbo.WSMessage;

select * from dbo.WSMessage;

select count(1) cnt, max(WSMessageReceivedDT) -- 787 K rows, 2017-02-19 04:57:38.633
from dbo.WSOriginalMessage;

select count(1) from dbo.WSResult; -- 194 M rows
select count(1) from dbo.WSProvider; -- 26 M rows
select * from dbo.WSProviderType; -- 6 rows

-- Threshold settings: Patient count and median LOS (Length Of Stay in minutes)
-- on different aggregation levels:
select * from fact.Threshold_AdmissionLocation order by 1, 2, 3, 4; -- 348 rows;
select * from fact.Threshold_AdultPeds order by 1, 2, 3; -- 40 rows
select * from fact.Threshold_Destination;
select * from fact.Threshold_Disposition;
select * from fact.Threshold_ESI;
select * from fact.Threshold_TriageAdultPeds;

-- Control tables:
select * from dim.Control;
select * from dim.ControlHour;
select * from dim.CubeLastProcessed;
select * from dim.CubeLastProcessedCorporate;
select * from dim.CubeLastProcessedHistory;
select * from lkp.RunCorporate;

-- Not used?
select * from dim.Patient;
select * from dim.Timex;
select * from dim.Hourx;

select * from dbo.WSProvider;

select * from [dbo].[patientvisithourly_fullload];

select FacilityKey, VisitNumber, count(1) cnt
from fact.PatientVisitCorporate
where EDVisitOpenDTKey >=
(
  select min(DimTimeKey)
  from dim.Time
  where Date >= '2017-02-18'
)
group by FacilityKey, VisitNumber
having count(1)>1
;

with 
  det as
  (
    select *
	from fact.PatientVisitHistory
	where EDVisitOpenDTKey >=
	(
	  select min(DimTimeKey)
	  from dim.Time
	  where Date >= '2017-02-18'
	)
  )
--select FacilityKey, VisitNumber, count(1) cnt from det group by FacilityKey, VisitNumber having count(1)>1;
select f.FactPatientVisitKey, f.FacilityKey, f.VisitNumber, f.DateHour
from det f
join dim.Time t on t.DimTimeKey = f.DimHourKey
join dim.PatientVisitHistory v on v.PatientVisitKey = f.PatientVisitKey
--where f.FacilityKey <> v.FacilityKey or f.VisitNumber <> v.VisitNumber --or f.DateHour <> t.Date
order by f.FacilityKey, f.VisitNumber, f.DateHour
;

select case when datepart(hour, cast(null as datetime)) = datepart(hour, cast(null as datetime)) then 'Equal' else 'Not equal' end;

select CAST (GETDATE() AS DATE);
