USE [EDDashboard]
GO

/****** Object:  View [dbo].[patientvisit]    Script Date: 4/28/2017 10:27:53 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW  [dbo].[patientvisit]
as
Select FacilityCode,		MRN,	VisitNumber,
max (PatientName) as PatientName,	
max(ClinicCode) as ClinicCode,	
max(Sex) as Sex,	
max(DOB) as DOB ,	
max(PatientArrivalDT) as PatientArrivalDT,
min(EDVisitOpenDT) as EDVisitOpenDT,	
min(TriageDT) as TriageDT,	
min(DesignationDT) as DesignationDT,	
min(firstProviderAssignmentDT)	 as FirstProviderAssignmentDT,
max(CurrentProviderAssignmentDT)	 as CurrentProviderAssignmentDT,
min(DispositionDT)	 as DispositionDT,
min(PtExitDT)	 as PtExitDT,
max(AssignedWaitingArea)	 as AssignedWaitingArea ,
max(EDReentry)	 as EDReentry,
max(PatientComplaint) as PatientComplaint,
max(Pretriagepriority)	 as Pretriagepriority,
max(UndoLastPtExit) as UndoLastPtExit,	
max(WhiteBoardReEntered) as WhiteBoardReEntered,	
max(ChiefComplaint)	 as ChiefComplaint,
max(FirstNoAns)	 as FirstNoAns,
max(SecondNoAns) as SecondNoAns ,	
max(ThirdNoAns) as ThirdNoAns,	
max(RecallReq) as RecallReq,
max(VWNAEventType) as VWNAEventType,	
max(VoluntaryWalkOut) as VoluntaryWalkOut,	
max(VoluntaryWalkOutReason)	 as VoluntaryWalkOutReason,
max(ArrivedBy)	 as ArrivedBy,
min(BP)	 as BP,
min(DangerVS) as DangerVS,	
min(ESI)	 as ESI,
min(Language) as Language,	
min(LifeSaving)	 as LifeSaving,
max(Medications) as Medications,	
max(PainLevel) as PainLevel ,
max(RapidHIV) as RapidHIV,	
min(Resources) as Resources,	
case when max(PatientLocation) IS not null  then max(PatientLocation) else max(Destination) end as Destination,
--case when max(PatientLocation) IS not null  then
--     case when max(PatientLocation) = '' then max(Destination)
--     else max(PatientLocation) end
--else 
--max(Destination) end as Destination, --Modified to ge patient location
max(TeamAssignment) as TeamAssignment ,	
min(OnetoOneHugs) as OnetoOneHugs,	
max(currentNurse)	 as CurrentNurse,
max(currentAttending)	 as CurrentAttending,
max(currentProvider) as CurrentProvider,	
min(firstNurse)	 as FirstNurse,
min(firstAttending)	 as FirstAttending,
min(firstProvider) as FirstProvider,
max(AdmissionBedType) as AdmissionBedType,
max(AdmissionLocation) as AdmissionLocation,	
max(Condition) as Condition,	
max(Diagnosis) as Diagnosis,	
min(Disposition) as Disposition,	
min(ExpiredDT) as ExpiredDT,
case  when min(PtExitDT) IS not null or datediff(hour,min(EDVisitOpenDT) ,GETDATE())>=72 or case when max(PatientLocation) IS not null  then max(PatientLocation) else max(Destination) end in 
(select destination from lkp.destinationgroup where DestinationGroup IN ('Psych','OB', 'CPEP','BH','GYN','19W','EW'))
OR  sum(case when eventtype IN('ADT^A03','ADT^A11') then 1 else 0 end) > 0 
then 'Patient Exited'
when min(VWNAEventType) = 'Voluntary Exit' or 
min(ThirdNoAns) is not null OR
min(VoluntaryWalkout) IN ( 'Yes', 'Patient voluntarily left the ED','Voluntary Exit') OR min(disposition) = 'Left Without Being Seen' then 'LWBS'
when min(EDVisitOpenDT) IS not null and min(TriageDT) IS null and min(FirstProviderAssignmentDT) IS null and min(DispositionDT) is null and min(ptexitdt) is null then 'Waiting for Triage'
when min(TriageDT) IS not null and min(FirstProviderAssignmentDT) IS null and  min(DispositionDT) is null and min(ptexitdt) IS null then 'Waiting for Provider'
when min(FirstProviderAssignmentDT) IS not null and min(DispositionDT) IS null  and min(ptexitdt) is null then 'In Treatment'
when min(DispositionDT)  IS not null and min(PtExitDT) IS Null then 'Dwelling'
else NULL end as CurrentEventState,

CASE WHEN facilitycode + min(cliniccode) IN (select facilitycode+ClinicCode from lkp.ClinicCodeGroup where ClinicCodeColumn = 'AdultPedsInd' and cliniccodegroup = 'Peds' and NRTHistorical = 'NRT')
then 'Peds'
WHEN   facilitycode +  min(cliniccode) IN (select facilitycode + ClinicCode from lkp.ClinicCodeGroup where ClinicCodeColumn = 'AdultPedsInd' and cliniccodegroup = 'Adult' and NRTHistorical = 'NRT')
THEN 'Adult' 
ELSE 'Other' end as AdultPedsInd,
CASE WHEN min(AssignedWaitingArea)  = 'Urgent Care' then 'Fast Track'		--Fast Track replaced Urgent Care per request from Marie Holness (LHC) 02/23/2015 Vinesh Nair
WHEN min(AssignedWaitingArea) = 'Internal' then 'Internal'
WHEN min(AssignedWaitingArea) = 'PEDS' or facilitycode + min(cliniccode) IN (select facilitycode + ClinicCode from lkp.ClinicCodeGroup where ClinicCodeColumn = 'AdultPedsInd' and cliniccodegroup = 'Peds' and NRTHistorical = 'NRT')then 'Peds'
WHEN min(AssignedWaitingArea) = 'Main Adult ED' OR facilitycode + min(cliniccode) IN (select facilitycode + ClinicCode from lkp.ClinicCodeGroup where ClinicCodeColumn = 'AdultPedsInd' and cliniccodegroup = 'Adult' and NRTHistorical = 'NRT') THEN 'Adult'
ELSE 'Other' end as TriageAdultPedsInd


from(



SELECT      
stg.patientvisit.FacilityCode,  
MRN, 
stg.patientvisit.VisitNumber, 
case when (SourceMessageType) like 'ADT^A%'then  sourcemessagetype else EventType end as eventtype, 
case when stg.patientvisit.visitrownumber = c.visitrownumber then(PatientName) end as PatientName, 
case when stg.patientvisit.visitrownumber = d.visitrownumber then(Cliniccode) end as ClinicCode, 
case when stg.patientvisit.visitrownumber = e.visitrownumber then(Sex) end as Sex, 
case when stg.patientvisit.visitrownumber = f.visitrownumber then(DOB) end as DOB,
case when (EventType) = 'Pt Arrival'	then (case when (DocumentationDT)IS null then  (EventDT) else  (DocumentationDT)  end)else null end as PatientArrivalDT,
case when (SourceMessageType) = 'ADT^A04'	then (case when (DocumentationDT)IS null then  (EventDT) else  (DocumentationDT)  end) else null end as EDVisitOpenDT,
case when (EventType) = 'Triage'	then (case when (DocumentationDT)IS null then  (EventDT) else  (DocumentationDT)  end)else null end as TriageDT,
case when (EventType) = 'Designation'	then (case when (DocumentationDT)IS null then  (EventDT) else  (DocumentationDT)  end)else null end as DesignationDT,

case when( (SourceMessageType) = 'ADT^A08'and eventreason = 'Physician Change') or  (EventType) IN('Provider Assignment' , 'Claim Pt')	then (case when (DocumentationDT)IS null then  (EventDT) else  (DocumentationDT)  end)else null end as FirstProviderAssignmentDT,
case when ((SourceMessageType) = 'ADT^A08'and eventreason = 'Physician Change') or (EventType) IN('Provider Assignment' , 'Claim Pt')	then (case when (DocumentationDT)IS null then  (EventDT) else  (DocumentationDT)  end)else null end as CurrentProviderAssignmentDT,



case when (EventType) = 'Disposition'		then (case when (DocumentationDT)IS null then  (EventDT) else  (DocumentationDT)  end)else null end as DispositionDT,
case when ((EventType = 'Pt Exit') OR (SourceMessageType IN('ADT^A03','ADT^A11')))
then (case when (DocumentationDT)IS null then  (EventDT) else  (DocumentationDT)  end) else null end as PtExitDT,
case when stg.patientvisit.visitrownumber = g.visitrownumber then(AssignedWaitingArea) end as AssignedWaitingArea, 
case when stg.patientvisit.visitrownumber = h.visitrownumber then(EDReentry) end as EDReentry, 
case when stg.patientvisit.visitrownumber = i.visitrownumber then  PatientComplaint  end as Patientcomplaint,
case when stg.patientvisit.visitrownumber = j.visitrownumber then(Pretriagepriority) end as Pretriagepriority, 
case when stg.patientvisit.visitrownumber = k.visitrownumber then(UndoLastPtExit) end as UndoLastPtExit, 
case when stg.patientvisit.visitrownumber = l.visitrownumber then(WhiteBoardReEntered) end as WhiteBoardReEntered, 
case when stg.patientvisit.visitrownumber = m.visitrownumber then (ChiefComplaint) end as ChiefComplaint, 
case when stg.patientvisit.visitrownumber = n.visitrownumber then(FirstNoAns) end as FirstNoAns, 
case when stg.patientvisit.visitrownumber = o.visitrownumber then(SecondNoAns) end as SecondNoAns, 
case when stg.patientvisit.visitrownumber = p.visitrownumber then(ThirdNoAns) end as ThirdNoAns, 
case when stg.patientvisit.visitrownumber = q.visitrownumber then (RecallReq) end AS RecallReq, 
case when stg.patientvisit.visitrownumber = s.visitrownumber then (VWNAEventType) end AS VWNAEventType, 
case when stg.patientvisit.visitrownumber = t.visitrownumber then (VoluntaryWalkOut) end AS VoluntaryWalkOut, 
case when stg.patientvisit.visitrownumber = u.visitrownumber then (VoluntaryWalkOutReason) end AS VoluntaryWalkOutReason, 
case when stg.patientvisit.visitrownumber = v.visitrownumber then (ArrivedBy) end AS ArrivedBy, 
case when stg.patientvisit.visitrownumber = w.visitrownumber then (BP) end AS BP, 
case when stg.patientvisit.visitrownumber = x.visitrownumber then (DangerVS) end AS DangerVS, 
case when stg.patientvisit.visitrownumber = y.visitrownumber then (ESI) end AS ESI, 
case when stg.patientvisit.visitrownumber = z.visitrownumber then (Language) end AS Language, 
case when stg.patientvisit.visitrownumber = aa.visitrownumber then (LifeSaving) end AS LifeSaving, 
case when stg.patientvisit.visitrownumber = ab.visitrownumber then (Medications) end AS Medications,
case when stg.patientvisit.visitrownumber = ac.visitrownumber then (PainLevel) end AS PainLevel, 
case when stg.patientvisit.visitrownumber = ad.visitrownumber then (RapidHIV) end AS RapidHIV, 
case when stg.patientvisit.visitrownumber = ae.visitrownumber then (Resources) end AS Resources, 


case when stg.patientvisit.visitrownumber = afpl.visitrownumber 
then stg.patientvisit.patientlocation else null end as PatientLocation,

case when stg.patientvisit.visitrownumber = af.visitrownumber  then   
(stg.patientvisit.Destination) else null end AS Destination, 


case when stg.patientvisit.visitrownumber = ag.visitrownumber then (TeamAssignment) end AS TeamAssignment, 
case when stg.patientvisit.visitrownumber = ah.visitrownumber then (OnetoOneHugs) end AS OnetoOneHugs, 

case when  stg.patientvisit.visitrownumber = ai.visitrownumber  then (Nurse)else null end AS CurrentNurse, 
case when  stg.patientvisit.visitrownumber = aj.visitrownumber then (Attending) else null end AS CurrentAttending, 
case when  stg.patientvisit.visitrownumber = ak.visitrownumber then (Provider) else null end AS CurrentProvider, 
case when  stg.patientvisit.visitrownumber = al.visitrownumber then (Nurse)else null end AS FirstNurse, 
case when stg.patientvisit.visitrownumber = am.visitrownumber  then (Attending) else null end AS FirstAttending, 
case when  stg.patientvisit.visitrownumber = an.visitrownumber then (Provider) else null end AS FirstProvider, 
case when stg.patientvisit.visitrownumber = ao.visitrownumber then (AdmissionBedType) end AS AdmissionBedType, 
case when stg.patientvisit.visitrownumber = ap.visitrownumber then (AdmissionLocation) end AS AdmissionLocation, 
case when stg.patientvisit.visitrownumber = aq.visitrownumber then (Condition) end AS Condition, 
case when stg.patientvisit.visitrownumber = au.visitrownumber then (Diagnosis) end AS Diagnosis, 
case when stg.patientvisit.visitrownumber = ar.visitrownumber then (Disposition) end AS Disposition, 
case when stg.patientvisit.visitrownumber = at.visitrownumber then (ExpiredDT) end AS ExpiredDT

FROM         stg.patientvisit
/*PatientName*/
left outer join (select visitnumber, facilitycode, max(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber,PatientName from stg.patientvisit where PatientName is not null) a group by visitnumber, facilitycode) c on stg.patientvisit.VisitNumber = c.visitnumber and stg.patientvisit.visitrownumber = c.visitrownumber
and stg.patientvisit.facilitycode = c.FacilityCode
/*Cliniccode*/
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber, facilitycode, visitrownumber, Cliniccode from stg.patientvisit where Cliniccode is not null) a group by visitnumber,facilitycode) d on stg.patientvisit.VisitNumber = d.visitnumber and stg.patientvisit.visitrownumber = d.visitrownumber
and stg.patientvisit.facilitycode = d.FacilityCode
/*Sex*/
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, Sex from stg.patientvisit where Sex is not null) a group by visitnumber,facilitycode) e on stg.patientvisit.VisitNumber = e.visitnumber and stg.patientvisit.visitrownumber = e.visitrownumber
and stg.patientvisit.facilitycode = e.FacilityCode
/*DOB*/
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, DOB from stg.patientvisit where DOB is not null) a group by visitnumber,facilitycode) f on stg.patientvisit.VisitNumber = f.visitnumber and stg.patientvisit.visitrownumber = f.visitrownumber
and stg.patientvisit.facilitycode = f.FacilityCode
/*AssignedWaitingArea*/
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, AssignedWaitingArea from stg.patientvisit where AssignedWaitingArea is not null) a group by visitnumber,facilitycode) g on stg.patientvisit.VisitNumber = g.visitnumber and stg.patientvisit.visitrownumber = g.visitrownumber
and stg.patientvisit.facilitycode = g.FacilityCode
/*EDReentry*/
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, EDReentry from stg.patientvisit where EDReentry is not null) a group by visitnumber,facilitycode) h on stg.patientvisit.VisitNumber = h.visitnumber and stg.patientvisit.visitrownumber = h.visitrownumber
and stg.patientvisit.facilitycode = h.FacilityCode
/*PatientComplaint*/
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, patientcomplaint from stg.patientvisit where patientcomplaint is not null) a group by visitnumber,facilitycode) i on stg.patientvisit.VisitNumber = i.visitnumber and stg.patientvisit.visitrownumber = i.visitrownumber
and stg.patientvisit.facilitycode = i.FacilityCode
/*Pretriagepriority*/
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, Pretriagepriority from stg.patientvisit where Pretriagepriority is not null) a group by visitnumber,facilitycode) j on stg.patientvisit.VisitNumber = j.visitnumber and stg.patientvisit.visitrownumber = j.visitrownumber
and stg.patientvisit.facilitycode = j.FacilityCode
/*UndoLastPtExit*/
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, UndoLastPtExit 
from stg.patientvisit where UndoLastPtExit is not null) a group by visitnumber,facilitycode) k on stg.patientvisit.VisitNumber = k.visitnumber and stg.patientvisit.visitrownumber = k.visitrownumber
and stg.patientvisit.facilitycode = k.FacilityCode
/*WhiteBoardReEntered*/
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from 
(select visitnumber, facilitycode, visitrownumber, WhiteBoardReEntered from stg.patientvisit where WhiteBoardReEntered is not null) a group by visitnumber,facilitycode) l on stg.patientvisit.VisitNumber = l.visitnumber and stg.patientvisit.visitrownumber = l.visitrownumber
and stg.patientvisit.facilitycode = l.FacilityCode
/*ChiefComplaint*/
left outer join (select visitnumber, facilitycode, max(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, ChiefComplaint from stg.patientvisit where ChiefComplaint is not null) a group by visitnumber,facilitycode) m on stg.patientvisit.VisitNumber = m.visitnumber and stg.patientvisit.visitrownumber = m.visitrownumber
and stg.patientvisit.facilitycode = m.FacilityCode
/*FirstNoAns*/
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber, facilitycode, visitrownumber, FirstNoAns from stg.patientvisit where FirstNoAns is not null) a group by visitnumber,facilitycode) n on stg.patientvisit.VisitNumber = n.visitnumber and stg.patientvisit.visitrownumber = n.visitrownumber
and stg.patientvisit.facilitycode = n.FacilityCode
/*SecondNoAns*/
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber, facilitycode, visitrownumber, SecondNoAns from stg.patientvisit where SecondNoAns is not null) a group by visitnumber,facilitycode) o on stg.patientvisit.VisitNumber = o.visitnumber and stg.patientvisit.visitrownumber = o.visitrownumber
and stg.patientvisit.facilitycode = o.FacilityCode
/*ThirdNoAns*/
left outer join (select visitnumber, facilitycode, max(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, ThirdNoAns from stg.patientvisit where ThirdNoAns is not null) a group by visitnumber,facilitycode) p on stg.patientvisit.VisitNumber = p.visitnumber and stg.patientvisit.visitrownumber = p.visitrownumber
and stg.patientvisit.facilitycode = p.FacilityCode
/*(RecallReq) */
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber, facilitycode, visitrownumber, (RecallReq)

  from stg.patientvisit where (RecallReq)
    is not null) a group by visitnumber,facilitycode) q on stg.patientvisit.VisitNumber = q.visitnumber and stg.patientvisit.visitrownumber = q.visitrownumber
