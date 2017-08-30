USE [EDDashboard]
GO

/****** Object:  View [dbo].[PatientVisitHistory]    Script Date: 4/28/2017 10:23:32 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE view [dbo].[PatientVisitHistory]  AS

WITH
tmp_Table as
(
SELECT b.DateHour
	 , CASE
		   WHEN (DocumentationDT) IS NULL
			   THEN
			   (EventDT)
		   ELSE
			   (DocumentationDT)
	   END
	   AS WSMessageReceivedDT
	 , stg.patientvisithistory.FacilityCode
	 , MRN
	 , stg.patientvisithistory.VisitNumber
	 , CASE
		   WHEN (SourceMessageType) LIKE 'ADT^A%' THEN
			   sourcemessagetype
		   ELSE
			   EventType
	   END AS eventtype
	 , CASE
		   WHEN stg.patientvisithistory.visitrownumber = c.visitrownumber THEN
			   (PatientName)
	   END AS PatientName
	 , CASE
		   WHEN stg.patientvisithistory.visitrownumber = d.visitrownumber THEN
			   (Cliniccode)
	   END AS ClinicCode
	 , CASE
		   WHEN stg.patientvisithistory.visitrownumber = e.visitrownumber THEN
			   (Sex)
	   END AS Sex
	 , CASE
		   WHEN stg.patientvisithistory.visitrownumber = f.visitrownumber THEN
			   (DOB)
	   END AS DOB
	 , CASE
		   WHEN (EventType) = 'Pt Arrival' THEN
			   (CASE
					WHEN (DocumentationDT) IS NULL THEN
						(EventDT)
					ELSE
						(DocumentationDT)
				END)
		   ELSE
			   NULL
	   END AS PatientArrivalDT
	 , CASE
		   WHEN (SourceMessageType) = 'ADT^A04' THEN
			   (CASE
					WHEN (DocumentationDT) IS NULL THEN
						(EventDT)
					ELSE
						(DocumentationDT)
				END)
		   ELSE
			   NULL
	   END AS EDVisitOpenDT
	 , CASE
		   WHEN (EventType) = 'Triage' THEN
			   (CASE
					WHEN (DocumentationDT) IS NULL THEN
						(EventDT)
					ELSE
						(DocumentationDT)
				END)
		   ELSE
			   NULL
	   END AS TriageDT
	 , CASE
		   WHEN (EventType) = 'Designation' THEN
			   (CASE
					WHEN (DocumentationDT) IS NULL THEN
						(EventDT)
					ELSE
						(DocumentationDT)
				END)
		   ELSE
			   NULL
	   END AS DesignationDT
	 , ----FIX FIRST PROVIDER ASSIGNMENT
	   --case when( (SourceMessageType) = 'ADT^A08'and eventreason = 'Physician Change') or  (EventType) IN('Provider Assignment' , 'Claim Pt')	then (case when (DocumentationDT)IS null then  (EventDT) else  (DocumentationDT)  end)else null end AS FirstProviderAssignmentDT,
	   CASE
		   WHEN stg.patientvisithistory.visitrownumber = fpd.visitrownumber AND
			   ((SourceMessageType) = 'ADT^A08' AND eventreason = 'Physician Change') OR (EventType) IN ('Provider Assignment', 'Claim Pt') THEN
			   (CASE
					WHEN (DocumentationDT) IS NULL THEN
						(EventDT)
					ELSE
						(DocumentationDT)
				END)
		   ELSE
			   NULL
	   END AS FirstProviderAssignmentDT
	   , CASE
			 WHEN ((SourceMessageType) = 'ADT^A08' AND eventreason = 'Physician Change') OR (EventType) IN ('Provider Assignment', 'Claim Pt') THEN
				 (CASE
					  WHEN (DocumentationDT) IS NULL THEN
						  (EventDT)
					  ELSE
						  (DocumentationDT)
				  END)
			 ELSE
				 NULL
		 END AS CurrentProviderAssignmentDT
	   , CASE
			 WHEN (EventType) = 'Disposition' AND Disposition IS NOT NULL THEN
				 (CASE
					  WHEN (DocumentationDT) IS NULL THEN
						  (EventDT)
					  ELSE
						  (DocumentationDT)
				  END)
			 ELSE
				 NULL
		 END AS DispositionDT
	   , --case when (EventType) = 'Pt Exit'	then (case when (DocumentationDT)IS null then  (EventDT) else  (DocumentationDT)  end) else null end AS PtExitDT,
		 CASE
			 WHEN ((EventType = 'Pt Exit') OR (SourceMessageType IN ('ADT^A03', 'ADT^A11')))
				 THEN
				 (CASE
					  WHEN (DocumentationDT) IS NULL THEN
						  (EventDT)
					  ELSE
						  (DocumentationDT)
				  END)
			 ELSE
				 NULL
		 END AS PtExitDT
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = g.visitrownumber THEN
				 (AssignedWaitingArea)
		 END AS AssignedWaitingArea
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = h.visitrownumber THEN
				 (EDReentry)
		 END AS EDReentry
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = i.visitrownumber THEN
				 PatientComplaint
		 END AS Patientcomplaint
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = j.visitrownumber THEN
				 (Pretriagepriority)
		 END AS Pretriagepriority
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = k.visitrownumber THEN
				 (UndoLastPtExit)
		 END AS UndoLastPtExit
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = l.visitrownumber THEN
				 (WhiteBoardReEntered)
		 END AS WhiteBoardReEntered
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = m.visitrownumber THEN
				 (ChiefComplaint)
		 END AS ChiefComplaint
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = n.visitrownumber THEN
				 (FirstNoAns)
		 END AS FirstNoAns
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = o.visitrownumber THEN
				 (SecondNoAns)
		 END AS SecondNoAns
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = p.visitrownumber THEN
				 (ThirdNoAns)
		 END AS ThirdNoAns
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = q.visitrownumber THEN
				 (RecallReq)
		 END AS RecallReq
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = s.visitrownumber THEN
				 (VWNAEventType)
		 END AS VWNAEventType
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = t.visitrownumber THEN
				 (VoluntaryWalkOut)
		 END AS VoluntaryWalkOut
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = u.visitrownumber THEN
				 (VoluntaryWalkOutReason)
		 END AS VoluntaryWalkOutReason
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = v.visitrownumber THEN
				 (ArrivedBy)
		 END AS ArrivedBy
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = w.visitrownumber THEN
				 (BP)
		 END AS BP
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = x.visitrownumber THEN
				 (DangerVS)
		 END AS DangerVS
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = y.visitrownumber THEN
				 (ESI)
		 END AS ESI
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = z.visitrownumber THEN
				 (Language)
		 END AS Language
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = aa.visitrownumber THEN
				 (LifeSaving)
		 END AS LifeSaving
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = ab.visitrownumber THEN
				 (Medications)
		 END AS Medications
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = ac.visitrownumber THEN
				 (PainLevel)
		 END AS PainLevel
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = ad.visitrownumber THEN
				 (RapidHIV)
		 END AS RapidHIV
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = ae.visitrownumber THEN
				 (Resources)
		 END AS Resources
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = afpl.visitrownumber
				 THEN
				 stg.patientvisithistory.patientlocation
			 ELSE
				 NULL
		 END AS PatientLocation
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = af.visitrownumber THEN
				 (stg.patientvisithistory.Destination)
			 ELSE
				 NULL
		 END AS Destination
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = ag.visitrownumber THEN
				 (TeamAssignment)
		 END AS TeamAssignment
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = ah.visitrownumber THEN
				 (OnetoOneHugs)
		 END AS OnetoOneHugs
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = ai.visitrownumber THEN
				 (Nurse)
			 ELSE
				 NULL
		 END AS CurrentNurse
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = aj.visitrownumber THEN
				 (Attending)
			 ELSE
				 NULL
		 END AS CurrentAttending
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = ak.visitrownumber THEN
				 (Provider)
			 ELSE
				 NULL
		 END AS CurrentProvider
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = al.visitrownumber THEN
				 (Nurse)
			 ELSE
				 NULL
		 END AS FirstNurse
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = am.visitrownumber THEN
				 (Attending)
			 ELSE
				 NULL
		 END AS FirstAttending
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = an.visitrownumber THEN
				 (Provider)
			 ELSE
				 NULL
		 END AS FirstProvider
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = ao.visitrownumber THEN
				 (AdmissionBedType)
		 END AS AdmissionBedType
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = ap.visitrownumber THEN
				 (AdmissionLocation)
		 END AS AdmissionLocation
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = aq.visitrownumber THEN
				 (Condition)
		 END AS Condition
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = au.visitrownumber THEN
				 (Diagnosis)
		 END AS Diagnosis
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = ar.visitrownumber THEN
				 (Disposition)
		 END AS Disposition
	   , CASE
			 WHEN stg.patientvisithistory.visitrownumber = at.visitrownumber THEN
				 (ExpiredDT)
		 END AS ExpiredDT

FROM
	stg.patientvisithistory
	/*PatientName*/
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , max(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , PatientName
						  FROM
							  stg.patientvisithistory
						  WHERE
							  PatientName IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) c
		ON stg.patientvisithistory.VisitNumber = c.visitnumber AND stg.patientvisithistory.visitrownumber = c.visitrownumber
		AND stg.patientvisithistory.facilitycode = c.FacilityCode
	/*Cliniccode*/
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , max(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , Cliniccode
						  FROM
							  stg.patientvisithistory
						  WHERE
							  Cliniccode IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) d
		ON stg.patientvisithistory.VisitNumber = d.visitnumber AND stg.patientvisithistory.visitrownumber = d.visitrownumber
		AND stg.patientvisithistory.facilitycode = d.FacilityCode
	/*Sex*/
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , max(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , Sex
						  FROM
							  stg.patientvisithistory
						  WHERE
							  Sex IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) e
		ON stg.patientvisithistory.VisitNumber = e.visitnumber AND stg.patientvisithistory.visitrownumber = e.visitrownumber
		AND stg.patientvisithistory.facilitycode = e.FacilityCode
	/*DOB*/
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , max(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , DOB
						  FROM
							  stg.patientvisithistory
						  WHERE
							  DOB IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) f
		ON stg.patientvisithistory.VisitNumber = f.visitnumber AND stg.patientvisithistory.visitrownumber = f.visitrownumber
		AND stg.patientvisithistory.facilitycode = f.FacilityCode
	/*AssignedWaitingArea*/
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , max(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , AssignedWaitingArea
						  FROM
							  stg.patientvisithistory
						  WHERE
							  AssignedWaitingArea IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) g
		ON stg.patientvisithistory.VisitNumber = g.visitnumber AND stg.patientvisithistory.visitrownumber = g.visitrownumber
		AND stg.patientvisithistory.facilitycode = g.FacilityCode
	/*EDReentry*/
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , max(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , EDReentry
						  FROM
							  stg.patientvisithistory
						  WHERE
							  EDReentry IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) h
		ON stg.patientvisithistory.VisitNumber = h.visitnumber AND stg.patientvisithistory.visitrownumber = h.visitrownumber
		AND stg.patientvisithistory.facilitycode = h.FacilityCode
	/*PatientComplaint*/
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , max(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , patientcomplaint
						  FROM
							  stg.patientvisithistory
						  WHERE
							  patientcomplaint IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) i
		ON stg.patientvisithistory.VisitNumber = i.visitnumber AND stg.patientvisithistory.visitrownumber = i.visitrownumber
		AND stg.patientvisithistory.facilitycode = i.FacilityCode
	/*Pretriagepriority*/
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , max(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , Pretriagepriority
						  FROM
							  stg.patientvisithistory
						  WHERE
							  Pretriagepriority IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) j
		ON stg.patientvisithistory.VisitNumber = j.visitnumber AND stg.patientvisithistory.visitrownumber = j.visitrownumber
		AND stg.patientvisithistory.facilitycode = j.FacilityCode
	/*UndoLastPtExit*/
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , max(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , UndoLastPtExit
						  FROM
							  stg.patientvisithistory
						  WHERE
							  UndoLastPtExit IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) k
		ON stg.patientvisithistory.VisitNumber = k.visitnumber AND stg.patientvisithistory.visitrownumber = k.visitrownumber
		AND stg.patientvisithistory.facilitycode = k.FacilityCode
	/*WhiteBoardReEntered*/
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , max(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , WhiteBoardReEntered
						  FROM
							  stg.patientvisithistory
						  WHERE
							  WhiteBoardReEntered IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) l
		ON stg.patientvisithistory.VisitNumber = l.visitnumber AND stg.patientvisithistory.visitrownumber = l.visitrownumber
		AND stg.patientvisithistory.facilitycode = l.FacilityCode
	/*ChiefComplaint*/
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , max(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , ChiefComplaint
						  FROM
							  stg.patientvisithistory
						  WHERE
							  ChiefComplaint IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) m
		ON stg.patientvisithistory.VisitNumber = m.visitnumber AND stg.patientvisithistory.visitrownumber = m.visitrownumber
		AND stg.patientvisithistory.facilitycode = m.FacilityCode
	/*FirstNoAns*/
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , max(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , FirstNoAns
						  FROM
							  stg.patientvisithistory
						  WHERE
							  FirstNoAns IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) n
		ON stg.patientvisithistory.VisitNumber = n.visitnumber AND stg.patientvisithistory.visitrownumber = n.visitrownumber
		AND stg.patientvisithistory.facilitycode = n.FacilityCode
	/*SecondNoAns*/
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , max(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , SecondNoAns
						  FROM
							  stg.patientvisithistory
						  WHERE
							  SecondNoAns IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) o
		ON stg.patientvisithistory.VisitNumber = o.visitnumber AND stg.patientvisithistory.visitrownumber = o.visitrownumber
		AND stg.patientvisithistory.facilitycode = o.FacilityCode
	/*ThirdNoAns*/
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , max(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , ThirdNoAns
						  FROM
							  stg.patientvisithistory
						  WHERE
							  ThirdNoAns IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) p
		ON stg.patientvisithistory.VisitNumber = p.visitnumber AND stg.patientvisithistory.visitrownumber = p.visitrownumber
		AND stg.patientvisithistory.facilitycode = p.FacilityCode
	/*(RecallReq) */
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , max(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , (RecallReq)

						  FROM
							  stg.patientvisithistory
						  WHERE
							  (RecallReq)
							  IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) q
		ON stg.patientvisithistory.VisitNumber = q.visitnumber AND stg.patientvisithistory.visitrownumber = q.visitrownumber
		AND stg.patientvisithistory.facilitycode = q.FacilityCode
	/*(VWNAEventType) */
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , max(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , (VWNAEventType)
						  FROM
							  stg.patientvisithistory
						  WHERE
							  (VWNAEventType)
							  IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) s
		ON stg.patientvisithistory.VisitNumber = s.visitnumber AND stg.patientvisithistory.visitrownumber = s.visitrownumber
		AND stg.patientvisithistory.facilitycode = s.FacilityCode
	/*(VoluntaryWalkOut) */
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , max(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , (VoluntaryWalkOut)
						  FROM
							  stg.patientvisithistory
						  WHERE
							  (VoluntaryWalkOut)
							  IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) t
		ON stg.patientvisithistory.VisitNumber = t.visitnumber AND stg.patientvisithistory.visitrownumber = t.visitrownumber
		AND stg.patientvisithistory.facilitycode = t.FacilityCode
	/*(VoluntaryWalkOutReason) */
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , max(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , (VoluntaryWalkOutReason)
						  FROM
							  stg.patientvisithistory
						  WHERE
							  (VoluntaryWalkOutReason)
							  IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) u
		ON stg.patientvisithistory.VisitNumber = u.visitnumber AND stg.patientvisithistory.visitrownumber = u.visitrownumber
		AND stg.patientvisithistory.facilitycode = c.FacilityCode
	/*(ArrivedBy) */
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , min(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , (ArrivedBy)
						  FROM
							  stg.patientvisithistory
						  WHERE
							  (ArrivedBy)
							  IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) v
		ON stg.patientvisithistory.VisitNumber = v.visitnumber AND stg.patientvisithistory.visitrownumber = v.visitrownumber
		AND stg.patientvisithistory.facilitycode = v.FacilityCode
	/*(BP) */
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , min(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , (BP)
						  FROM
							  stg.patientvisithistory
						  WHERE
							  (BP)
							  IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) w
		ON stg.patientvisithistory.VisitNumber = w.visitnumber AND stg.patientvisithistory.visitrownumber = w.visitrownumber
		AND stg.patientvisithistory.facilitycode = w.FacilityCode
	/*(DangerVS) */
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , min(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , (DangerVS)
						  FROM
							  stg.patientvisithistory
						  WHERE
							  (DangerVS)
							  IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) x
		ON stg.patientvisithistory.VisitNumber = x.visitnumber AND stg.patientvisithistory.visitrownumber = x.visitrownumber
		AND stg.patientvisithistory.facilitycode = x.FacilityCode
	/*(ESI)  */
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , min(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , (ESI)
						  FROM
							  stg.patientvisithistory
						  WHERE
							  (ESI)
							  IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) y
		ON stg.patientvisithistory.VisitNumber = y.visitnumber AND stg.patientvisithistory.visitrownumber = y.visitrownumber
		AND stg.patientvisithistory.facilitycode = y.FacilityCode
	/*(Language)  */
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , min(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , (Language)
						  FROM
							  stg.patientvisithistory
						  WHERE
							  (Language)
							  IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) z
		ON stg.patientvisithistory.VisitNumber = z.visitnumber AND stg.patientvisithistory.visitrownumber = z.visitrownumber
		AND stg.patientvisithistory.facilitycode = z.FacilityCode
	/*(LifeSaving) */
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , max(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , (LifeSaving)
						  FROM
							  stg.patientvisithistory
						  WHERE
							  (LifeSaving)
							  IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) aa
		ON stg.patientvisithistory.VisitNumber = aa.visitnumber AND stg.patientvisithistory.visitrownumber = aa.visitrownumber
		AND stg.patientvisithistory.facilitycode = aa.FacilityCode
	/*(Medications) */
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , max(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , (Medications)
						  FROM
							  stg.patientvisithistory
						  WHERE
							  (Medications)
							  IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) ab
		ON stg.patientvisithistory.VisitNumber = ab.visitnumber AND stg.patientvisithistory.visitrownumber = ab.visitrownumber
		AND stg.patientvisithistory.facilitycode = ab.FacilityCode
	/*(PainLevel) */
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , max(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , FacilityCode
							   , visitrownumber
							   , (PainLevel)
						  FROM
							  stg.patientvisithistory
						  WHERE
							  (PainLevel)
							  IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) ac
		ON stg.patientvisithistory.VisitNumber = ac.visitnumber AND stg.patientvisithistory.visitrownumber = ac.visitrownumber
		AND stg.patientvisithistory.facilitycode = ac.FacilityCode
	/*(RapidHIV) */
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , max(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , (RapidHIV)
						  FROM
							  stg.patientvisithistory
						  WHERE
							  (RapidHIV)
							  IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) ad
		ON stg.patientvisithistory.VisitNumber = ad.visitnumber AND stg.patientvisithistory.visitrownumber = ad.visitrownumber
		AND stg.patientvisithistory.facilitycode = ad.FacilityCode
	/*(Resources) */
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , min(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , (Resources)
						  FROM
							  stg.patientvisithistory
						  WHERE
							  (Resources)
							  IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) ae
		ON stg.patientvisithistory.VisitNumber = ae.visitnumber AND stg.patientvisithistory.visitrownumber = ae.visitrownumber
		AND stg.patientvisithistory.facilitycode = ae.FacilityCode
	/*(Destination) */
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , max(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , (Destination)
						  FROM
							  stg.patientvisithistory
						  WHERE
							  (Destination)
							  IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) af
		ON stg.patientvisithistory.VisitNumber = af.visitnumber AND stg.patientvisithistory.visitrownumber = af.visitrownumber
		AND stg.patientvisithistory.facilitycode = af.FacilityCode
	/*(PatientLocation) */
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , max(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , (PatientLocation)
						  FROM
							  stg.patientvisit
						  WHERE
							  (PatientLocation)
							  <> '') a
					 GROUP BY
						 visitnumber
					   , facilitycode) afpl
		ON stg.patientvisithistory.VisitNumber = afpl.visitnumber AND stg.patientvisithistory.visitrownumber = afpl.visitrownumber
		AND stg.patientvisithistory.facilitycode = afpl.FacilityCode
	/*(TeamAssignment) */
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , max(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , (TeamAssignment)
						  FROM
							  stg.patientvisithistory
						  WHERE
							  (TeamAssignment)
							  IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) ag
		ON stg.patientvisithistory.VisitNumber = ag.visitnumber AND stg.patientvisithistory.visitrownumber = ag.visitrownumber
		AND stg.patientvisithistory.facilitycode = ag.FacilityCode
	/*(OnetoOneHugs) */
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , min(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , (OnetoOneHugs)
						  FROM
							  stg.patientvisithistory
						  WHERE
							  (OnetoOneHugs)
							  IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) ah
		ON stg.patientvisithistory.VisitNumber = ah.visitnumber AND stg.patientvisithistory.visitrownumber = ah.visitrownumber
		AND stg.patientvisithistory.facilitycode = ah.FacilityCode
	/*CurrentNurse */
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , max(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , (Nurse)
						  FROM
							  stg.patientvisithistory
						  WHERE
							  (Nurse)
							  IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) ai
		ON stg.patientvisithistory.VisitNumber = ai.visitnumber AND stg.patientvisithistory.visitrownumber = ai.visitrownumber
		AND stg.patientvisithistory.facilitycode = ai.FacilityCode
	/*CurrentAttending  */
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , max(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , (Attending)
						  FROM
							  stg.patientvisithistory
						  WHERE
							  (Attending)
							  IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) aj
		ON stg.patientvisithistory.VisitNumber = aj.visitnumber AND stg.patientvisithistory.visitrownumber = aj.visitrownumber
		AND stg.patientvisithistory.facilitycode = aj.FacilityCode
	/*CurrentProvider */
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , max(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , (Provider)
						  FROM
							  stg.patientvisithistory
						  WHERE
							  (Provider)
							  IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) ak
		ON stg.patientvisithistory.VisitNumber = ak.visitnumber AND stg.patientvisithistory.visitrownumber = ak.visitrownumber
		AND stg.patientvisithistory.facilitycode = c.FacilityCode
	/*FirstNurse */
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , min(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , (Nurse)
						  FROM
							  stg.patientvisithistory
						  WHERE
							  (Nurse)
							  IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) al
		ON stg.patientvisithistory.VisitNumber = al.visitnumber AND stg.patientvisithistory.visitrownumber = al.visitrownumber
		AND stg.patientvisithistory.facilitycode = al.FacilityCode
	/*FirstAttending  */
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , min(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , (Attending)
						  FROM
							  stg.patientvisithistory
						  WHERE
							  (Attending)
							  IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) am
		ON stg.patientvisithistory.VisitNumber = am.visitnumber AND stg.patientvisithistory.visitrownumber = am.visitrownumber
		AND stg.patientvisithistory.facilitycode = am.FacilityCode
	/*FirstProvider */
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , min(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , (Provider)
						  FROM
							  stg.patientvisithistory
						  WHERE
							  (Provider)
							  IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) an
		ON stg.patientvisithistory.VisitNumber = an.visitnumber AND stg.patientvisithistory.visitrownumber = an.visitrownumber
		AND stg.patientvisithistory.facilitycode = an.FacilityCode

	/*(AdmissionBedType)  */
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , max(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , (AdmissionBedType)
						  FROM
							  stg.patientvisithistory
						  WHERE
							  (AdmissionBedType)
							  IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) ao
		ON stg.patientvisithistory.VisitNumber = ao.visitnumber AND stg.patientvisithistory.visitrownumber = ao.visitrownumber
		AND stg.patientvisithistory.facilitycode = ao.FacilityCode
	/*(AdmissionLocation) */
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , max(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , (AdmissionLocation)
						  FROM
							  stg.patientvisithistory
						  WHERE
							  (AdmissionLocation)
							  IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) ap
		ON stg.patientvisithistory.VisitNumber = ap.visitnumber AND stg.patientvisithistory.visitrownumber = ap.visitrownumber
		AND stg.patientvisithistory.facilitycode = ap.FacilityCode
	/*(Condition) */
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , max(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , (Condition)
						  FROM
							  stg.patientvisithistory
						  WHERE
							  (Condition)
							  IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) aq
		ON stg.patientvisithistory.VisitNumber = aq.visitnumber AND stg.patientvisithistory.visitrownumber = aq.visitrownumber
		AND stg.patientvisithistory.facilitycode = aq.FacilityCode
	/*(Diagnosis) */
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , max(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , (Diagnosis)
						  FROM
							  stg.patientvisithistory
						  WHERE
							  (Diagnosis)
							  IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) au
		ON stg.patientvisithistory.VisitNumber = au.visitnumber AND stg.patientvisithistory.visitrownumber = au.visitrownumber
		AND stg.patientvisithistory.facilitycode = au.FacilityCode
	/*(Disposition) */
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , min(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , (Disposition)
						  FROM
							  stg.patientvisithistory
						  WHERE
							  (Disposition)
							  IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) ar
		ON stg.patientvisithistory.VisitNumber = ar.visitnumber AND stg.patientvisithistory.visitrownumber = ar.visitrownumber
		AND stg.patientvisithistory.facilitycode = ar.FacilityCode
	/*(ExpiredDT) */
	LEFT OUTER JOIN (SELECT visitnumber
						  , facilitycode
						  , min(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , (ExpiredDT)
						  FROM
							  stg.patientvisithistory
						  WHERE
							  (ExpiredDT)
							  IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) at
		ON stg.patientvisithistory.VisitNumber = at.visitnumber AND stg.patientvisithistory.visitrownumber = at.visitrownumber
		AND stg.patientvisithistory.facilitycode = at.FacilityCode
	/*Destination Lookup*/
	LEFT OUTER JOIN lkp.DestinationGroup dg
		ON stg.patientvisithistory.Destination = dg.destination AND stg.patientvisithistory.FacilityCode = dg.FacilityCode
		AND stg.patientvisithistory.facilitycode = dg.FacilityCode
	/*FirstProviderDT*/
	LEFT OUTER JOIN (
					 SELECT visitnumber
						  , facilitycode
						  , min(visitrownumber) AS visitrownumber
					 FROM
						 (SELECT visitnumber
							   , facilitycode
							   , visitrownumber
							   , CASE
									 WHEN ((SourceMessageType) = 'ADT^A08' AND eventreason = 'Physician Change')
										 OR (EventType) IN ('Provider Assignment', 'Claim Pt')
										 THEN
										 (CASE
											  WHEN (DocumentationDT) IS NULL THEN
												  (EventDT)
											  ELSE
												  (DocumentationDT)
										  END)
									 ELSE
										 NULL
								 END AS FirstProviderDT
						  FROM
							  stg.patientvisithistory
						  WHERE
							  CASE
								  WHEN ((SourceMessageType) = 'ADT^A08'
									  AND eventreason = 'Physician Change')
									  OR (EventType) IN ('Provider Assignment', 'Claim Pt')
									  THEN
									  (CASE
										   WHEN (DocumentationDT) IS NULL THEN
											   (EventDT)
										   ELSE
											   (DocumentationDT)
									   END)
								  ELSE
									  NULL
							  END IS NOT NULL) a
					 GROUP BY
						 visitnumber
					   , facilitycode) fpd
		ON stg.patientvisithistory.VisitNumber = fpd.visitnumber AND
		stg.patientvisithistory.visitrownumber = fpd.visitrownumber AND stg.patientvisithistory.FacilityCode = fpd.FacilityCode


	/*DateHour*/

	LEFT OUTER JOIN dim.Time b
		ON
		CASE
			WHEN (DocumentationDT) IS NULL THEN
				(EventDT)
			ELSE
				(DocumentationDT)
		END = b.date

		--Comment out when done testing
		 --where stg.patientvisithistory.VisitNumber = '1114922-3'

		 )

	 SELECT -- TOP 100 PERCENT 
	 					FacilityCode
						  , MRN
						  , VisitNumber
						  , Datehour
						  , max(PatientName) AS PatientName
						  , max(ClinicCode) AS ClinicCode
						  , max(Sex) AS Sex
						  , max(DOB) AS DOB
						  , max(PatientArrivalDT) AS PatientArrivalDT
						  , min(EDVisitOpenDT) AS EDVisitOpenDT
						  , min(TriageDT) AS TriageDT
						  , min(DesignationDT) AS DesignationDT
						  , min(firstProviderAssignmentDT) AS FirstProviderAssignmentDT
						  , max(CurrentProviderAssignmentDT) AS CurrentProviderAssignmentDT
						  , min(DispositionDT) AS DispositionDT
						  , min(PtExitDT) AS PtExitDT
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
						  , min(BP) AS BP
						  , min(DangerVS) AS DangerVS
						  , min(ESI) AS ESI
						  , min(Language) AS Language
						  , min(LifeSaving) AS LifeSaving
						  , max(Medications) AS Medications
						  , max(PainLevel) AS PainLevel
						  , max(RapidHIV) AS RapidHIV
						  , min(Resources) AS Resources
						  , CASE
								WHEN max(PatientLocation) IS NOT NULL THEN
									max(PatientLocation)
								ELSE
									max(Destination)
							END AS Destination
						  , max(TeamAssignment) AS TeamAssignment
						  , min(OnetoOneHugs) AS OnetoOneHugs
						  , max(currentNurse) AS CurrentNurse
						  , max(currentAttending) AS CurrentAttending
						  , max(currentProvider) AS CurrentProvider
						  , min(firstNurse) AS FirstNurse
						  , min(firstAttending) AS FirstAttending
						  , min(firstProvider) AS FirstProvider
						  , max(AdmissionBedType) AS AdmissionBedType
						  , max(AdmissionLocation) AS AdmissionLocation
						  , max(Condition) AS Condition
						  , max(Diagnosis) AS Diagnosis
						  , min(Disposition) AS Disposition
						  , min(ExpiredDT) AS ExpiredDT
						  , sum(CASE
									WHEN eventtype IN ('ADT^A03', 'ADT^A11') THEN
										1
									ELSE
										0
								END) AS ADT03
						  , CASE
								WHEN min(PtExitDT) IS NOT NULL OR datediff(HOUR, min(EDVisitOpenDT), GETDATE()) >= 72 OR CASE
																															 WHEN max(PatientLocation) IS NOT NULL THEN
																																 max(PatientLocation)
																															 ELSE
																																 max(Destination)
																														 END IN
									(SELECT destination
									 FROM
										 lkp.destinationgroup
									 WHERE
										 DestinationGroup IN ('Psych', 'OB', 'CPEP', 'BH', 'GYN', '19W', 'EW'))
									OR sum(CASE
											   WHEN eventtype IN ('ADT^A03', 'ADT^A11') THEN
												   1
											   ELSE
												   0
										   END) > 0
									THEN
									'Patient Exited'
								WHEN min(VWNAEventType) = 'Voluntary Exit' OR
									min(ThirdNoAns) IS NOT NULL OR
									min(VoluntaryWalkout) IN ('Yes', 'Patient voluntarily left the ED', 'Voluntary Exit') OR min(disposition) = 'Left Without Being Seen' THEN
									'LWBS'
								WHEN min(EDVisitOpenDT) IS NOT NULL AND min(TriageDT) IS NULL AND min(FirstProviderAssignmentDT) IS NULL AND min(DispositionDT) IS NULL AND min(ptexitdt) IS NULL THEN
									'Waiting for Triage'
								WHEN min(TriageDT) IS NOT NULL AND min(FirstProviderAssignmentDT) IS NULL AND min(DispositionDT) IS NULL AND min(ptexitdt) IS NULL THEN
									'Waiting for Provider'
								WHEN min(FirstProviderAssignmentDT) IS NOT NULL AND min(DispositionDT) IS NULL AND min(ptexitdt) IS NULL THEN
									'In Treatment'
								WHEN min(DispositionDT) IS NOT NULL AND min(PtExitDT) IS NULL THEN
									'Dwelling'
								ELSE
									NULL
							END AS CurrentEventState
						  , CASE
								WHEN facilitycode + min(cliniccode) IN (SELECT facilitycode + ClinicCode
																		FROM
																			lkp.ClinicCodeGroup
																		WHERE
																			ClinicCodeColumn = 'AdultPedsInd'
																			AND cliniccodegroup = 'Peds'
																			AND NRTHistorical = 'Historical')
									THEN
									'Peds'
								WHEN facilitycode + min(cliniccode) IN (SELECT facilitycode + ClinicCode
																		FROM
																			lkp.ClinicCodeGroup
																		WHERE
																			ClinicCodeColumn = 'AdultPedsInd'
																			AND cliniccodegroup = 'Adult'
																			AND NRTHistorical = 'Historical')
									THEN
									'Adult'
								ELSE
									'Other'
							END AS AdultPedsInd
						  , CASE
								WHEN min(AssignedWaitingArea) = 'Urgent Care' THEN
									'Fast Track'		--Fast Track replaced Urgent Care per request from Marie Holness (LHC) 02/23/2015 Vinesh Nair
								WHEN min(AssignedWaitingArea) = 'Internal' THEN
									'Internal'
								WHEN min(AssignedWaitingArea) = 'PEDS' OR facilitycode + min(cliniccode) IN (SELECT facilitycode + ClinicCode
																											 FROM
																												 lkp.ClinicCodeGroup
																											 WHERE
																												 ClinicCodeColumn = 'AdultPedsInd'
																												 AND cliniccodegroup = 'Peds'
																												 AND NRTHistorical = 'Historical') THEN
									'Peds'
								WHEN min(AssignedWaitingArea) = 'Main Adult ED' OR facilitycode + min(cliniccode) IN (SELECT facilitycode + ClinicCode
																													  FROM
																														  lkp.ClinicCodeGroup
																													  WHERE
																														  ClinicCodeColumn = 'AdultPedsInd'
																														  AND cliniccodegroup = 'Adult'
																														  AND NRTHistorical = 'Historical') THEN
									'Adult'
								ELSE
									'Other'
							END AS TriageAdultPedsInd




	 FROM
		 tmp_Table a

	 GROUP BY
		 FacilityCode
	   , VisitNumber
	   , DateHour
	   , MRN
/* top 100 %
	 ORDER BY
		 FacilityCode
	   , visitnumber
	   , datehour
*/


GO


