USE [EDDashboard]
GO

/****** Object:  StoredProcedure [dbo].[sp_stg_fact_patientvisithourly_dev]    Script Date: 4/28/2017 10:09:56 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_stg_fact_patientvisithourly_dev] as

Truncate table stg.[PatientVisitHourlyTable]

truncate TABLE [dbo].[Tsp_stg_fact_pv_h_dev_01]

truncate TABLE [dbo].[Tsp_stg_fact_pv_h_dev_02]

truncate TABLE [dbo].[Tsp_stg_fact_pv_h_dev_03]

truncate table [dbo].[PVHView]

Insert into dbo.PVHView 
Select * from dbo.PatientVisitHistory


PRINT '1 tbl'

insert into [dbo].[Tsp_stg_fact_pv_h_dev_01]
SELECT  VisitNumber
	  , FacilityCode
	  , max(patientname) 	AS PatientName
	  , max(sex) 		AS Sex
	  , max(ClinicCode) 	AS ClinicCode
	  , max(DOB) 		AS DOB
	  , min([Datehour]) 	AS VISITHOUR_MIN
	  , case when max([Datehour]) > dateadd(day,3,min([Datehour])) then dateadd(day,3,min([Datehour])) else max([Datehour]) end	AS VISITHOUR_MAX
	  
--into [dbo].[Tsp_stg_fact_pv_h_dev_03]
FROM
	dbo.PVHView
GROUP BY
	  VisitNumber
  	, FacilityCode

PRINT '2 tbl'

insert into [dbo].[Tsp_stg_fact_pv_h_dev_02]
SELECT 
	pvh.[FacilityCode] , [MRN] , pvh.[VisitNumber] , pvh.[Datehour] AS VISITHOUR , t.datehour AS TIMEHOUR , 
	[PatientArrivalDT] , [EDVisitOpenDT] , [TriageDT] , [DesignationDT] , [FirstProviderAssignmentDT] , [CurrentProviderAssignmentDT] , 
	[DispositionDT] , [PtExitDT] , c.[PatientName] , c.[ClinicCode] , c.[Sex] , c.[DOB] , [AssignedWaitingArea] , [EDReentry] , [PatientComplaint] , 
	[Pretriagepriority] , [UndoLastPtExit] , [WhiteBoardReEntered] , [ChiefComplaint] , [FirstNoAns] , [SecondNoAns] , [ThirdNoAns] , [RecallReq] , 
	[VWNAEventType] , [VoluntaryWalkOut] , [VoluntaryWalkOutReason] , [ArrivedBy] , [BP] , [DangerVS] , [ESI] , [Language] , [LifeSaving] , [Medications] , 
	[PainLevel] , [RapidHIV] , [Resources] , [Destination] , [TeamAssignment] , [OnetoOneHugs] , [CurrentNurse] , [CurrentAttending] , [CurrentProvider] , 
	[FirstNurse] , [FirstAttending] , [FirstProvider] , [AdmissionBedType] , [AdmissionLocation] , [Condition] , [Diagnosis] , [Disposition] , [ExpiredDT] , 
	[CurrentEventState] , [AdultPedsInd] , ADT03

FROM
	dbo.PVHView pvh, dimview.TIMEHOURly t, [dbo].[Tsp_stg_fact_pv_h_dev_01] c

WHERE 
    t.datehour <= GETDATE()  and 
    (
	c.VisitNumber = pvh.VisitNumber AND c.FacilityCode = pvh.FacilityCode
	AND t.datehour between c.VISITHOUR_MIN and c.VISITHOUR_MAX
	AND t.datehour >= pvh.datehour   --AND t.DateHour - pvh.Datehour < 3  	
  	)
  	
PRINT '3 tbl AGGR'  	  	

insert into [dbo].[Tsp_stg_fact_pv_h_dev_03]
SELECT [FacilityCode]
			   , [MRN]
			   , [VisitNumber]
			   , TIMEHOUR

			   , max([PatientArrivalDT]) AS PatientArrivalDT
			   , max([EDVisitOpenDT]) AS EDVisitOpenDT
			   , max([TriageDT]) AS [TriageDT]
			   , max([DesignationDT]) AS [DesignationDT]
			   , max([FirstProviderAssignmentDT]) AS [FirstProviderAssignmentDT]
			   , max([CurrentProviderAssignmentDT]) AS [CurrentProviderAssignmentDT]
			   , max([DispositionDT]) AS [DispositionDT]
			   , max([PtExitDT]) AS [PtExitDT]


			   , min(PatientName) AS PatientName
			   , max(ClinicCode) AS ClinicCode
			   , max(Sex) AS Sex
			   , max(DOB) AS DOB
			   , max(AssignedWaitingArea) AS AssignedWaitingArea
			   , max(EDReentry) AS EDReentry
			   , max(PatientComplaint) AS PatientComplaint
			   , max(Pretriagepriority) AS Pretriagepriority
			   , max(UndoLastPtExit) AS UndoLastPtExit
			   , max(WhiteBoardReEntered) AS WhiteBoardReEntered
			   , max(ChiefComplaint) AS ChiefComplaint
			   , max(FirstNoAns) AS FirstNoAns
			   , max(SecondNoAns) AS SecondNoAns
			   , max(ThirdNoAns) AS ThirdNoAns
			   , max(RecallReq) AS RecallReq
			   , max(VWNAEventType) AS VWNAEventType
			   , max(VoluntaryWalkOut) AS VoluntaryWalkOut
			   , max(VoluntaryWalkOutReason) AS VoluntaryWalkOutReason
			   , max(ArrivedBy) AS ArrivedBy
			   , max(BP) AS BP
			   , max(DangerVS) AS DangerVS
			   , max(ESI) AS ESI
			   , max(Language) AS Language
			   , max(LifeSaving) AS LifeSaving
			   , max(Medications) AS Medications
			   , max(PainLevel) AS PainLevel
			   , max(RapidHIV) AS RapidHIV
			   , max(Resources) AS Resources
			   , max(Destination) AS Destination
			   , max(TeamAssignment) AS TeamAssignment
			   , max(OnetoOneHugs) AS OnetoOneHugs
			   , max(currentNurse) AS CurrentNurse
			   , max(currentAttending) AS CurrentAttending
			   , max(currentProvider) AS CurrentProvider
			   , max(firstNurse) AS FirstNurse
			   , max(firstAttending) AS FirstAttending
			   , max(firstProvider) AS FirstProvider
			   , max(AdmissionBedType) AS AdmissionBedType
			   , max(AdmissionLocation) AS AdmissionLocation
			   , max(Condition) AS Condition
			   , max(Diagnosis) AS Diagnosis
			   , max(Disposition) AS Disposition
			   , max(ExpiredDT) AS ExpiredDT
			   , CASE
					 WHEN 	min(PtExitDT) IS NOT NULL OR datediff(HOUR, min(EDVisitOpenDT), TIMEHOUR) >= 72 OR 
					 	max(Destination) IN (SELECT destination  FROM lkp.destinationgroup WHERE DestinationGroup IN ('Psych', 'OB', 'CPEP', 'BH', 'GYN', '19W', 'EW')) OR
					 	max(ADT03) > 0
						THEN 'Patient Exited'
					 WHEN min(VWNAEventType) = 'Voluntary Exit' OR
						 min(ThirdNoAns) IS NOT NULL OR
						 min(VoluntaryWalkout) IN ('Yes', 'Patient voluntarily left the ED', 'Voluntary Exit') OR min(disposition) = 'Left Without Being Seen' THEN
						 'LWBS'
					 WHEN min(EDVisitOpenDT) IS NOT NULL AND min(TriageDT) IS NULL AND min(FirstProviderAssignmentDT) IS NULL AND min(DispositionDT) IS NULL AND min(PtExitDT) IS NULL THEN
						 'Waiting for Triage'
					 WHEN min(TriageDT) IS NOT NULL AND min(FirstProviderAssignmentDT) IS NULL AND min(DispositionDT) IS NULL AND min(PtExitDT) IS NULL THEN
						 'Waiting for Provider'
					 WHEN min(FirstProviderAssignmentDT) IS NOT NULL AND min(DispositionDT) IS NULL AND min(PtExitDT) IS NULL THEN
						 'In Treatment'
					 WHEN min(DispositionDT) IS NOT NULL AND min(PtExitDT) IS NULL THEN
						 'Dwelling'
					 ELSE
						 NULL
				 END AS CurrentEventState
			   , CASE
					 WHEN max(ClinicCode) IN (SELECT ClinicCode FROM lkp.ClinicCodeGroup WHERE ClinicCodeColumn = 'AdultPedsInd' AND ClinicCodegroup = 'Peds' ) THEN 'Peds'
					 WHEN max(ClinicCode) IN (SELECT ClinicCode FROM lkp.ClinicCodeGroup WHERE ClinicCodeColumn = 'AdultPedsInd' AND ClinicCodegroup = 'Adult') THEN 'Adult'
					 ELSE 'Other'
				 END AS AdultPedsInd
			   , CASE WHEN max(AssignedWaitingArea) = 'Urgent Care' THEN 'Urgent Care' WHEN max(AssignedWaitingArea) = 'Internal' THEN 'Internal'
					 WHEN max(AssignedWaitingArea) = 'PEDS' OR max(ClinicCode) IN (SELECT ClinicCode FROM lkp.ClinicCodeGroup
																				   WHERE ClinicCodeColumn = 'AdultPedsInd' AND ClinicCodegroup = 'Peds') THEN 'Peds'
					 WHEN max(AssignedWaitingArea) = 'Main Adult ED' OR max(ClinicCode) IN (SELECT ClinicCode FROM lkp.ClinicCodeGroup
																							WHERE ClinicCodeColumn = 'AdultPedsInd' AND ClinicCodegroup = 'Adult') THEN 'Adult'
					 ELSE 'Other'
				 END AS TriageAdultPedsInd
		  --INTO [dbo].[Tsp_stg_fact_pv_h_dev_03]
		  FROM 
			[dbo].[Tsp_stg_fact_pv_h_dev_02]
		  GROUP BY
 [VisitNumber]
,[FacilityCode]
,[MRN]
,TIMEHOUR
--


PRINT '4 tbl '  	
/*
drop INDEX stgPatientVisitHourlyTable_CL ON stg.PatientVisitHourlyTable
CREATE CLUSTERED	INDEX stgPatientVisitHourlyTable_CL
ON stg.PatientVisitHourlyTable (
 [VisitNumber]
 -- because nvarchar
 --,[FacilityCode]
 --,[MRN]
 --,TIMEHOUR
)  	
*/