and stg.patientvisit.facilitycode = q.FacilityCode
/*(VWNAEventType) */
left outer join (select visitnumber, facilitycode, max(visitrownumber) as visitrownumber from (select visitnumber, facilitycode, visitrownumber, (VWNAEventType) 
 from stg.patientvisit where (VWNAEventType) 
  is not null) a group by visitnumber,facilitycode) s on stg.patientvisit.VisitNumber = s.visitnumber and stg.patientvisit.visitrownumber = s.visitrownumber
and stg.patientvisit.facilitycode = s.FacilityCode
/*(VoluntaryWalkOut) */
left outer join (select visitnumber, facilitycode, max(visitrownumber) as visitrownumber from (select visitnumber, facilitycode, visitrownumber, (VoluntaryWalkOut) 
 from stg.patientvisit where (VoluntaryWalkOut) 
  is not null) a group by visitnumber,facilitycode) t on stg.patientvisit.VisitNumber = t.visitnumber and stg.patientvisit.visitrownumber = t.visitrownumber
and stg.patientvisit.facilitycode = t.FacilityCode
/*(VoluntaryWalkOutReason) */
left outer join (select visitnumber, facilitycode, max(visitrownumber) as visitrownumber from (select visitnumber, facilitycode, visitrownumber, (VoluntaryWalkOutReason) 
 from stg.patientvisit where (VoluntaryWalkOutReason) 
  is not null) a group by visitnumber,facilitycode) u on stg.patientvisit.VisitNumber = u.visitnumber and stg.patientvisit.visitrownumber = u.visitrownumber
