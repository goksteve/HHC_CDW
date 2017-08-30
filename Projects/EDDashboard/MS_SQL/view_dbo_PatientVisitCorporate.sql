CREATE VIEW  [dbo].[patientvisitcorporate] as
Select
  FacilityCode,		MRN,	VisitNumber,
  max (PatientName) as PatientName,	
  max(ClinicCode) as ClinicCode,	
  max(Sex) as Sex,	
  max(DOB) as DOB ,	
  max(PatientArrivalDT) as PatientArrivalDT,
  min(EDVisitOpenDT) as EDVisitOpenDT,	
  min(TriageDT) as TriageDT,	
  min(DesignationDT) as DesignationDT,	
  min(firstProviderAssignmentDT) as FirstProviderAssignmentDT,
  max(CurrentProviderAssignmentDT) as CurrentProviderAssignmentDT,
  min(DispositionDT) as DispositionDT,
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
  max(TeamAssignment) as TeamAssignment ,	
  min(OnetoOneHugs) as OnetoOneHugs,	
  max(currentNurse)	 as CurrentNurse,
  max(currentAttending)	 as CurrentAttending,
  max(currentProvider) as CurrentProvider,	
  min(firstNurse)	 as FirstNurse,
  min(firstAttending)	 as FirstAttending,
  min(firstProvider) as FirstProvider,
  min(AdmissionBedType) as AdmissionBedType,
  min(AdmissionLocation) as AdmissionLocation,	
  max(Condition) as Condition,	
  max(Diagnosis) as Diagnosis,	
  min(Disposition) as Disposition,	
  min(ExpiredDT) as ExpiredDT,
  case
    when min(PtExitDT) IS not null
      or datediff(hour,min(EDVisitOpenDT) ,GETDATE()) >= 72 
      or case when max(PatientLocation) IS not null  then max(PatientLocation) else max(Destination) end
          in 
          (
            select destination from lkp.destinationgroup 
            where DestinationGroup IN ('Psych','OB', 'CPEP','BH','GYN','19W','EW')
          )
      OR  sum(case when eventtype IN('ADT^A03','ADT^A11') then 1 else 0 end) > 0 
    then 'Patient Exited'
    when min(VWNAEventType) = 'Voluntary Exit'
      or min(ThirdNoAns) is not null
      OR min(VoluntaryWalkout) IN ( 'Yes', 'Patient voluntarily left the ED','Voluntary Exit')
      OR min(disposition) = 'Left Without Being Seen'
     then 'LWBS'
    when min(EDVisitOpenDT) IS not null and min(TriageDT) IS null and min(FirstProviderAssignmentDT) IS null and min(DispositionDT) is null and min(ptexitdt) is null
     then 'Waiting for Triage'
    when min(TriageDT) IS not null and min(FirstProviderAssignmentDT) IS null and  min(DispositionDT) is null and min(ptexitdt) IS null
     then 'Waiting for Provider'
    when min(FirstProviderAssignmentDT) IS not null and min(DispositionDT) IS null  and min(ptexitdt) is null
     then 'In Treatment'
    when min(DispositionDT)  IS not null and min(PtExitDT) IS Null
     then 'Dwelling'
    else NULL
  end as CurrentEventState,
  CASE
    WHEN facilitycode + min(cliniccode) IN 
    (
      select facilitycode+ClinicCode 
      from lkp.ClinicCodeGroup 
      where ClinicCodeColumn = 'AdultPedsInd' 
      and cliniccodegroup = 'Peds' 
      and NRTHistorical = 'NRT'
    ) then 'Peds'
    WHEN facilitycode +  min(cliniccode) IN
    (
      select facilitycode + ClinicCode 
      from lkp.ClinicCodeGroup 
      where ClinicCodeColumn = 'AdultPedsInd'
      and cliniccodegroup = 'Adult'
      and NRTHistorical = 'NRT'
    ) THEN 'Adult' 
    ELSE 'Other'
  end as AdultPedsInd,
  CASE
    WHEN min(AssignedWaitingArea)  = 'Urgent Care' then 'Fast Track'
    WHEN min(AssignedWaitingArea) = 'Internal' then 'Internal'
    WHEN min(AssignedWaitingArea) = 'PEDS' or facilitycode + min(cliniccode) IN
    (
      select facilitycode + ClinicCode
      from lkp.ClinicCodeGroup
      where ClinicCodeColumn = 'AdultPedsInd'
      and cliniccodegroup = 'Peds'
      and NRTHistorical = 'NRT'
    ) then 'Peds'
    WHEN min(AssignedWaitingArea) = 'Main Adult ED'
      OR facilitycode + min(cliniccode) IN
      (
        select facilitycode + ClinicCode
        from lkp.ClinicCodeGroup
        where ClinicCodeColumn = 'AdultPedsInd'
        and cliniccodegroup = 'Adult'
        and NRTHistorical = 'NRT'
      ) THEN 'Adult'
    ELSE 'Other'
  end as TriageAdultPedsInd
