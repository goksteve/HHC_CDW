drop table tst_mental_clinic_visits purge;

create table tst_mental_clinic_visits
(
  network, 
  facility_id,
  patient_id,
  visit_id,
  admission_dt, 
  discharge_dt,
  visit_type_cd,
  provider_id,
  service,
  constraint pk_tst_visit_mental_services primary key(visit_id, service)
) as
select distinct
  d.network, 
  d.facility_id,
  d.patient_id,
  d.visit_id,
  d.admission_dt, 
  d.discharge_dt,
  d.visit_type_cd,
  d.provider_id,
  cc.service
from
(
  select distinct
    network,
    facility_id,
    patient_id,
    visit_id,
    admission_dt, 
    discharge_dt,
    visit_type_cd,
    provider_id
  from tst_visit_diagnoses
  where visit_type_cd <> 'IP'
) d
join ud_master.visit_segment_visit_location vl
  on vl.visit_id = d.visit_id
join hhc_custom.hhc_location_dimension ld
  on ld.location_id = vl.location_id
join hhc_custom.hhc_clinic_codes cc
  on cc.code = ld.clinic_code
 and cc.service = 'Mental Health';
