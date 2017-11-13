select
  min(dimtimekey) min_key,
  max(dimtimekey) max_key
from edd_dim_time
where date_ >= date '2017-01-01'
and date_ < date '2017-02-01';

select * from edd_dim_facilities;

drop table edd_tst_stg_jmc_timings purge;

create table edd_tst_stg_jmc_timings as
select
  VisitNumber visit_number,
  esikey esi_key,
  DispositionKey disposition_key,
  Arrivalto1stproviderdischarged arr_to_fp_disch,
  ArrivaltoDispositionDischarged arr_to_disp_disch,
  ProviderToExitDischarged fp_to_exit_disch,
  TriageToExitDischarged tr_to_exit_disch
from EDDASHBOARD.EDD_STG_PATIENTVISITCORPORATE
where 1=1
and facilitykey = 8 -- JMC
--    and facilitykey = 10 -- NCB
--    and arrivalto1stproviderdischarged is not null
--and ArrivaltoDispositionDischarged is not null
and EDVisitOpenDTKey between 2983680 and 3028319;

select
  count(1) cnt,
  median(arr_to_fp_disch) arr_to_fp_disch,
  median(arr_to_disp_disch) arr_to_disp_disch,
  median(case when fp_to_exit_disch>0 then fp_to_exit_disch end) fp_to_exit_disch,
  median(tr_to_exit_disch) tr_to_exit_disch
from edd_tst_stg_jmc_timings;

create table edd_tst_qmed_jmc_timings as
select
  visit_number, esi_key, disposition_key,
  register_dt, triage_dt, first_provider_assignment_dt, disposition_dt, exit_dt, progress_ind,
  arrival_to_first_provider, arrival_to_disposition, first_provider_to_exit, triage_to_exit
from edd_tst_qmed_visits
where facility_key = 8
and arrival_dt >= date '2017-01-01' and arrival_dt < date '2017-02-01';

select
  count(1) cnt,
  median(arrival_to_first_provider) arr_to_fp,
  median(arrival_to_disposition) arr_to_disp,
  median(case when first_provider_to_exit>0 then first_provider_to_exit end) fp_to_exit,
  median(triage_to_exit) tr_to_exit,
from edd_tst_qmed_jmc_timings
--where disposition_key in (select dispositionKey from edd_qmed_dispositions where disposition_class = 'DISCHARGED');
where visit_number in
(
  select visit_number
  from edd_tst_stg_jmc_timings
  where arr_to_fp_disch is not null
);

select distinct disposition_key
from edd_tst_qmed_jmc_timings
--where disposition_key in (select dispositionKey from edd_qmed_dispositions where disposition_class = 'DISCHARGED');
where visit_number in
(
  select visit_number
  from edd_tst_stg_jmc_timings
  where arr_to_fp_disch is not null
);


edd_qmed_dispositions d
-- on d.disposition_class = mu.disposition_class