from
(
  SELECT      
    stg.patientvisitcorporate.FacilityCode,  
    MRN, 
    stg.patientvisitcorporate.VisitNumber, 
    case when (SourceMessageType) like 'ADT^A%'then  sourcemessagetype else EventType end as eventtype, 
    case when stg.patientvisitcorporate.visitrownumber = c.visitrownumber then(PatientName) end as PatientName, 
    case when stg.patientvisitcorporate.visitrownumber = d.visitrownumber then(Cliniccode) end as ClinicCode, 
    case when stg.patientvisitcorporate.visitrownumber = e.visitrownumber then(Sex) end as Sex, 
    case when stg.patientvisitcorporate.visitrownumber = f.visitrownumber then(DOB) end as DOB,
    case when (EventType) = 'Pt Arrival'	then (case when (DocumentationDT)IS null then  (EventDT) else  (DocumentationDT)  end)else null end as PatientArrivalDT,
    case when (SourceMessageType) = 'ADT^A04'	then (case when (DocumentationDT)IS null then  (EventDT) else  (DocumentationDT)  end) else null end as EDVisitOpenDT,
    case when (EventType) = 'Triage'	then (case when (DocumentationDT)IS null then  (EventDT) else  (DocumentationDT)  end)else null end as TriageDT,
    case
      when EventType = 'Designation'	then
        case when DocumentationDT IS null then EventDT else DocumentationDT end
      else null
    end as DesignationDT,
    case when( (SourceMessageType) = 'ADT^A08'and eventreason = 'Physician Change') or  (EventType) IN('Provider Assignment' , 'Claim Pt')	then (case when (DocumentationDT)IS null then  (EventDT) else  (DocumentationDT)  end)else null end as FirstProviderAssignmentDT,
    case when ((SourceMessageType) = 'ADT^A08'and eventreason = 'Physician Change') or (EventType) IN('Provider Assignment' , 'Claim Pt')	then (case when (DocumentationDT)IS null then  (EventDT) else  (DocumentationDT)  end)else null end as CurrentProviderAssignmentDT,
    case
      when EventType = 'Disposition'	then
        case when DocumentationDT IS null then EventDT else DocumentationDT end
      else null
    end as DispositionDT,
    case when ((EventType = 'Pt Exit') OR (SourceMessageType IN('ADT^A03','ADT^A11')))
    then (case when (DocumentationDT)IS null then  (EventDT) else  (DocumentationDT)  end) else null end as PtExitDT,
    case when stg.patientvisitcorporate.visitrownumber = g.visitrownumber then(AssignedWaitingArea) end as AssignedWaitingArea, 
    case when stg.patientvisitcorporate.visitrownumber = h.visitrownumber then(EDReentry) end as EDReentry, 
    case when stg.patientvisitcorporate.visitrownumber = i.visitrownumber then  PatientComplaint  end as Patientcomplaint,
    case when stg.patientvisitcorporate.visitrownumber = j.visitrownumber then(Pretriagepriority) end as Pretriagepriority, 
    case when stg.patientvisitcorporate.visitrownumber = k.visitrownumber then(UndoLastPtExit) end as UndoLastPtExit, 
    case when stg.patientvisitcorporate.visitrownumber = l.visitrownumber then(WhiteBoardReEntered) end as WhiteBoardReEntered, 
    case when stg.patientvisitcorporate.visitrownumber = m.visitrownumber then (ChiefComplaint) end as ChiefComplaint, 
    case when stg.patientvisitcorporate.visitrownumber = n.visitrownumber then(FirstNoAns) end as FirstNoAns, 
    case when stg.patientvisitcorporate.visitrownumber = o.visitrownumber then(SecondNoAns) end as SecondNoAns, 
    case when stg.patientvisitcorporate.visitrownumber = p.visitrownumber then(ThirdNoAns) end as ThirdNoAns, 
    case when stg.patientvisitcorporate.visitrownumber = q.visitrownumber then (RecallReq) end AS RecallReq, 
    case when stg.patientvisitcorporate.visitrownumber = s.visitrownumber then (VWNAEventType) end AS VWNAEventType, 
    case when stg.patientvisitcorporate.visitrownumber = t.visitrownumber then (VoluntaryWalkOut) end AS VoluntaryWalkOut, 
    case when stg.patientvisitcorporate.visitrownumber = u.visitrownumber then (VoluntaryWalkOutReason) end AS VoluntaryWalkOutReason, 
    case when stg.patientvisitcorporate.visitrownumber = v.visitrownumber then (ArrivedBy) end AS ArrivedBy, 
    case when stg.patientvisitcorporate.visitrownumber = w.visitrownumber then (BP) end AS BP, 
    case when stg.patientvisitcorporate.visitrownumber = x.visitrownumber then (DangerVS) end AS DangerVS, 
    case when stg.patientvisitcorporate.visitrownumber = y.visitrownumber then (ESI) end AS ESI, 
    case when stg.patientvisitcorporate.visitrownumber = z.visitrownumber then (Language) end AS Language, 
    case when stg.patientvisitcorporate.visitrownumber = aa.visitrownumber then (LifeSaving) end AS LifeSaving, 
    case when stg.patientvisitcorporate.visitrownumber = ab.visitrownumber then (Medications) end AS Medications,
    case when stg.patientvisitcorporate.visitrownumber = ac.visitrownumber then (PainLevel) end AS PainLevel, 
    case when stg.patientvisitcorporate.visitrownumber = ad.visitrownumber then (RapidHIV) end AS RapidHIV, 
    case when stg.patientvisitcorporate.visitrownumber = ae.visitrownumber then (Resources) end AS Resources, 
    case when stg.patientvisitCorporate.visitrownumber = afpl.visitrownumber then stg.patientvisitCorporate.patientlocation else null end as PatientLocation,
    case when stg.patientvisitCorporate.visitrownumber = af.visitrownumber then stg.patientvisitCorporate.Destination else null end AS Destination, 
    case when stg.patientvisitcorporate.visitrownumber = ag.visitrownumber then (TeamAssignment) end AS TeamAssignment, 
    case when stg.patientvisitcorporate.visitrownumber = ah.visitrownumber then (OnetoOneHugs) end AS OnetoOneHugs, 
    case when  stg.patientvisitcorporate.visitrownumber = ai.visitrownumber  then (Nurse)else null end AS CurrentNurse, 
    case when  stg.patientvisitcorporate.visitrownumber = aj.visitrownumber then (Attending) else null end AS CurrentAttending, 
    case when  stg.patientvisitcorporate.visitrownumber = ak.visitrownumber then (Provider) else null end AS CurrentProvider, 
    case when  stg.patientvisitcorporate.visitrownumber = al.visitrownumber then (Nurse)else null end AS FirstNurse, 
    case when stg.patientvisitcorporate.visitrownumber = am.visitrownumber  then (Attending) else null end AS FirstAttending, 
    case when  stg.patientvisitcorporate.visitrownumber = an.visitrownumber then (Provider) else null end AS FirstProvider, 
    case when stg.patientvisitcorporate.visitrownumber = ao.visitrownumber then (AdmissionBedType) end AS AdmissionBedType, 
    case when stg.patientvisitcorporate.visitrownumber = ap.visitrownumber then (AdmissionLocation) end AS AdmissionLocation, 
    case when stg.patientvisitcorporate.visitrownumber = aq.visitrownumber then (Condition) end AS Condition, 
    case when stg.patientvisitcorporate.visitrownumber = au.visitrownumber then (Diagnosis) end AS Diagnosis, 
    case when stg.patientvisitcorporate.visitrownumber = ar.visitrownumber then (Disposition) end AS Disposition, 
    case when stg.patientvisitcorporate.visitrownumber = at.visitrownumber then (ExpiredDT) end AS ExpiredDT
  FROM stg.patientvisitcorporate
  left outer join
  ( /*PatientName*/
    select visitnumber, facilitycode, max(visitrownumber) as visitrownumber
    from
    (
      select visitnumber, facilitycode, visitrownumber, PatientName
      from stg.patientvisitcorporate
      where PatientName is not null
    ) 
    group by visitnumber, facilitycode
  ) c on stg.patientvisitcorporate.VisitNumber = c.visitnumber
    and stg.patientvisitcorporate.visitrownumber = c.visitrownumber
    and stg.patientvisitcorporate.facilitycode = c.FacilityCode
  left outer join
  ( /*Cliniccode*/
    select visitnumber, facilitycode, max(visitrownumber) as visitrownumber
    from
    (
      select visitnumber, facilitycode, visitrownumber, Cliniccode
      from stg.patientvisitcorporate where
      Cliniccode is not null
    ) 
    group by visitnumber, facilitycode
  ) d on stg.patientvisitcorporate.VisitNumber = d.visitnumber
    and stg.patientvisitcorporate.visitrownumber = d.visitrownumber
    and stg.patientvisitcorporate.facilitycode = d.FacilityCode
  left outer join
  ( /*Sex*/
    select visitnumber, facilitycode,  max(visitrownumber) as visitrownumber
    from
    (
      select visitnumber, facilitycode, visitrownumber, Sex
      from stg.patientvisitcorporate
      where Sex is not null
    ) 
    group by visitnumber,facilitycode
  ) e on stg.patientvisitcorporate.VisitNumber = e.visitnumber
    and stg.patientvisitcorporate.visitrownumber = e.visitrownumber
    and stg.patientvisitcorporate.facilitycode = e.FacilityCode
  left outer join
  ( /*DOB*/
    select visitnumber, facilitycode, max(visitrownumber) as visitrownumber
    from
    (
      select visitnumber, facilitycode, visitrownumber, DOB
      from stg.patientvisitcorporate
      where DOB is not null
    )
    group by visitnumber, facilitycode
  ) f on stg.patientvisitcorporate.VisitNumber = f.visitnumber
    and stg.patientvisitcorporate.visitrownumber = f.visitrownumber
    and stg.patientvisitcorporate.facilitycode = f.FacilityCode
  left outer join
  ( /*AssignedWaitingArea*/
    select visitnumber, facilitycode, max(visitrownumber) as visitrownumber
    from
    (
      select visitnumber, facilitycode, visitrownumber, AssignedWaitingArea
      from stg.patientvisitcorporate
      where AssignedWaitingArea is not null
    )
    group by visitnumber,facilitycode
  ) g on stg.patientvisitcorporate.VisitNumber = g.visitnumber
    and stg.patientvisitcorporate.visitrownumber = g.visitrownumber
    and stg.patientvisitcorporate.facilitycode = g.FacilityCode
/*EDReentry*/
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, EDReentry from stg.patientvisitcorporate where EDReentry is not null) a group by visitnumber,facilitycode) h on stg.patientvisitcorporate.VisitNumber = h.visitnumber and stg.patientvisitcorporate.visitrownumber = h.visitrownumber
and stg.patientvisitcorporate.facilitycode = h.FacilityCode
/*PatientComplaint*/
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, patientcomplaint from stg.patientvisitcorporate where patientcomplaint is not null) a group by visitnumber,facilitycode) i on stg.patientvisitcorporate.VisitNumber = i.visitnumber and stg.patientvisitcorporate.visitrownumber = i.visitrownumber
and stg.patientvisitcorporate.facilitycode = i.FacilityCode
/*Pretriagepriority*/
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, Pretriagepriority from stg.patientvisitcorporate where Pretriagepriority is not null) a group by visitnumber,facilitycode) j on stg.patientvisitcorporate.VisitNumber = j.visitnumber and stg.patientvisitcorporate.visitrownumber = j.visitrownumber
and stg.patientvisitcorporate.facilitycode = j.FacilityCode
/*UndoLastPtExit*/
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, UndoLastPtExit 
from stg.patientvisitcorporate where UndoLastPtExit is not null) a group by visitnumber,facilitycode) k on stg.patientvisitcorporate.VisitNumber = k.visitnumber and stg.patientvisitcorporate.visitrownumber = k.visitrownumber
and stg.patientvisitcorporate.facilitycode = k.FacilityCode
/*WhiteBoardReEntered*/
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from 
(select visitnumber, facilitycode, visitrownumber, WhiteBoardReEntered from stg.patientvisitcorporate where WhiteBoardReEntered is not null) a group by visitnumber,facilitycode) l on stg.patientvisitcorporate.VisitNumber = l.visitnumber and stg.patientvisitcorporate.visitrownumber = l.visitrownumber
and stg.patientvisitcorporate.facilitycode = l.FacilityCode
/*ChiefComplaint*/
left outer join (select visitnumber, facilitycode, max(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, ChiefComplaint from stg.patientvisitcorporate where ChiefComplaint is not null) a group by visitnumber,facilitycode) m on stg.patientvisitcorporate.VisitNumber = m.visitnumber and stg.patientvisitcorporate.visitrownumber = m.visitrownumber
and stg.patientvisitcorporate.facilitycode = m.FacilityCode
/*FirstNoAns*/
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber, facilitycode, visitrownumber, FirstNoAns from stg.patientvisitcorporate where FirstNoAns is not null) a group by visitnumber,facilitycode) n on stg.patientvisitcorporate.VisitNumber = n.visitnumber and stg.patientvisitcorporate.visitrownumber = n.visitrownumber
and stg.patientvisitcorporate.facilitycode = n.FacilityCode
/*SecondNoAns*/
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber, facilitycode, visitrownumber, SecondNoAns from stg.patientvisitcorporate where SecondNoAns is not null) a group by visitnumber,facilitycode) o on stg.patientvisitcorporate.VisitNumber = o.visitnumber and stg.patientvisitcorporate.visitrownumber = o.visitrownumber
and stg.patientvisitcorporate.facilitycode = o.FacilityCode
/*ThirdNoAns*/
left outer join (select visitnumber, facilitycode, max(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, ThirdNoAns from stg.patientvisitcorporate where ThirdNoAns is not null) a group by visitnumber,facilitycode) p on stg.patientvisitcorporate.VisitNumber = p.visitnumber and stg.patientvisitcorporate.visitrownumber = p.visitrownumber
and stg.patientvisitcorporate.facilitycode = p.FacilityCode
/*(RecallReq) */
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber, facilitycode, visitrownumber, (RecallReq)

  from stg.patientvisitcorporate where (RecallReq)
    is not null) a group by visitnumber,facilitycode) q on stg.patientvisitcorporate.VisitNumber = q.visitnumber and stg.patientvisitcorporate.visitrownumber = q.visitrownumber
