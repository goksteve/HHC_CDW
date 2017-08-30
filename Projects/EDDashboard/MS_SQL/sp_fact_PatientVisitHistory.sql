USE [EDDashboard]
GO

/****** Object:  StoredProcedure [dbo].[sp_fact_patientvisithistory]    Script Date: 4/27/2017 1:25:32 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

drop procedure [dbo].[sp_fact_patientvisithistory_oleg]
GO

CREATE Procedure [dbo].[sp_fact_patientvisithistory_oleg] as

insert into [fact].PatientVisitHistory
(
	[VisitNumber],
	[Datehour],
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
	[PatientsNotLWBS],
	[PatientsLeftAMAAfterSeeingProvider],
	[PatientsWhoElopedAfterSeeingProvider] ,
	PatientsSeenAndReleased,
	PatientsTransferredOtherHosp,
	InpatientAdmissionsFromED,
	----PointoPointTime
	MiniRegToTriageMinutes,
	TriageToProviderMinutes,
	ProviderToDispositionMinutes,
	DispositiontoExitMinutes,	
	ProvidertoExitDischargedMinutes,
	ProvidertoExitAdmittedMinutes,
	[DoortoFirstProvider],
	[DoortoExitDischargedMinutes],
	[DoortoExitAdmittedMinutes],
	[ArrivalToFirstProviderDischargedMinutes],
	[TriageToExitDischargedMinutes],
	[TriageToExitAdmittedMinutes],
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
	TriageAdultPedsKey,
	RecordStartDT,
	RecordEndDT,
	DimHourKey
)
Select 
	--FACTS 
	pv.[VisitNumber] as 	[VisitNumber],
	pv.TIMEhour as DATEHOUR,
	----WaitingTime
	CASE when ce.Currenteventstate = 'Waiting For Triage' and timehour >= EDVisitOpenDT THEN DATEDIFF(MINUTE,EDVisitOpenDT,pv.TIMEHOUR) ELSE NULL end as 	WaitingForTriageMinutes,
	CASE when ce.Currenteventstate = 'Waiting For Provider' and timehour >= TriageDT THEN DATEDIFF(MINUTE,TriageDT, pv.TIMEHOUR) ELSE NULL end as  	WaitingForProviderMinutes,
	CASE when ce.Currenteventstate = 'In Treatment' and timehour >= FirstProviderAssignmentDT THEN DATEDIFF(MINUTE,FirstProviderAssignmentDT, pv.TIMEHOUR) ELSE NULL end as  	InTreatmentMinutes,
	CASE when ce.Currenteventstate = 'Dwelling' and timehour >= DispositionDT THEN DATEDIFF(MINUTE,DispositionDT, pv.TIMEHOUR) ELSE NULL end as  	DwellingMinutes,
	Case when ce.CurrentEventState not IN ('Patient Exited','LWBS') and timehour >= EDVisitOpenDT THEN DATEDIFF(MINUTE,EDVisitOpenDT, pv.TIMEHOUR) ELSE NULL end as  	MiniRegtoNowMinutes,
	------Count
	case when ce.CurrentEventState not IN ('Patient Exited','LWBS') then 1 else null end as PatientsInEDNow,
	null as PatientInEDToday,
	case
	  when cast(pv.EDVisitOpenDT AS date ) = cast(pv.TIMEHOUR as date)
	   AND datepart(hour, pv.EDVisitOpenDT) = datepart(hour, pv.timehour)
	  then 1 else null
	end as PatientsArrived, -- 3a
	null as PatientsLeftPriorToTriage,----3b = 3a-3c, In cube
	case
	  when Datepart(hour, pv.triagedt) = Datepart (Hour, pv.Timehour)
	  then 1 else null
	end as PatientsTriaged,--3c
	case
	  when Datepart(hour, pv.FirstProviderAssignmentDT) = Datepart (Hour, pv.Timehour)
	  then 1 else null
	end as PatientsSeenByProvider, --3d
	case
	  when Datepart(hour, pv.dispositiondt) = Datepart (Hour, pv.Timehour)
	   and ds.DispositionLookup = 'Left Without Being Seen'
	  then 1 else null
    end as PatientsLWBS, --3e
	case
	  when Datepart(hour, pv.dispositiondt) = Datepart (Hour, pv.Timehour) 
	   and ds.DispositionLookup <> 'Left Without Being Seen' then 1 else null end as PatientsNotLWBS, --3j
	case when Datepart(hour, pv.dispositiondt) = Datepart (Hour, pv.Timehour) and dispositiondt IS not null  and 
	ds.DispositionLookup = 'Left Against Medical Advice' then 1 else null end  as [PatientsLeftAMAAfterSeeingProvider],--3k
	case when Datepart(hour,dispositiondt) = Datepart (Hour, Timehour) and   dispositiondt IS not null   and 
	ds.DispositionLookup = 'Walked Out During Evaluation' then 1 else null end  as	[PatientsWhoElopedAfterSeeingProvider] ,--3l
	case when Datepart(hour,dispositiondt) = Datepart (Hour, Timehour) and   dispositiondt IS not null  and 
	ds.DispositionLookup IN( 'Discharged to Home or Self Care','Transferred to Skilled Nursing Facility','Transferred to Another Hospital','Transferred to Psych ED')
	 then 1 else null end as PatientsSeenAndReleased,--3m
	case when Datepart(hour,dispositiondt) = Datepart (Hour, Timehour) and   dispositiondt IS not null  and 
	ds.DispositionLookup = 'Transferred to Another Hospital'  then 1 else null end as PatientsTransferredOtherHosp,--3n
	case when Datepart(hour,dispositiondt) = Datepart (Hour, Timehour) and  dispositiondt IS not null  and 
	ds.DispositionLookup =  'Admitted as Inpatient'   then 1 else null end as InpatientAdmissionsFromED,--3o
	-------PointtoPointTime
	case when Datepart(hour,TriageDT) = Datepart (Hour, Timehour) and triagedt >= edvisitopendt  and triagedt is not null
	then   DATEDIFF(MINUTE,EDVisitOpenDT,TriageDT) else null end as 	MiniRegToTriageMinutes,--4a
	case when Datepart(hour,FirstProviderAssignmentDT) = Datepart (Hour, Timehour) 
	and firstproviderassignmentdt >= triagedt and  firstproviderassignmentdt is not null then DATEDIFF(MINUTE,TriageDT,FirstProviderAssignmentDT) 
	else null end as 	TriageToProviderMinutes,--4b
	case when Datepart(hour,DispositionDT) = Datepart (Hour, Timehour)  and DispositionLookup = 'Admitted as Inpatient' and 
	DispositionDT >= FirstProviderAssignmentDT  then DATEDIFF(MINUTE,FirstProviderAssignmentDT,DispositionDT) else null end as  ProviderToDispositionMinutes,--4g
	case when Datepart(hour,PtExitDT) = Datepart (Hour, Timehour) and DispositionLookup = 'Admitted as Inpatient'  and PtExitDT >= DispositionDT and ce.CurrentEventState = 'Patient Exited' then 
	DATEDIFF(MINUTE,DispositionDT,PtExitDT)else null end as 	DispositiontoExitMinutes,	--4h
	case when Datepart(hour,PtExitDT) = Datepart (Hour, Timehour)  and PtExitDT >= FirstProviderAssignmentDT 
	and ce.CurrentEventState = 'Patient Exited' and ds.DispositionLookup = 'Discharged to Home or Self Care' then
	 DATEDIFF(MINUTE,FirstProviderAssignmentDT,PtExitDT) else null end as ProvidertoExitDischargedMinutes,--4e
	case
	  when Datepart(hour,PtExitDT) = Datepart (Hour, Timehour)  and PtExitDT >= FirstProviderAssignmentDT
	   and ce.CurrentEventState = 'Patient Exited' and ds.DispositionLookup =  'Admitted as Inpatient'  
	  then DATEDIFF(MINUTE,FirstProviderAssignmentDT,PtExitDT) else null 
	end as ProvidertoExitAdmittedMinutes,--4i
	case
	  when Datepart(hour, FirstProviderAssignmentDT) = Datepart (Hour, Timehour)
	  and FirstProviderAssignmentDT >= EDVisitOpenDT
	  then DATEDIFF(MINUTE,EDVisitOpenDT,FirstProviderAssignmentDT) else null 
	end as	[DoortoFirstProvider],--4c
	case when Datepart(hour, PtExitDT) = Datepart (Hour, Timehour)  and DispositionDT >= EDVisitOpenDT and  
	ce.CurrentEventState = 'Patient Exited' and ds.DispositionLookup = 'Discharged to Home or Self Care'
	then DATEDIFF(MINUTE,EDVisitOpenDT,DispositionDT) else null end as	[DoortoExitDischargedMinutes],--4k
	case when Datepart(hour,PtExitDT) = Datepart (Hour, Timehour)  and PtExitDT >= EDVisitOpenDT and 
	ce.CurrentEventState = 'Patient Exited' and  ds.DispositionLookup =  'Admitted as Inpatient'  then 
	DATEDIFF(MINUTE,EDVisitOpenDT,PtExitDT) else null end as	[DoortoExitAdmittedMinutes],--4l
	--ARRIVAL TO FIRST PROVIDER DISCHARGED PATIENTS 4d
	case when Datepart(hour,FirstProviderAssignmentDT) = Datepart (Hour, Timehour)  and FirstProviderAssignmentDT >= EDVisitOpenDT and  
	ce.CurrentEventState = 'Patient Exited' and  ds.DispositionLookup = 'Discharged to Home or Self Care'   then 
	DATEDIFF(MINUTE,EDVisitOpenDT,FirstProviderAssignmentDT) else null end as	[ArrivalToFirstProviderDischargedMinutes],--4d
	--TRIAGE TO EXIT FOR DISCHARGED PATIENTS 4f
	case when Datepart(hour,DispositionDt) = Datepart (Hour, Timehour)  and  DispositionDt >= TriageDT and ce.CurrentEventState = 'Patient Exited' and  ds.DispositionLookup = 'Discharged to Home or Self Care'   then 
	DATEDIFF(MINUTE,TriageDT,DispositionDt) else null end as	[TriageToExitDischargedMinutes],--4f
	--TRIAGE TO EXIT FOR ADMITTED PATIENTS 4j
	case when Datepart(hour,PtExitDT) = Datepart (Hour, Timehour)  and   PtExitDT >= TriageDT and ce.CurrentEventState = 'Patient Exited' and  ds.DispositionLookup = 'Admitted as Inpatient'   then 
	DATEDIFF(MINUTE,TriageDT,PtExitDT) else null end as	[TriageToExitAdmittedMinutes],--4j
	--DIMENSIONS
	case when pv.[FacilityCode] IS NULL or pv.[FacilityCode] not in (select FacilityCode from stg.dim_facility)then -1 else isnull(fa.[FacilityKey],-1) end  as	[FacilityKey],
	--case when pv.[ESI] IS NULL then -1 else es.[ESIKey] end as	[ESIKey],
	case when pv.[ESI] IS NULL OR pv.[ESI] NOT IN (SELECT ESI FROM stg.dim_ESI) then -1 else isnull(es.[ESIKey],-1) end as	[ESIKey],
	case when pv.AdmissionLocation Is NULL then -1 else isnull(al.[AdmissionLocationKey],-1) end  as	[AdmissionLocationKey],	
	case when de.destinationkey is Null then -1 else isnull(de.DestinationKey,-1) end as	[DestinationKey],
	case when pv.CurrentEventState is Null then -1 else isnull(ce.CurrentEventStateKey,-1) end as	[CurrentEventStateKey],
	-1 as	[PatientKey] ,	
	case when pv.firstnurse is Null then -1 else isnull(fnurs.NurseKey,-1) end  as	[FirstNurseKey],
	case when pv.firstattending is Null then -1 else isnull(fattn.AttendingKey,-1)  end  as	[FirstAttendingKey],
	case when pv.firstprovider is Null then -1 else isnull(fprov.ProviderKey,-1)  end  as	[FirstProviderKey],
	case when pv.currentnurse is Null then -1 else isnull(cnurs.NurseKey,-1)  end  as	[CurrentNurseKey],
	case when pv.currentattending is Null then -1 else isnull(cattn.AttendingKey,-1)  end  as	[CurrentAttendingKey],
	case when pv.currentprovider is Null then -1 else isnull(cprov.ProviderKey,-1)  end  as	[CurrentProviderKey],
	-1 as	[StatusKey],
	-1 as	[UserKey],
	case when pv.Diagnosis is null then -1 else isnull(di.DiagnosisKey,-1)  end as	[DiagnosisKey],
	case when pv.Disposition is null then -1 else isnull(ds.DispositionKey,-1)  end as   [DispositionKey],
	-1 as	[ChiefComplaintKey],
	----DATES
	case when pv.EDVisitOpenDT is Null or edvis.date IS null then -1 else isnull(edvis.DimTimeKey,-1) end as	EDVisitOpenDTKey,
	case when pv.PatientArrivalDT is Null or  ptarr.date IS null then -1 else isnull(ptarr.DimTimeKey,-1) end as	PatientArrivalDTKey,
	case when pv.TriageDT is Null or triag.date IS null then -1 else isnull(triag.DimTimeKey,-1) end as TriageDTKey,
	case when pv.DesignationDT is Null or desig.date IS null then -1 else isnull(desig.DimTimeKey,-1) end as DesignationDTKey,
	case when pv.FirstProviderAssignmentDT is Null  or fproa.date IS null then -1 else isnull(fproa.DimTimeKey,-1) end as	FirstProviderAssignmentDTKey,
	case when pv.CurrentProviderAssignmentDT is Null or cproa.date IS null then -1 else isnull(cproa.DimTimeKey,-1) end as	CurrentProviderAssignmentDTKey,
	case when pv.DispositionDT is Null  or dispo.date IS null then -1 else isnull(dispo.DimTimeKey,-1) end as	DispositionDTKey,
	case when pv.PtExitDT is Null or ptext.date is null then -1 else isnull(ptext.DimTimeKey,-1) end as	PtExitDTKey,
	case when pv.cliniccode is Null OR pv.ClinicCode not IN (select ClinicCode from dim.cliniccode) then -1 else isnull(cc.ClinicCodeKey,-1) end as ClinicCodeKey,
	case when pv.VisitNumber IS null then -1 else isnull(dimpv.PatientVisitKey,-1) end as PatientVisitKey,
	case when pv.adultpedsind is null then -1 else isnull(ap.AdultPedsKey,-1) end as AdultPedsKey,
	case when pv.triageadultpedsind is null then -1 else isnull(tap.TriageAdultPedsKey,-1) end as TriageAdultPedsKey,
	 pv.TIMEHOUR as RecordStartDT,
	null as RecordEndDT,
	case when pv.timehour is null then -1 else isnull(hr.DimHourKey,-1) end as DimHourKey
From stg.PatientVisitHourlyTable pv
left outer join dim.AdmissionLocation al on pv.AdmissionLocation = al.admissionlocation
left outer join dim.ESI es on pv.ESI = es.ESI
left outer join dim.Facility fa on pv.FacilityCode = fa.facilityCode
left outer join vw.dimDestinationLookup de on pv.Destination = de.destination and pv.FacilityCode = de.facilitycode
left outer join dim.currenteventstate ce on pv.currenteventstate = ce.currenteventstate
left outer join dim.Time edvis on pv.EDVisitOpenDT = edvis.date
left outer join dim.Time ptarr on pv.PatientArrivalDT = ptarr.date
left outer join dim.Time triag on pv.TriageDT = triag.date
left outer join dim.Time fproa on pv.FirstProviderAssignmentDT = fproa.date
left outer join dim.Time cproa on pv.CurrentProviderAssignmentDT = cproa.date
left outer join dim.Time dispo on pv.DispositionDT = dispo.date
left outer join dim.Time ptext on pv.PtExitDT = ptext.date
left outer join dim.Time desig on pv.DesignationDT = desig.date
left outer join dim.cliniccode cc on pv.ClinicCode = cc.cliniccode
left outer join dim.diagnosis di on pv.Diagnosis = di.diagnosis
left outer join dim.disposition ds on pv.Disposition = ds.disposition
left outer join dim.provider cprov on pv.currentprovider = cprov.provider
left outer join dim.attending cattn	on pv.currentattending = cattn.attending
left outer join dim.nurse cnurs	on pv.currentnurse = cnurs.nurse
left outer join dim.provider fprov on pv.firstprovider = fprov.provider
left outer join dim.attending fattn on pv.FirstAttending = fattn.attending
left outer join dim.nurse fnurs on pv.FirstNurse = fnurs.nurse
left outer join dim.patientvisithistory dimpv on pv.VisitNumber = dimpv.visitnumber and fa.FacilityKey = dimpv.facilitykey
left outer join dim.adultpeds ap on pv.adultpedsind = ap.adultpedsind
left outer join dim.triageadultpeds tap on pv.triageadultpedsind = tap.triageadultpedsind
Left outer join dim.Hour hr on pv.TIMEHOUR = hr.datehour
left outer join fact.PatientVisitHistory pvh on pv.VisitNumber = pvh.VisitNumber and pv.TIMEHOUR = pvh.datehour 
where pv.FacilityCode +(pv.cliniccode) in  
(
  select lkp.ClinicCodeGroup.facilitycode+ClinicCode
  from lkp.ClinicCodeGroup
  where ClinicCodeColumn = 'AdultPedsInd' and NRTHistorical = 'Historical'
)
and pv.EDVisitOpenDT is not null
and pvh.VisitNumber is null;

GO