and stg.patientvisit.facilitycode = c.FacilityCode
/*(ArrivedBy) */
left outer join (select visitnumber,facilitycode,  min(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, (ArrivedBy) 
 from stg.patientvisit where (ArrivedBy) 
  is not null) a group by visitnumber,facilitycode) v on stg.patientvisit.VisitNumber = v.visitnumber and stg.patientvisit.visitrownumber = v.visitrownumber
and stg.patientvisit.facilitycode = v.FacilityCode
/*(BP) */
left outer join (select visitnumber,facilitycode,  min(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, (BP) 
 from stg.patientvisit where (BP) 
  is not null) a group by visitnumber,facilitycode) w on stg.patientvisit.VisitNumber = w.visitnumber and stg.patientvisit.visitrownumber = w.visitrownumber
and stg.patientvisit.facilitycode = w.FacilityCode
/*(DangerVS) */
left outer join (select visitnumber, facilitycode, min(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, (DangerVS) 
 from stg.patientvisit where (DangerVS) 
  is not null) a group by visitnumber,facilitycode) x on stg.patientvisit.VisitNumber = x.visitnumber and stg.patientvisit.visitrownumber = x.visitrownumber
  and stg.patientvisit.facilitycode = x.FacilityCode
/*(ESI)  */
left outer join (select visitnumber,facilitycode,  min(visitrownumber) as visitrownumber from (select visitnumber, facilitycode, visitrownumber,(ESI) 
 from stg.patientvisit where (ESI) 
  is not null) a group by visitnumber,facilitycode) y on stg.patientvisit.VisitNumber = y.visitnumber and stg.patientvisit.visitrownumber = y.visitrownumber