and stg.patientvisitcorporate.facilitycode = q.FacilityCode
/*(VWNAEventType) */
left outer join (select visitnumber, facilitycode, max(visitrownumber) as visitrownumber from (select visitnumber, facilitycode, visitrownumber, (VWNAEventType) 
 from stg.patientvisitcorporate where (VWNAEventType) 
  is not null) a group by visitnumber,facilitycode) s on stg.patientvisitcorporate.VisitNumber = s.visitnumber and stg.patientvisitcorporate.visitrownumber = s.visitrownumber
and stg.patientvisitcorporate.facilitycode = s.FacilityCode
/*(VoluntaryWalkOut) */
left outer join (select visitnumber, facilitycode, max(visitrownumber) as visitrownumber from (select visitnumber, facilitycode, visitrownumber, (VoluntaryWalkOut) 
 from stg.patientvisitcorporate where (VoluntaryWalkOut) 
  is not null) a group by visitnumber,facilitycode) t on stg.patientvisitcorporate.VisitNumber = t.visitnumber and stg.patientvisitcorporate.visitrownumber = t.visitrownumber
and stg.patientvisitcorporate.facilitycode = t.FacilityCode
/*(VoluntaryWalkOutReason) */
left outer join (select visitnumber, facilitycode, max(visitrownumber) as visitrownumber from (select visitnumber, facilitycode, visitrownumber, (VoluntaryWalkOutReason) 
 from stg.patientvisitcorporate where (VoluntaryWalkOutReason) 
  is not null) a group by visitnumber,facilitycode) u on stg.patientvisitcorporate.VisitNumber = u.visitnumber and stg.patientvisitcorporate.visitrownumber = u.visitrownumber