INSERT INTO stg.[PatientVisitHourlyTable]
           ([FacilityCode]
           ,[MRN]
           ,[VisitNumber]
           ,[TIMEHOUR]
           ,[PatientArrivalDT]
           ,[EDVisitOpenDT]
           ,[TriageDT]
           ,[DesignationDT]
           ,[FirstProviderAssignmentDT]
           ,[CurrentProviderAssignmentDT]
           ,[DispositionDT]
           ,[PtExitDT]
           ,[PatientName]
           ,[ClinicCode]
           ,[Sex]
           ,[DOB]
           ,[AssignedWaitingArea]
           ,[EDReentry]
           ,[PatientComplaint]
           ,[Pretriagepriority]
           ,[UndoLastPtExit]
           ,[WhiteBoardReEntered]
           ,[ChiefComplaint]
           ,[FirstNoAns]
           ,[SecondNoAns]
           ,[ThirdNoAns]
           ,[RecallReq]
           ,[VWNAEventType]
           ,[VoluntaryWalkOut]
           ,[VoluntaryWalkOutReason]
           ,[ArrivedBy]
           ,[BP]
           ,[DangerVS]
           ,[ESI]
           ,[Language]
           ,[LifeSaving]
           ,[Medications]
           ,[PainLevel]
           ,[RapidHIV]
           ,[Resources]
           ,[Destination]
           ,[TeamAssignment]
           ,[OnetoOneHugs]
           ,[CurrentNurse]
           ,[CurrentAttending]
           ,[CurrentProvider]
           ,[FirstNurse]
           ,[FirstAttending]
           ,[FirstProvider]
           ,[AdmissionBedType]
           ,[AdmissionLocation]
           ,[Condition]
           ,[Diagnosis]
           ,[Disposition]
           ,[ExpiredDT]
           ,[CurrentEventState]
           ,[AdultPedsInd]
           ,[TriageAdultPedsInd])