and stg.patientvisit.facilitycode = y.FacilityCode
/*(Language)  */
left outer join (select visitnumber,facilitycode,  min(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, (Language) 
 from stg.patientvisit where (Language)  
  is not null) a group by visitnumber,facilitycode) z on stg.patientvisit.VisitNumber = z.visitnumber and stg.patientvisit.visitrownumber = z.visitrownumber
and stg.patientvisit.facilitycode = z.FacilityCode
/*(LifeSaving) */
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, (LifeSaving) 
 from stg.patientvisit where (LifeSaving) 
  is not null) a group by visitnumber,facilitycode) aa on stg.patientvisit.VisitNumber = aa.visitnumber and stg.patientvisit.visitrownumber = aa.visitrownumber
and stg.patientvisit.facilitycode = aa.FacilityCode
/*(Medications) */
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, (Medications) 
 from stg.patientvisit where (Medications) 
  is not null) a group by visitnumber,facilitycode) ab on stg.patientvisit.VisitNumber = ab.visitnumber and stg.patientvisit.visitrownumber = ab.visitrownumber
and stg.patientvisit.facilitycode = ab.FacilityCode
/*(PainLevel) */
left outer join (select visitnumber, facilitycode, max(visitrownumber) as visitrownumber from (select visitnumber,FacilityCode, visitrownumber, (PainLevel) 
 from stg.patientvisit where (PainLevel) 
  is not null) a group by visitnumber,facilitycode) ac on stg.patientvisit.VisitNumber = ac.visitnumber and stg.patientvisit.visitrownumber = ac.visitrownumber