and stg.patientvisitcorporate.facilitycode = c.FacilityCode
/*(ArrivedBy) */
left outer join (select visitnumber,facilitycode,  min(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, (ArrivedBy) 
 from stg.patientvisitcorporate where (ArrivedBy) 
  is not null) a group by visitnumber,facilitycode) v on stg.patientvisitcorporate.VisitNumber = v.visitnumber and stg.patientvisitcorporate.visitrownumber = v.visitrownumber
and stg.patientvisitcorporate.facilitycode = v.FacilityCode
/*(BP) */
left outer join (select visitnumber,facilitycode,  min(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, (BP) 
 from stg.patientvisitcorporate where (BP) 
  is not null) a group by visitnumber,facilitycode) w on stg.patientvisitcorporate.VisitNumber = w.visitnumber and stg.patientvisitcorporate.visitrownumber = w.visitrownumber
and stg.patientvisitcorporate.facilitycode = w.FacilityCode
/*(DangerVS) */
left outer join (select visitnumber, facilitycode, min(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, (DangerVS) 
 from stg.patientvisitcorporate where (DangerVS) 
  is not null) a group by visitnumber,facilitycode) x on stg.patientvisitcorporate.VisitNumber = x.visitnumber and stg.patientvisitcorporate.visitrownumber = x.visitrownumber
  and stg.patientvisitcorporate.facilitycode = x.FacilityCode
