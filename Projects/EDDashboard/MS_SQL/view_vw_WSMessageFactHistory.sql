USE [EDDashboard]
GO

/****** Object:  View [vw].[WSMessageFactHistory]    Script Date: 4/28/2017 9:47:34 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO











CREATE VIEW [vw].[WSMessageFactHistory]
AS
SELECT     
case when WSMessageID = '' then null else WSMessageID end as WSMessageID , 
case when WSXMLMessage = '' then null else WSXMLMessage end as WSXMLMessage, 
case when WSMessageStatus = '' then null else WSMessageStatus end as WSMessageStatus, 
case when WSMessageReceivedDT = '' then null else WSMessageReceivedDT end as WSMessageReceivedDT, 
case when PatientFirstName = '' then null else PatientFirstName end as PatientFirstName, 
case when PatientLastName = '' then null else PatientLastName end as PatientLastName, 
case when PatientMiddleInitial = '' then null else PatientMiddleInitial end as PatientMiddleInitial, 
null as PCPIdentifier, 
null as PCPLastName, 
null as PCPFirstName, 
null as PCPMiddleInitial, 
case when MRN = '' then null else MRN end as MRN, 
case when VisitNumber = '' then null else VisitNumber end as VisitNumber, 
case when Sex = '' then null else Sex end as Sex, 
case when DOB = '' then null else DOB end as DOB, 
case when Facility = '' then null else Facility end as Facility, 
case when ClinicCode = '' then null else ClinicCode end as ClinicCode, 
case when SourceMessageType = '' then null else SourceMessageType end as SourceMessageType, 
case when EventType = '' then null else EventType end as EventType, 
case when EventID = '' then null else EventID end as EventID, 
case when EventDT = '' then null else EventDT end as EventDT, 
case when DocumentationDT = '' then null else DocumentationDT end as DocumentationDT, 
case when NoteCompletionDT = '' then null else NoteCompletionDT end as NoteCompletionDT, 
case when Status = '' then null else Status end as Status, 
case when UserName = '' then null else UserName end as UserName, 
case when UserType = '' then null else UserType end as UserType, 
case when UserID = '' then null else UserID end as UserID, 
case when PatientLocation = '' then null else PatientLocation end as PatientLocation, 
case when EventReason = '' then null else EventReason end as EventReason, 
case when PriorServiceDT = '' then null else PriorServiceDT end as PriorServiceDT
FROM         dbo.WSMessage
WHERE     (WSMessageReceivedDT >= '2012-09-01')











GO