--select * from dbo.patientvisithourly_dev
SELECT *
FROM
	[dbo].[Tsp_stg_fact_pv_h_dev_03] a
WHERE
(
		 CurrentEventState IN ('Waiting for Triage', 'Waiting For Provider', 'In Treatment', 'Dwelling')
		 OR
		 (CurrentEventState = 'Patient Exited'
		 AND TIMEHOUR <= PtExitDT AND PtExitDT < DATEADD(hour,1,TIMEHOUR )
		 --AND cast(PtExitDT AS DATE) = cast(TIMEHOUR AS DATE) AND datepart (HOUR, PtExitDT) = datepart (HOUR, TIMEHOUR)
		 )
)
AND
(
	EDVisitOpenDT IS NOT NULL
	AND TIMEHOUR <= GETDATE()
	AND FacilityCode + (ClinicCode) IN (SELECT FacilityCode + ClinicCode FROM lkp.ClinicCodeGroup WHERE ClinicCodeColumn = 'AdultPedsInd' AND NRTHistorical = 'Historical')

)

truncate TABLE [dbo].[Tsp_stg_fact_pv_h_dev_01]

truncate TABLE [dbo].[Tsp_stg_fact_pv_h_dev_02]

truncate TABLE [dbo].[Tsp_stg_fact_pv_h_dev_03]

truncate table [dbo].[PVHView]

-- end of sp  	


GO