/*(ESI)  */
left outer join (select visitnumber,facilitycode,  min(visitrownumber) as visitrownumber from (select visitnumber, facilitycode, visitrownumber,(ESI) 
 from stg.patientvisitcorporate where (ESI) 
  is not null) a group by visitnumber,facilitycode) y on stg.patientvisitcorporate.VisitNumber = y.visitnumber and stg.patientvisitcorporate.visitrownumber = y.visitrownumber
and stg.patientvisitcorporate.facilitycode = y.FacilityCode
/*(Language)  */
left outer join (select visitnumber,facilitycode,  min(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, (Language) 
 from stg.patientvisitcorporate where (Language)  
  is not null) a group by visitnumber,facilitycode) z on stg.patientvisitcorporate.VisitNumber = z.visitnumber and stg.patientvisitcorporate.visitrownumber = z.visitrownumber
and stg.patientvisitcorporate.facilitycode = z.FacilityCode
/*(LifeSaving) */
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, (LifeSaving) 
 from stg.patientvisitcorporate where (LifeSaving) 
  is not null) a group by visitnumber,facilitycode) aa on stg.patientvisitcorporate.VisitNumber = aa.visitnumber and stg.patientvisitcorporate.visitrownumber = aa.visitrownumber
and stg.patientvisitcorporate.facilitycode = aa.FacilityCode
/*(Medications) */
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, (Medications) 
 from stg.patientvisitcorporate where (Medications) 
  is not null) a group by visitnumber,facilitycode) ab on stg.patientvisitcorporate.VisitNumber = ab.visitnumber and stg.patientvisitcorporate.visitrownumber = ab.visitrownumber
