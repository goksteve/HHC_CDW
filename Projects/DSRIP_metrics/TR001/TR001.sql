@REF_DIAGNOSES.sql
select count(1) from ref_diagnoses; 
-- CBN: 44,916

@TST_VISIT_DIAGNOSES.sql
select count(1) from tst_visit_diagnoses;
-- CBN: 207,757

@TST_MENTAL_CLINIC_VISITS.sql
select count(1) from tst_mental_clinic_visits;
-- CBN: 1,466 

select
  q.network,
  p.patient patient_name,
  p.birthdate patient_dob,
  NVL(psn.secondary_number, p.medical_record_nbr) medical_record_nbr,
  p.prim_care_provider,
  f1.name hospitalization_facility,
  q.admission_dt,
  q.discharge_dt,
  q.follow_up_visit_id,
  q.follow_up_dt,
  f2.name follow_up_facility,
  (
    SELECT MIN(prv.provider_name||' - '||prv.physician_service_name) keep (dense_rank first order by case when upper(prv.physician_service_name) like '%PSYCH%' then 1 when prv.physician_service_name is not null then 2 else 3 end, pea.event_id, pea.archive_number)
    FROM ud_master.proc_event_archive pea
    JOIN ref_providers prv ON prv.provider_id = pea.emp_provider_id
    WHERE pea.visit_id = q.follow_up_visit_id
    GROUP BY pea.visit_id
  ) bh_provider_info,
  (
    select
      min(pm.payer_group||'\'||pm.payer_name) keep (dense_rank first order by case when pm.payer_group = 'Medicaid' then 1 else 2 end, vsp.payer_number) 
    from ud_master.visit_segment_payer vsp
    join goreliks1.payer_mapping pm
      on pm.payer_id = vsp.payer_id
    where vsp.visit_id = q.follow_up_visit_id
    and pm.network = q.network
    group by vsp.visit_id
  ) payer_info,
  case when q.follow_up_dt < q.discharge_dt+30 then 'Y' end proper_follow_up
from
(
  select
    network, facility_id, 
    patient_id, visit_id, visit_type_cd,
    trunc(admission_dt) admission_dt,
    trunc(discharge_dt) discharge_dt,
    lead(trunc(re_admission_dt) ignore nulls) over(partition by patient_id order by admission_dt) re_admission_dt,
    lead(trunc(follow_up_dt) ignore nulls) over(partition by patient_id order by admission_dt) follow_up_dt,
    lead(follow_up_visit_id ignore nulls) over(partition by patient_id order by admission_dt) follow_up_visit_id,
    lead(follow_up_facility_id ignore nulls) over(partition by patient_id order by admission_dt) follow_up_facility_id
  from
  ( 
    select
      vd.network,
      vd.facility_id,
      vd.patient_id, 
      vd.visit_id,
      vd.admission_dt,
      vd.discharge_dt,
      vd.visit_type_cd,
      case when vd.visit_type_cd = 'IP' then vd.admission_dt end as re_admission_dt,
      case when vd.visit_type_cd <> 'IP' then vd.visit_id end as follow_up_visit_id, 
      case when vd.visit_type_cd <> 'IP' then vd.admission_dt end as follow_up_dt, 
      case when vd.visit_type_cd <> 'IP' then vd.facility_id end as follow_up_facility_id
    from tst_visit_diagnoses vd
    join ref_hedis_value_sets vs
      on vs.code = vd.diagnosis_icd_cd
     and vs.value_set_name = 'Mental Illness'
    where vd.is_primary_diagnosis = 'Y'
    union
    select
      network,
      facility_id,
      patient_id, 
      visit_id,
      admission_dt,
      discharge_dt,
      visit_type_cd,
      cast(null as date) re_admission_dt,
      visit_id as follow_up_visit_id,
      admission_dt as follow_up_dt,
      facility_id as follow_up_facility_id
    from tst_mental_clinic_visits
  )
) q
join hhc_custom.hhc_patient_dimension p
  on p.patient_id = q.patient_id
join ud_master.facility f1
  on f1.facility_id = q.facility_id
left join ud_master.facility f2
  on f2.facility_id = q.follow_up_facility_id
left join ud_master.patient_secondary_number psn
  on psn.patient_id = q.patient_id
 and psn.secondary_nbr_type_id =
  case
   when q.network = 'GP1' and q.follow_up_facility_id = 1 then 13
   when q.network = 'GP1' and q.follow_up_facility_id in (2, 4) then 11
   when q.network = 'GP1' and q.follow_up_facility_id = 3 then 12
   when q.network = 'CBN' and q.follow_up_facility_id = 4 then 12
   when q.network = 'CBN' and q.follow_up_facility_id = 5 then 13
   when q.network = 'NBN' and q.follow_up_facility_id = 2 then 9
   when q.network = 'NBX' and q.follow_up_facility_id = 2 then 11
   when q.network = 'QHN' and q.follow_up_facility_id = 2 then 11
   when q.network = 'SBN' and q.follow_up_facility_id = 1 then 11
   when q.network = 'SMN' and q.follow_up_facility_id = 2 then 11
   when q.network = 'SMN' and q.follow_up_facility_id = 7 then 13
  end
 and psn.secondary_nbr_id = 1
where q.visit_type_cd = 'IP'
and q.discharge_dt < '01-JUL-17'
and p.birthdate <= add_months(q.discharge_dt, -96)
and (q.re_admission_dt is null or q.re_admission_dt >= q.discharge_dt+30) 
order by patient_name, patient_dob, medical_record_nbr, admission_dt
