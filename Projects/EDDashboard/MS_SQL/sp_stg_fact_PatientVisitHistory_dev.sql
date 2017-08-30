USE [EDDashboard]
GO

/****** Object:  StoredProcedure [dbo].[sp_stg_fact_PatientVisitHistory_dev]    Script Date: 4/27/2017 4:51:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

drop procedure [dbo].[sp_stg_fact_PatientVisitHistory_dev_oleg]
go

CREATE PROCEDURE  [dbo].[sp_stg_fact_PatientVisitHistory_dev_oleg] AS
INSERT INTO stg.PatientVisitHistory
(
	FacilityCode
	,PatientName
	,MRN
	,VisitNumber
	,WSMessageID
	,WSMessageReceivedDT
	,Cliniccode
	,Sex
	,DOB
	,EventType
	,EventID
	,ArchiveNumber
	,EventDT
	,DocumentationDT
	,NoteCompletionDT
	,[Status]
	,UserName
	,UserType
	,UserID
	,AssignedWaitingArea
	,EDReentry
	,PatientComplaint
	,Pretriagepriority
	,UndoLastPtExit
	,WhiteBoardReEntered
	,ChiefComplaint
	,FirstNoAns
	,SecondNoAns
	,ThirdNoAns
	,RecallReq
	,VWNAEventType
	,VoluntaryWalkOut
	,VoluntaryWalkOutReason
	,ArrivedBy
	,BP
	,DangerVS
	,ESI
	,[Language]
	,LifeSaving
	,Medications
	,PainLevel
	,RapidHIV
	,Resources
	,Destination
	,TeamAssignment
	,OnetoOneHugs
	,Nurse
	,Attending
	,Provider
	,AdmissionBedType
	,AdmissionLocation
	,Condition
	,Diagnosis
	,Disposition
	,ExpiredDT
	,SourceMessageType
	,VisitRowNumber
	,PatientLocation
	,Eventreason
)
select *
from
(
	select 
		a.Facility as FacilityCode
		,(PatientLastName+', '+ PatientFirstName) as PatientName
		,MRN
		,a.VisitNumber
		,a.WSMessageID
		,WSMessageReceivedDT
		,Cliniccode
		,Sex
		,DOB
		,EventType
		,EventID
		,null as ArchiveNumber
		,CAST(
		case 
		when LEN(EventDT) < 10 then null else
		substring(EventDT,1,4)+--year
		'-'+
		SUBSTRING(EventDT,5,2) +--month
		'-'+
		substring(EventDT,7,2)+--day
		' '+
		SUBSTRING(EventDT,9,2)+--Hour
		':'+
		SUBSTRING(EventDT,11,2) --minute
		end
		as datetime) as EventDT
		--, CAST(
		--case 
		--when LEN(case when name='DocumentationDT' then (replace (value,' ','')) else null end) <> 17
		--then null else
		--substring(case when name='DocumentationDT' then (replace (value,' ','')) else null end,10,4)+--year
		--'-'+
		--SUBSTRING(case when name='DocumentationDT' then (replace (value,' ','')) else null end,7,3) +--month
		--'-'+
		--substring(case when name='DocumentationDT'  then(replace (value,' ','')) else null end,5,2)+--day
		--' '+
		--SUBSTRING(case when name='DocumentationDT' then (replace (value,' ','')) else null end,14,2)+--Hour
		--':'+
		--SUBSTRING(case when name='DocumentationDT' then (replace (value,' ','')) else null end,16,2) --minute
		--end
		--as datetime) as DocumentationDT
		,CONVERT(DATETIME, CASE ISDATE
		(substring(case when name='DocumentationDT' then (replace (value,' ','')) else null end,10,4)+--year
		'-'+
		SUBSTRING(case when name='DocumentationDT' then (replace (value,' ','')) else null end,7,3) +--month
		'-'+
		substring(case when name='DocumentationDT'  then(replace (value,' ','')) else null end,5,2)+--day
		' '+
		SUBSTRING(case when name='DocumentationDT' then (replace (value,' ','')) else null end,14,2)+--Hour
		':'+
		SUBSTRING(case when name='DocumentationDT' then (replace (value,' ','')) else null end,16,2))
		WHEN 1 THEN (substring(case when name='DocumentationDT' then (replace (value,' ','')) else null end,10,4)+--year
		'-'+
		SUBSTRING(case when name='DocumentationDT' then (replace (value,' ','')) else null end,7,3) +--month
		'-'+
		substring(case when name='DocumentationDT'  then(replace (value,' ','')) else null end,5,2)+--day
		' '+
		SUBSTRING(case when name='DocumentationDT' then (replace (value,' ','')) else null end,14,2)+--Hour
		':'+
		SUBSTRING(case when name='DocumentationDT' then (replace (value,' ','')) else null end,16,2)) ELSE NULL END) AS DocumentationDT
		,CAST(
		case 
		when LEN(NoteCompletionDT) < 10 then null else
		substring(NoteCompletionDT,1,4)+--year
		'-'+
		SUBSTRING(NoteCompletionDT,5,2) +--month
		'-'+
		substring(NoteCompletionDT,7,2)+--day
		' '+
		SUBSTRING(NoteCompletionDT,9,2)+--Hour
		':'+
		SUBSTRING(NoteCompletionDT,11,2) --minute
		end
		as datetime) as NoteCompletionDT
		,[Status]
		,UserName
		,UserType
		,UserID
		,case when name = 'AssignedWaitingArea' then Value else null end as AssignedWaitingArea 
		,case when name = 'EDReEntry' then Value else null end as EDReentry 
		,case when name = 'PatientComplaint' then Value else null end as PatientComplaint 
		,case when name = 'Pretriagepriority' then Value else null end as Pretriagepriority 
		,case when name = 'UndoLastPtExit' then Value else null end as UndoLastPtExit 
		,case when name = 'WhiteBoardReEntered' then Value else null end as WhiteBoardReEntered 
		,case when name = 'ChiefComplaint' then Value else null end as ChiefComplaint 
		,case when name = 'FirstNoAns' then Value else null end as FirstNoAns 
		,case when name = 'SecondNoAns' then Value else null end as SecondNoAns 
		,case when name = 'ThirdNoAns' then Value else null end as ThirdNoAns 
		,case when name = 'RecallReq' then Value else null end as RecallReq 
		,case when name = 'VWNAEventType' then Value else null end as VWNAEventType 
		,case when name = 'VoluntaryWalkOut' then Value else null end as VoluntaryWalkOut 
		,case when name = 'VoluntaryWalkOutReason' then Value else null end as VoluntaryWalkOutReason 
		,case when name = 'ArrivedBy' then Value else null end as ArrivedBy 
		,case when name = 'BP' then Value else null end as BP 
		,case when name = 'DangerVS' then Value else null end as DangerVS 
		,case when name = 'ESI' then Value else null end as ESI 
		,case when name = 'Language' then Value else null end as [Language] 
		,case when name = 'LifeSaving' then Value else null end as LifeSaving 
		,case when name = 'Medications' then Value else null end as Medications 
		,case when name = 'PainLevel' then Value else null end as PainLevel 
		,case when name = 'RapidHIV' then Value else null end as RapidHIV 
		,case when name = 'Resources' then Value else null end as Resources 
		,case when name = 'Destination' then Value else null end as Destination 
		,case when name = 'TeamAssignment' then Value else null end as TeamAssignment 
		,case when name = 'OnetoOneHugs' then Value else null end as OnetoOneHugs 
		,case when name = 'Nurse' then Value else null end as Nurse 
		,case when name = 'Attending' then Value else null end as Attending 
		,case when name = 'Provider' then Value else null end as Provider 
		,case when name = 'AdmissionBedType' then Value else null end as AdmissionBedType 
		,case when name = 'AdmissionLocation' then Value else null end as AdmissionLocation 
		,case when name = 'Condition' then Value else null end as Condition 
		,case when name = 'Diagnosis' then Value else null end as Diagnosis 
		,case when name = 'Disposition' then Value else null end as Disposition 
		,
		CAST
		(
			case 
				when LEN(case when name='ExpiredDT' then Value else null end) < 22 then null else
				substring(case when name='ExpiredDT' then Value else null end,13,4)+--year
				'-'+
				SUBSTRING(case when name='ExpiredDT' then Value else null end,9,3) +--month
				'-'+
				substring(case when name='ExpiredDT' then Value else null end,6,2)+--day
				' '+
				SUBSTRING(case when name='ExpiredDT' then Value else null end,19,2)+--Hour
				':'+
				SUBSTRING(case when name='ExpiredDT' then Value else null end,21,2) --minute
			end
			as datetime
		) as ExpiredDT,
		SourceMessageType,
		VisitRowNumber = ROW_NUMBER() over (Partition BY a.Visitnumber, a.FACILITY order by wsmessagereceiveddt),
		CASE WHEN SourceMessageType = 'ADT^A02' THEN patientlocation
		ELSE NULL 
		END AS PatientLocation,
		EventReason
	from vw.WSMessageFactHistory a
	left outer join vw.WSResultFactHistory b on a.WSMessageID = b.WSMessageID
	left outer join 
	(
	  select distinct t.Facility, t.VisitNumber
	  from vw.WSMessage t
	  where t.SourceMessageType = 'ADT^A11'
	) t
	on a.Facility = t.Facility and a.VisitNumber = t.VisitNumber
	where a.WSMessageReceivedDT >= 
	(
	  select dateadd(hour, 1, MAX(date))
	  from dim.controlhour
	  where loadind = 1
	)
	and t.VisitNumber is null and t.Facility is null
) b

GO