and stg.patientvisitcorporate.facilitycode = ab.FacilityCode
/*(PainLevel) */
left outer join (select visitnumber, facilitycode, max(visitrownumber) as visitrownumber from (select visitnumber,FacilityCode, visitrownumber, (PainLevel) 
 from stg.patientvisitcorporate where (PainLevel) 
  is not null) a group by visitnumber,facilitycode) ac on stg.patientvisitcorporate.VisitNumber = ac.visitnumber and stg.patientvisitcorporate.visitrownumber = ac.visitrownumber
and stg.patientvisitcorporate.facilitycode = ac.FacilityCode
/*(RapidHIV) */
left outer join (select visitnumber, facilitycode, max(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, (RapidHIV) 
 from stg.patientvisitcorporate where (RapidHIV) 
  is not null) a group by visitnumber,facilitycode) ad on stg.patientvisitcorporate.VisitNumber = ad.visitnumber and stg.patientvisitcorporate.visitrownumber = ad.visitrownumber
and stg.patientvisitcorporate.facilitycode = ad.FacilityCode
/*(Resources) */
left outer join (select visitnumber, facilitycode, min(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, (Resources) 
 from stg.patientvisitcorporate where (Resources) 
  is not null) a group by visitnumber,facilitycode) ae on stg.patientvisitcorporate.VisitNumber = ae.visitnumber and stg.patientvisitcorporate.visitrownumber = ae.visitrownumber
