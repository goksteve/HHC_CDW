select
  min(dimtimekey) min_key,
  max(dimtimekey) max_key
from edd_dim_time
where date_ >= date '2017-01-01'
and date_ < date '2017-02-01';

create table edd_tst_stg_qmed_jan_visits as
select
  FacilityKey facility_key,
  visitNumber visit_number,
  MiniRegToTriageMinutes arr_to_triage,
  DoorToFirstProvider arr_to_fp,
  ArrivalTo1stProviderAdmitted arr_to_fp_adm,
  ArrivalTo1stProviderDischarged arr_to_fp_disch,
  ArrivalToDispositionAdmitted arr_to_disp_adm,
  ArrivalToDispositionDischarged arr_to_disp_disch,
  TriageToProviderMinutes triage_to_fp,
  TriageToExitAdmitted triage_to_exit_adm,
  TriageToExitDischarged triage_to_exit_disch,
  ProviderToDispositionMinutes fp_to_disp,
  ProviderToExitAdmitted fp_to_exit_adm,
  ProviderToExitDischarged fp_to_exit_disch,
  DoorToExitAdmitted ed_los_adm,
  DoorToExitDischarged ed_los_disch
from eddashboard.edd_stg_PatientVisitCorporate
where EDVisitOpenDTKey between 2983680 and 3028319;

drop table edd_tst_fact_qmed_jan_visits purge;
create table edd_tst_fact_qmed_jan_visits as
select
  facility_key,
  visit_number,
  arrival_to_triage arr_to_triage,
  arrival_to_first_provider arr_to_fp,
  Arrival_To_Disposition arr_to_disp,
  Triage_To_First_Provider triage_to_fp,
  Triage_To_Exit triage_to_exit,
  First_Provider_To_Disposition fp_to_disp,
  First_Provider_To_Exit fp_to_exit,
  arrival_To_Exit ed_los
from edd_fact_visits
where arrival_dt >= date '2017-01-01' and arrival_dt < date '2017-02-01'
and source = 'QMED';

-- Median figures calculated on the interval values in the staging table:
select 
  f.FacilityCode,
  to_char(trunc(nvl(g.arr_to_triage,0)/60), '99')||':'||ltrim(to_char(mod(nvl(g.arr_to_triage,0),60),'09')) arr_to_triage,
  to_char(trunc(nvl(g.arr_to_fp,0)/60), '99')||':'||ltrim(to_char(mod(nvl(g.arr_to_fp,0),60),'09')) arr_to_fp,
  to_char(trunc(nvl(g.arr_to_fp_adm,0)/60), '99')||':'||ltrim(to_char(mod(nvl(g.arr_to_fp_adm,0),60),'09')) arr_to_fp_adm,
  to_char(trunc(nvl(g.arr_to_fp_disch,0)/60), '99')||':'||ltrim(to_char(mod(nvl(g.arr_to_fp_disch,0),60),'09')) arr_to_fp_disch,
  to_char(trunc(nvl(g.arr_to_disp_adm,0)/60), '99')||':'||ltrim(to_char(mod(nvl(g.arr_to_disp_adm,0),60),'09')) arr_to_disp_adm,
  to_char(trunc(nvl(g.arr_to_disp_disch,0)/60), '99')||':'||ltrim(to_char(mod(nvl(g.arr_to_disp_disch,0),60),'09')) arr_to_disp_disch,
  to_char(trunc(nvl(g.triage_to_fp,0)/60), '99')||':'||ltrim(to_char(mod(nvl(g.triage_to_fp,0),60),'09')) triage_to_fp,
  to_char(trunc(nvl(g.triage_to_exit_adm,0)/60), '99')||':'||ltrim(to_char(mod(nvl(g.triage_to_exit_adm,0),60),'09')) triage_to_exit_adm,
  to_char(trunc(nvl(g.triage_to_exit_disch,0)/60), '99')||':'||ltrim(to_char(mod(nvl(g.triage_to_exit_disch,0),60),'09')) triage_to_exit_disch,
  to_char(trunc(nvl(g.fp_to_disp,0)/60), '99')||':'||ltrim(to_char(mod(nvl(g.fp_to_disp,0),60),'09')) fp_to_disp,
  to_char(trunc(nvl(g.fp_to_exit_adm,0)/60), '99')||':'||ltrim(to_char(mod(nvl(g.fp_to_exit_adm,0),60),'09')) fp_to_exit_adm,
  to_char(trunc(nvl(g.fp_to_exit_disch,0)/60), '99')||':'||ltrim(to_char(mod(nvl(g.fp_to_exit_disch,0),60),'09')) fp_to_exit_disch,
  to_char(trunc(nvl(g.ed_los_adm,0)/60), '99')||':'||ltrim(to_char(mod(nvl(g.ed_los_adm,0),60),'09')) ed_los_adm,
  to_char(trunc(nvl(g.ed_los_disch,0)/60), '99')||':'||ltrim(to_char(mod(nvl(g.ed_los_disch,0),60),'09')) ed_los_disch
