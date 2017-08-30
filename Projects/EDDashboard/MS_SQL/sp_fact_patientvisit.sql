USE [EDDashboard]
GO

/****** Object:  StoredProcedure [dbo].[sp_fact_patientvisit]    Script Date: 4/27/2017 4:31:46 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[sp_fact_patientvisit] AS
insert into [fact].PatientVisit
(
	--FACTS 
	----Count
	[VisitNumber],
	----PointoPointTime
	MiniRegToTriageMinutes,
	TriageToProviderMinutes,
	ProviderToDispositionMinutes,
	DispositiontoExitMinutes,	
	----WaitingTime
	WaitingForTriageMinutes,
	WaitingForProviderMinutes,
	InTreatmentMinutes,
	DwellingMinutes,
	MiniRegtoNowMinutes,
	----CorporateDashboardMetrics
	------Count
	PatientsInEDNow,
	PatientsInEDToday,
	PatientsArrived,
	PatientsLeftPriorToTriage,
	PatientsTriaged,
	PatientsSeenByProvider,
	PatientsLWBS,
	PatientsSeenAndReleased,
	InpatientAdmissionsFromED,
	-------PointtoPointTime
	ProvidertoExitDischargedMinutes,
	ProvidertoExitAdmittedMinutes,
	--DIMENSIONS
	[FacilityKey],
	[ESIKey],
	[AdmissionLocationKey],	
	[DestinationKey],
	[CurrentEventStateKey],
	
	[PatientKey],	
	[FirstNurseKey],
	[FirstAttendingKey],
	[FirstProviderKey],
	[CurrentNurseKey],
	[CurrentAttendingKey],
	[CurrentProviderKey],
	[StatusKey],
	[UserKey],
	[DiagnosisKey],
	[DispositionKey],
	[ChiefComplaintKey],
	EDVisitOpenDTKey,
	PatientArrivalDTKey,
	TriageDTKey,
	DesignationDTKey,
	FirstProviderAssignmentDTKey,
	CurrentProviderAssignmentDTKey,
	DispositionDTKey,
	PtExitDTKey,
	ClinicCodeKey,
	PatientVisitKey,
	AdultPedsKey,
	TriageAdultPedsKey
)
Select 
	--FACTS 
	pv.[VisitNumber],
	----PointoPointTime
	DATEDIFF(MINUTE,EDVisitOpenDT,TriageDT) as 	MiniRegToTriageMinutes,
	DATEDIFF(MINUTE,TriageDT,FirstProviderAssignmentDT) as 	TriageToProviderMinutes,
	DATEDIFF(MINUTE,FirstProviderAssignmentDT,DispositionDT) as 	ProviderToDispositionMinutes,
	DATEDIFF(MINUTE,DispositionDT,PtExitDT) as 	DispositiontoExitMinutes,	
	----WaitingTime
	CASE when ce.Currenteventstate = 'Waiting For Triage' THEN DATEDIFF(MINUTE,EDVisitOpenDT,GETDATE()) ELSE NULL end as 	WaitingForTriageMinutes,
	CASE when ce.Currenteventstate = 'Waiting For Provider' THEN DATEDIFF(MINUTE,TriageDT,GETDATE()) ELSE NULL end as  	WaitingForProviderMinutes,
	CASE when ce.Currenteventstate = 'In Treatment' THEN DATEDIFF(MINUTE,FirstProviderAssignmentDT,GETDATE()) ELSE NULL end as  	InTreatmentMinutes,
	CASE when ce.Currenteventstate = 'Dwelling' THEN DATEDIFF(MINUTE,DispositionDT,GETDATE()) ELSE NULL end as  	DwellingMinutes,
	Case when ce.CurrentEventState not in ('LWBS', 'Patient Exited')
	THEN DATEDIFF(MINUTE,EDVisitOpenDT,GETDATE()) ELSE NULL end as  	MiniRegtoNowMinutes,
	----CorporateDashboardMetrics
	------Count
	case when ce.CurrentEventState in ('LWBS', 'Patient Exited') then null else 1 end as PatientsInEDNow,
	case
	  when CAST(EDVisitOpenDT AS DATE) = CAST(GETDATE() AS DATE)
		or CAST(TriageDT AS DATE) = CAST(GETDATE() AS DATE)
		or CAST(FirstProviderAssignmentDT AS DATE) = CAST(GETDATE() AS DATE)
		or CAST(DispositionDT AS DATE) = CAST(GETDATE() AS DATE)
	  then 1 else null
	end as	PatientInEDToday,
	case
	  when CAST(EDVisitOpenDT AS DATE) = CAST(GETDATE() AS DATE) then 1
	  else null
	end as 	PatientsArrived,
	null as 	PatientsLeftPriorToTriage,
	null as		PatientsTriaged,
	null as 	PatientsSeenByProvider,
	null as 	PatientsLWBS,
	null as 	PatientsSeenAndReleased,
	null as InpatientAdmissionsFromED,
	-------PointtoPointTime
	null as 	ProvidertoExitDischargedMinutes,
	null as 	ProvidertoExitAdmittedMinutes,
	--DIMENSIONS
	case when pv.[FacilityCode] IS NULL or pv.[FacilityCode] not in (select FacilityCode from stg.dim_facility)then -1 else fa.[FacilityKey] end  as	[FacilityKey],
	--case when pv.[ESI] IS NULL then -1 else es.[ESIKey] end as	[ESIKey],
	case when pv.[ESI] IS NULL OR pv.[ESI] NOT IN (SELECT ESI FROM stg.dim_ESI) then -1 else es.[ESIKey] end as	[ESIKey],
	case when pv.AdmissionLocation Is NULL then -1 else al.[AdmissionLocationKey] end  as	[AdmissionLocationKey],	
	case when de.destinationkey is Null then -1 else de.DestinationKey end as	[DestinationKey],
	case when pv.CurrentEventState is Null then -1 else ce.CurrentEventStateKey end as	[CurrentEventStateKey],
	-1 as	[PatientKey] ,	
	case when pv.firstnurse is Null then -1 else fnurs.NurseKey end  as	[FirstNurseKey],
	case when pv.firstattending is Null then -1 else fattn.AttendingKey end  as	[FirstAttendingKey],
	case when pv.firstprovider is Null then -1 else fprov.ProviderKey end  as	[FirstProviderKey],
	case when pv.currentnurse is Null then -1 else cnurs.NurseKey end  as	[CurrentNurseKey],
	case when pv.currentattending is Null then -1 else cattn.AttendingKey end  as	[CurrentAttendingKey],
	case when pv.currentprovider is Null then -1 else cprov.ProviderKey end  as	[CurrentProviderKey],
	-1 as	[StatusKey],
	-1 as	[UserKey],
	case when pv.Diagnosis is null then -1 else ISNULL(di.DiagnosisKey,-1) end as [DiagnosisKey],			   -- Modified on 05/06/2016 to avoid DiagnosisKey NULL issue
	case when pv.Disposition is null then -1 else ds.DispositionKey end as   [DispositionKey],
	-1 as	[ChiefComplaintKey],
	----DATES:
	case when pv.EDVisitOpenDT is Null or edvis.date IS null then -1 else edvis.DimTimeKey end as EDVisitOpenDTKey,
	case when pv.PatientArrivalDT is Null or  ptarr.date IS null then -1 else ptarr.DimTimeKey end as PatientArrivalDTKey,
	case when pv.TriageDT is Null or triag.date IS null then -1 else triag.DimTimeKey end as TriageDTKey,
	case when pv.DesignationDT is Null or desig.date IS null then -1 else desig.DimTimeKey end as DesignationDTKey,
	case when pv.FirstProviderAssignmentDT is Null  or fproa.date IS null then -1 else fproa.DimTimeKey end as FirstProviderAssignmentDTKey,
	case when pv.CurrentProviderAssignmentDT is Null or cproa.date IS null then -1 else cproa.DimTimeKey end as	CurrentProviderAssignmentDTKey,
	case when pv.DispositionDT is Null  or dispo.date IS null then -1 else dispo.DimTimeKey end as DispositionDTKey,
	case when pv.PtExitDT is Null or ptext.date is null then -1 else ptext.DimTimeKey end as PtExitDTKey,
	case when pv.cliniccode is Null OR pv.ClinicCode not IN (select ClinicCode from dim.cliniccode) then -1 else cc.ClinicCodeKey end as ClinicCodeKey,
	PatientVisitKey,
	case when pv.adultpedsind is null then -1 else AdultPedsKey end as AdultPedsKey,
	case when pv.triageadultpedsind is null then -1 else TriageAdultPedsKey end as TriageAdultPedsKey
From dbo.PatientVisit pv
left outer join dim.AdmissionLocation al on pv.AdmissionLocation = al.admissionlocation
left outer join dim.ESI es on pv.ESI = es.ESI
left outer join dim.Facility fa on pv.FacilityCode = fa.facilityCode
left outer join vw.dimDestinationLookup de on pv.Destination = de.destination and pv.FacilityCode = de.facilitycode
left outer join dim.currenteventstate ce on pv.currenteventstate = ce.currenteventstate
left outer join   dim.Time edvis on pv.EDVisitOpenDT = edvis.date
left outer join  dim.Time ptarr on pv.PatientArrivalDT = ptarr.date
left outer join  dim.Time triag on pv.TriageDT = triag.date
left outer join dim.Time fproa on pv.FirstProviderAssignmentDT = fproa.date
left outer join dim.Time cproa on pv.CurrentProviderAssignmentDT = cproa.date
left outer join dim.Time dispo on pv.DispositionDT = dispo.date
left outer join dim.Time ptext on pv.PtExitDT = ptext.date
left outer join dim.Time desig on pv.DesignationDT = desig.date
left outer join dim.cliniccode cc on pv.ClinicCode = cc.cliniccode
left outer join dim.diagnosis di on pv.Diagnosis = di.diagnosis
left outer join dim.disposition ds on pv.Disposition = ds.disposition
left outer join dim.provider cprov	 on pv.currentprovider = cprov.provider
left outer join dim.attending cattn	 on pv.currentattending = cattn.attending
left outer join dim.nurse cnurs	 on pv.currentnurse = cnurs.nurse
left outer join dim.provider fprov	 on pv.firstprovider = fprov.provider
left outer join dim.attending fattn	 on pv.FirstAttending = fattn.attending
left outer join dim.nurse fnurs	 on pv.FirstNurse = fnurs.nurse
left outer join dim.patientvisit dimpv on pv.VisitNumber = dimpv.visitnumber and dimpv.FacilityKey=fa.FacilityKey
left outer join dim.adultpeds ap on pv.adultpedsind = ap.adultpedsind
left outer join dim.triageadultpeds tap on pv.triageadultpedsind = tap.triageadultpedsind
where pv.facilitycode + (pv.cliniccode) in  
(
  select lkp.ClinicCodeGroup.facilitycode +  ClinicCode
  from lkp.ClinicCodeGroup
  where ClinicCodeColumn = 'AdultPedsInd' and NRTHistorical = 'NRT'
)

GO