and stg.patientvisitcorporate.facilitycode = ae.FacilityCode
/*(Destination) */
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, (Destination) 
 from stg.patientvisitcorporate where (Destination) 
  is not null) a group by visitnumber,facilitycode) af on stg.patientvisitcorporate.VisitNumber = af.visitnumber and stg.patientvisitcorporate.visitrownumber = af.visitrownumber
and stg.patientvisitcorporate.facilitycode = af.FacilityCode
/*(PatientLocation) */
left outer join (select visitnumber, facilitycode, max(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, (PatientLocation) 
 from stg.patientvisit where (PatientLocation) 
  <> '') a group by visitnumber,facilitycode) afpl on stg.patientvisitcorporate.VisitNumber = afpl.visitnumber and stg.patientvisitcorporate.visitrownumber = afpl.visitrownumber
and stg.patientvisitcorporate.facilitycode = afpl.FacilityCode
/*(TeamAssignment) */
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber, facilitycode,visitrownumber, (TeamAssignment) 
 from stg.patientvisitcorporate where (TeamAssignment) 
  is not null) a group by visitnumber,facilitycode) ag on stg.patientvisitcorporate.VisitNumber = ag.visitnumber and stg.patientvisitcorporate.visitrownumber = ag.visitrownumber
and stg.patientvisitcorporate.facilitycode = ag.FacilityCode
/*(OnetoOneHugs) */
left outer join (select visitnumber,facilitycode,  min(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, (OnetoOneHugs) 
 from stg.patientvisitcorporate where (OnetoOneHugs) 
  is not null) a group by visitnumber,facilitycode) ah on stg.patientvisitcorporate.VisitNumber = ah.visitnumber and stg.patientvisitcorporate.visitrownumber = ah.visitrownumber
and stg.patientvisitcorporate.facilitycode = ah.FacilityCode
/*CurrentNurse */
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber, facilitycode,visitrownumber, (Nurse) 
 from stg.patientvisitcorporate where (Nurse) 
  is not null) a group by visitnumber,facilitycode) ai on stg.patientvisitcorporate.VisitNumber = ai.visitnumber and stg.patientvisitcorporate.visitrownumber = ai.visitrownumber
  and stg.patientvisitcorporate.facilitycode = ai.FacilityCode
  /*CurrentAttending  */
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, (Attending) 
 from stg.patientvisitcorporate where (Attending) 
  is not null) a group by visitnumber,facilitycode) aj on stg.patientvisitcorporate.VisitNumber = aj.visitnumber and stg.patientvisitcorporate.visitrownumber = aj.visitrownumber
  and stg.patientvisitcorporate.facilitycode = aj.FacilityCode
  /*CurrentProvider */
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, (Provider) 
 from stg.patientvisitcorporate where (Provider) 
  is not null) a group by visitnumber,facilitycode) ak on stg.patientvisitcorporate.VisitNumber = ak.visitnumber and stg.patientvisitcorporate.visitrownumber = ak.visitrownumber
 and stg.patientvisitcorporate.facilitycode = c.FacilityCode
/*FirstNurse */
left outer join (select visitnumber,facilitycode,  min(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, (Nurse) 
 from stg.patientvisitcorporate where (Nurse) 
  is not null) a group by visitnumber,facilitycode) al on stg.patientvisitcorporate.VisitNumber = al.visitnumber and stg.patientvisitcorporate.visitrownumber = al.visitrownumber
   and stg.patientvisitcorporate.facilitycode = al.FacilityCode
  /*FirstAttending  */