and stg.patientvisit.facilitycode = ac.FacilityCode
/*(RapidHIV) */
left outer join (select visitnumber, facilitycode, max(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, (RapidHIV) 
 from stg.patientvisit where (RapidHIV) 
  is not null) a group by visitnumber,facilitycode) ad on stg.patientvisit.VisitNumber = ad.visitnumber and stg.patientvisit.visitrownumber = ad.visitrownumber
and stg.patientvisit.facilitycode = ad.FacilityCode
/*(Resources) */
left outer join (select visitnumber, facilitycode, min(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, (Resources) 
 from stg.patientvisit where (Resources) 
  is not null) a group by visitnumber,facilitycode) ae on stg.patientvisit.VisitNumber = ae.visitnumber and stg.patientvisit.visitrownumber = ae.visitrownumber
and stg.patientvisit.facilitycode = ae.FacilityCode
/*(Destination) */
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, (Destination) 
 from stg.patientvisit where (Destination) 
  is not null) a group by visitnumber,facilitycode) af on stg.patientvisit.VisitNumber = af.visitnumber and stg.patientvisit.visitrownumber = af.visitrownumber
and stg.patientvisit.facilitycode = af.FacilityCode
/*(PatientLocation) */
left outer join (select visitnumber, facilitycode, max(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, (PatientLocation) 
 from stg.patientvisit where (PatientLocation) 
  <> '') a group by visitnumber,facilitycode) afpl on stg.patientvisit.VisitNumber = afpl.visitnumber and stg.patientvisit.visitrownumber = afpl.visitrownumber