from
(
  select 
    decode(grouping(facility_Key), 1, 0, facility_Key) facility_Key,
    median(arr_to_triage) arr_to_triage,
    median(arr_to_fp) arr_to_fp,
    median(arr_to_fp_adm) arr_to_fp_adm,
    median(arr_to_fp_disch) arr_to_fp_disch,
    median(arr_to_disp_adm) arr_to_disp_adm,
    median(arr_to_disp_disch) arr_to_disp_disch,
    median(triage_to_fp) triage_to_fp,
    median(triage_to_exit_adm) triage_to_exit_adm,
    median(triage_to_exit_disch) triage_to_exit_disch,
    median(fp_to_disp) fp_to_disp,
    median(fp_to_exit_adm) fp_to_exit_adm,
    median(fp_to_exit_disch) fp_to_exit_disch,
    median(ed_los_adm) ed_los_adm,
    median(ed_los_disch) ed_los_disch
  from edd_tst_stg_qmed_jan_visits
  group by rollup(facility_Key)
) g
join edd_dim_facilities f on f.FacilityKey = g.Facility_Key
order by decode(facilitycode, 'ALL', 2, 1), facilityCode;

-- Discrepancies between detail Interval values in the Staging and Fact tables:
with det as
(
  select
    'STG' src, 
    facility_key, visit_number,
    arr_to_triage,
    arr_to_fp, arr_to_fp_adm, arr_to_fp_disch,
    nvl(arr_to_disp_adm, arr_to_disp_disch) arr_to_disp, arr_to_disp_adm, arr_to_disp_disch,
    triage_to_fp, nvl(triage_to_exit_adm, triage_to_exit_disch) triage_to_exit, triage_to_exit_adm, triage_to_exit_disch,
    fp_to_disp, nvl(fp_to_exit_adm, fp_to_exit_disch) fp_to_exit, fp_to_exit_adm, fp_to_exit_disch,
    nvl(ed_los_adm, ed_los_disch) ed_los, ed_los_adm, ed_los_disch
  from edd_tst_stg_qmed_jan_visits t
  union all
  select
    'FACT', facility_key, cast(visit_number as nvarchar2(100)),
    arr_to_triage, arr_to_fp, null, null, 
    arr_to_disp, null, null,
    triage_to_fp, triage_to_exit, null, null,
    fp_to_disp, fp_to_exit, null, null,
    ed_los, null, null
  from edd_tst_fact_qmed_jan_visits t
)
select *
from
(
  select
    det.*,
    case
      when count(1) over(partition by facility_key, visit_number) < 2 then 'CNT'
      when min(arr_to_triage) over(partition by facility_key, visit_number) <> max(arr_to_triage) over(partition by facility_key, visit_number) then 'ARR_TO_TRIAGE' 
      when min(arr_to_fp) over(partition by facility_key, visit_number) <> max(arr_to_fp) over(partition by facility_key, visit_number) then 'ARR_TO_FP' 
      when min(arr_to_disp) over(partition by facility_key, visit_number) <> max(arr_to_disp) over(partition by facility_key, visit_number) then 'ARR_TO_DISP' 
      when min(triage_to_fp) over(partition by facility_key, visit_number) <> max(triage_to_fp) over(partition by facility_key, visit_number) then 'TRIAGE_TO_FP' 
      when min(triage_to_exit) over(partition by facility_key, visit_number) <> max(triage_to_exit) over(partition by facility_key, visit_number)  then 'TRIAGE_TO_EXIT'
      WHEN min(fp_to_disp) over(partition by facility_key, visit_number) <> max(fp_to_disp) over(partition by facility_key, visit_number) THEN 'FP_TO_DISP'
      when min(fp_to_exit) over(partition by facility_key, visit_number) <> max(fp_to_exit) over(partition by facility_key, visit_number) THEN 'FP_TO_EXIT'
      when min(ed_los) over(partition by facility_key, visit_number) <> max(ed_los) over(partition by facility_key, visit_number) then 'ED_LOS'
      else 'OK'
    end flag
  from det
) where flag <> 'OK'
order by facility_key, visit_number, src desc;


-- All the FP_TO_EXIT values from the staging table:
with det as
(
  select facility_key, visit_number, fp_to_exit_disch
  from edd_tst_stg_qmed_jan_visits
  where facility_key = 8
  and fp_to_exit_disch is not null
)
select * from det order by 1, 2;
select median(fp_to_exit_disch) from det;