left outer join (select visitnumber,facilitycode,  min(visitrownumber) as visitrownumber from (select visitnumber, facilitycode, visitrownumber, (Attending) 
 from stg.patientvisitcorporate where (Attending) 
  is not null) a group by visitnumber,facilitycode) am on stg.patientvisitcorporate.VisitNumber = am.visitnumber and stg.patientvisitcorporate.visitrownumber = am.visitrownumber
 and stg.patientvisitcorporate.facilitycode = am.FacilityCode
  /*FirstProvider */
left outer join (select visitnumber,facilitycode,  min(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, (Provider) 
 from stg.patientvisitcorporate where (Provider) 
  is not null) a group by visitnumber,facilitycode) an on stg.patientvisitcorporate.VisitNumber = an.visitnumber and stg.patientvisitcorporate.visitrownumber = an.visitrownumber
 and stg.patientvisitcorporate.facilitycode = an.FacilityCode 
 
  /*(AdmissionBedType)  */
left outer join (select visitnumber,facilitycode,  min(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, (AdmissionBedType) 
 from stg.patientvisitcorporate where (AdmissionBedType) 
  is not null) a group by visitnumber,facilitycode) ao on stg.patientvisitcorporate.VisitNumber = ao.visitnumber and stg.patientvisitcorporate.visitrownumber = ao.visitrownumber
   and stg.patientvisitcorporate.facilitycode = ao.FacilityCode
  /*(AdmissionLocation) */
left outer join (select visitnumber, facilitycode, min(visitrownumber) as visitrownumber from (select visitnumber,facilitycode,  visitrownumber, (AdmissionLocation) 
 from stg.patientvisitcorporate where (AdmissionLocation) 
  is not null) a group by visitnumber,facilitycode) ap on stg.patientvisitcorporate.VisitNumber = ap.visitnumber and stg.patientvisitcorporate.visitrownumber = ap.visitrownumber
  and stg.patientvisitcorporate.facilitycode = ap.FacilityCode
  /*(Condition) */
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber, facilitycode, visitrownumber, (Condition) 
 from stg.patientvisitcorporate where (Condition) 
  is not null) a group by visitnumber,facilitycode) aq on stg.patientvisitcorporate.VisitNumber = aq.visitnumber and stg.patientvisitcorporate.visitrownumber = aq.visitrownumber
  and stg.patientvisitcorporate.facilitycode = aq.FacilityCode
  /*(Diagnosis) */
left outer join (select visitnumber,facilitycode,  max(visitrownumber) as visitrownumber from (select visitnumber, facilitycode, visitrownumber, (Diagnosis) 
 from stg.patientvisitcorporate where (Diagnosis) 
  is not null) a group by visitnumber,facilitycode) au on stg.patientvisitcorporate.VisitNumber = au.visitnumber and stg.patientvisitcorporate.visitrownumber = au.visitrownumber
    and stg.patientvisitcorporate.facilitycode = au.FacilityCode
    /*(Disposition) */
left outer join (select visitnumber,facilitycode,  min(visitrownumber) as visitrownumber from (select visitnumber, facilitycode, visitrownumber, (Disposition) 
 from stg.patientvisitcorporate where (Disposition) 
  is not null) a group by visitnumber,facilitycode) ar on stg.patientvisitcorporate.VisitNumber = ar.visitnumber and stg.patientvisitcorporate.visitrownumber = ar.visitrownumber
   and stg.patientvisitcorporate.facilitycode = ar.FacilityCode
    /*(ExpiredDT) */
left outer join (select visitnumber, facilitycode, min(visitrownumber) as visitrownumber from (select visitnumber, facilitycode, visitrownumber, (ExpiredDT) 
 from stg.patientvisitcorporate where (ExpiredDT) 
  is not null) a group by visitnumber,facilitycode) at on stg.patientvisitcorporate.VisitNumber = at.visitnumber and stg.patientvisitcorporate.visitrownumber = at.visitrownumber
 and stg.patientvisitcorporate.facilitycode = at.FacilityCode
 /*Destination Lookup*/
 left outer join lkp.DestinationGroup dg
 on stg.patientvisitcorporate.Destination = dg.destination and stg.patientvisitcorporate.FacilityCode = dg.FacilityCode
 and stg.patientvisitcorporate.facilitycode = dg.FacilityCode 
  
) a
GROUP BY FacilityCode,		MRN,	VisitNumber
HAving max(EDVisitOpenDT) is not null;