and stg.patientvisit.facilitycode = afpl.FacilityCode
/*(TeamAssignment) */
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber, facilitycode,visitrownumber, (TeamAssignment) 
 from stg.patientvisit where (TeamAssignment) 
  is not null) a group by visitnumber,facilitycode) ag on stg.patientvisit.VisitNumber = ag.visitnumber and stg.patientvisit.visitrownumber = ag.visitrownumber
and stg.patientvisit.facilitycode = ag.FacilityCode
/*(OnetoOneHugs) */
left outer join (select visitnumber,facilitycode,  min(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, (OnetoOneHugs) 
 from stg.patientvisit where (OnetoOneHugs) 
  is not null) a group by visitnumber,facilitycode) ah on stg.patientvisit.VisitNumber = ah.visitnumber and stg.patientvisit.visitrownumber = ah.visitrownumber
and stg.patientvisit.facilitycode = ah.FacilityCode
/*CurrentNurse */
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber, facilitycode,visitrownumber, (Nurse) 
 from stg.patientvisit where (Nurse) 
  is not null) a group by visitnumber,facilitycode) ai on stg.patientvisit.VisitNumber = ai.visitnumber and stg.patientvisit.visitrownumber = ai.visitrownumber
  and stg.patientvisit.facilitycode = ai.FacilityCode
  /*CurrentAttending  */
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, (Attending) 
 from stg.patientvisit where (Attending) 
  is not null) a group by visitnumber,facilitycode) aj on stg.patientvisit.VisitNumber = aj.visitnumber and stg.patientvisit.visitrownumber = aj.visitrownumber
  and stg.patientvisit.facilitycode = aj.FacilityCode
  /*CurrentProvider */
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, (Provider) 
 from stg.patientvisit where (Provider) 
  is not null) a group by visitnumber,facilitycode) ak on stg.patientvisit.VisitNumber = ak.visitnumber and stg.patientvisit.visitrownumber = ak.visitrownumber
 and stg.patientvisit.facilitycode = ak.FacilityCode
/*FirstNurse */
left outer join (select visitnumber,facilitycode,  min(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, (Nurse) 
 from stg.patientvisit where (Nurse) 
  is not null) a group by visitnumber,facilitycode) al on stg.patientvisit.VisitNumber = al.visitnumber and stg.patientvisit.visitrownumber = al.visitrownumber
   and stg.patientvisit.facilitycode = al.FacilityCode
  /*FirstAttending  */
left outer join (select visitnumber,facilitycode,  min(visitrownumber) as visitrownumber from (select visitnumber, facilitycode, visitrownumber, (Attending) 
 from stg.patientvisit where (Attending) 
  is not null) a group by visitnumber,facilitycode) am on stg.patientvisit.VisitNumber = am.visitnumber and stg.patientvisit.visitrownumber = am.visitrownumber
 and stg.patientvisit.facilitycode = am.FacilityCode
  /*FirstProvider */
left outer join (select visitnumber,facilitycode,  min(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, (Provider) 
 from stg.patientvisit where (Provider) 
  is not null) a group by visitnumber,facilitycode) an on stg.patientvisit.VisitNumber = an.visitnumber and stg.patientvisit.visitrownumber = an.visitrownumber
 and stg.patientvisit.facilitycode = an.FacilityCode 
 
  /*(AdmissionBedType)  */
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, (AdmissionBedType) 
 from stg.patientvisit where (AdmissionBedType) 
  is not null) a group by visitnumber,facilitycode) ao on stg.patientvisit.VisitNumber = ao.visitnumber and stg.patientvisit.visitrownumber = ao.visitrownumber
   and stg.patientvisit.facilitycode = ao.FacilityCode
  /*(AdmissionLocation) */
left outer join (select visitnumber, facilitycode, max(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, (AdmissionLocation) 
 from stg.patientvisit where (AdmissionLocation) 
  is not null) a group by visitnumber,facilitycode) ap on stg.patientvisit.VisitNumber = ap.visitnumber and stg.patientvisit.visitrownumber = ap.visitrownumber
  and stg.patientvisit.facilitycode = ap.FacilityCode
  /*(Condition) */
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber, facilitycode, visitrownumber, (Condition) 
 from stg.patientvisit where (Condition) 
  is not null) a group by visitnumber,facilitycode) aq on stg.patientvisit.VisitNumber = aq.visitnumber and stg.patientvisit.visitrownumber = aq.visitrownumber
  and stg.patientvisit.facilitycode = aq.FacilityCode
  /*(Diagnosis) */
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber, facilitycode, visitrownumber, (Diagnosis) 
 from stg.patientvisit where (Diagnosis) 
  is not null) a group by visitnumber,facilitycode) au on stg.patientvisit.VisitNumber = au.visitnumber and stg.patientvisit.visitrownumber = au.visitrownumber
    and stg.patientvisit.facilitycode = au.FacilityCode
    /*(Disposition) */
left outer join (select visitnumber,facilitycode,  min(visitrownumber) as visitrownumber from (select visitnumber, facilitycode, visitrownumber, (Disposition) 
 from stg.patientvisit where (Disposition) 
  is not null) a group by visitnumber,facilitycode) ar on stg.patientvisit.VisitNumber = ar.visitnumber and stg.patientvisit.visitrownumber = ar.visitrownumber
   and stg.patientvisit.facilitycode = ar.FacilityCode
    /*(ExpiredDT) */
left outer join (select visitnumber, facilitycode, min(visitrownumber) as visitrownumber from (select visitnumber, facilitycode, visitrownumber, (ExpiredDT) 
 from stg.patientvisit where (ExpiredDT) 
  is not null) a group by visitnumber,facilitycode) at on stg.patientvisit.VisitNumber = at.visitnumber and stg.patientvisit.visitrownumber = at.visitrownumber
 and stg.patientvisit.facilitycode = at.FacilityCode
 /*Destination Lookup*/
 left outer join lkp.DestinationGroup dg
 on stg.patientvisit.Destination = dg.destination and stg.patientvisit.FacilityCode = dg.FacilityCode
 and stg.patientvisit.facilitycode = dg.FacilityCode 
 
 --where stg.patientvisit.VisitNumber = '1175045-81'
  
) a
GROUP BY FacilityCode,		MRN,	VisitNumber
HAVING MAX(EDVisitOpenDT) is not null 


GO


