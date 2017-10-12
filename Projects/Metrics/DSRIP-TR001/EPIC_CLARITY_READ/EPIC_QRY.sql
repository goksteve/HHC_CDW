WITH
  PatientData AS
  (
    SELECT
      PATIENT.PAT_ID, PATIENT.PAT_NAME, ID_EMPI.IDENTITY_ID AS MRN_EMPI
    FROM PATIENT
    --Filter: Remove any test patients --
    INNER JOIN PATIENT_3 ON PATIENT.PAT_ID = PATIENT_3.PAT_ID AND PATIENT_3.IS_TEST_PAT_YN = 'N'
    LEFT JOIN identity_id id_empi ON PATIENT.PAT_ID = ID_EMPI.PAT_ID AND ID_EMPI.IDENTITY_TYPE_ID = 10014 --10014=EMPI
  )
select   
  PatientData.mrn_EMPI,  
  Patient.PAT_NAME PATIENT_NAME,
  Format(patient.BIRTH_DATE, 'MM/dd/yyyy') PATIENT_DOB, 
  COALESCE(IDENTITY_ID_LOC.IDENTITY_ID, IDENTITY_ID_ENT.IDENTITY_ID, PATIENT.PAT_MRN_ID) AS MRN,
  PAT_ENC_HSP.PAT_ENC_CSN_ID VISIT_ID,
  PCP_Prov.PROV_NAME PRIM_CARE_PROVIDER,
  CLARITY_LOC.LOC_NAME HOSPITALIZATION_FACILITY,
  pat_enc_Hsp.HOSP_ADMSN_TIME ADMISSION_DT,
  PAT_ENC_HSP.HOSP_DISCH_TIME DISCHARGE_DT,
  OutPsych.pat_enc_csn_ID FOLLOW_UP_VISIT_ID ,
  Format(OutPsych.CONTACT_DATE, 'MM/dd/yyyy') FOLLOW_UP_DT,
  Outpsychloc.LOC_NAME FOLLOW_UP_FACILITY, 
  OutPsychDept.department_name Followup_Department,
  visit_prov.PROV_NAME FollowupProvName,
  visit_Prov.PROV_TYPE FollowupProvType,
  ZC_SPECIALTY.name FollowupProvSpeciality,
  PayorPivot.Payor1,
  PayorPivot.Payor2,
  PayorPivot.Payor3,
  case
   when Datediff(d,PAT_ENC_HSP.HOSP_DISCH_TIME,lastfollowupdadate.ContactDate) <8 
    then Format(lastfollowupdadate.ContactDate, 'MM/dd/yyyy') 
  end as "7-day-follow-up",
  case
   when Datediff(d,PAT_ENC_HSP.HOSP_DISCH_TIME,lastfollowupdadate.ContactDate) <31 
    then Format(lastfollowupdadate.ContactDate, 'MM/dd/yyyy')
  end as "30-day-follow-up",
  PayorPivot.PayorpatID,
  PATIENT.Pat_ID
from
  PAT_ENC_HSP
  LEFT JOIN CLARITY_DEp on PAT_ENC_HSP.DEPARTMENT_ID = clarity_dep.DEPARTMENT_ID
  LEFT JOIN PAT_ENC_DX on PAT_ENC_HSP.pat_enc_csn_ID = PAT_ENC_DX.PAT_ENC_CSN_ID and PAt_Enc_Dx.PRIMARY_DX_YN = 'Y'
  LEFT JOIN CLARITY_EDG on PAT_ENC_DX.Dx_ID = CLARITY_EDG.Dx_ID
  LEFT JOIN PATIENT ON PAT_ENC_HSP.PAT_ID = PATIENT.PAT_ID
  INNER JOIN PatientData ON PAT_ENC_HSP.PAT_ID = PatientData.PAT_ID
  Left join
  (
    select pvt.PAT_ID as PayorpatID, pvt."1" as Payor1, pvt."2" as Payor2, Pvt."3" as Payor3
    from 
    (
      Select  PAT_PERM_CMTS.PAT_ID, PAT_PERM_CMTS.line, PAT_PERM_CMTS.PERM_CMT
      from PAT_PERM_CMTS
    ) payorpivot 
    Pivot 
    (
      min(payorpivot.PERM_CMT) 
      for payorpivot.line In (1,2,3)  
    ) pvt 
  ) PayorPivot on patient.PAT_ID = PayorPivot.PayorpatID
  LEFT JOIN V_PAT_FACT age on PATIENT.PAT_ID=age.PAT_ID
  LEFT JOIN CLARITY_LOC ON CLARITY_DEP.REV_LOC_ID = CLARITY_LOC.LOC_ID 
  LEFT JOIN IDENTITY_ID IDENTITY_ID_LOC ON PAT_ENC_HSP.PAT_ID = IDENTITY_ID_LOC.PAT_ID AND IDENTITY_ID_LOC.IDENTITY_TYPE_ID = CLARITY_LOC.ID_TYPE
  LEFT JOIN IDENTITY_ID IDENTITY_ID_ENT ON PAT_ENC_HSP.PAT_ID = IDENTITY_ID_ENT.PAT_ID AND IDENTITY_ID_ENT.IDENTITY_TYPE_ID = 0 -- Enterprise ID
  outer apply 
  (
    select top 1 
      pat_enc.contact_date,
      PAT_ENC.PAT_ENC_CSN_ID,
      PAT_ENC.ENC_TYPE_C,
      CLARITY_DEP.DEPARTMENT_ID,
      Pat_enc.PCP_PROV_ID,
      PAT_ENC.VISIT_PROV_ID,
      pat_enc.APPT_STATUS_C
    from PAT_ENC 
    inner join CLARITY_DEP
       on PAT_ENC.DEPARTMENT_ID = CLARITY_DEP.DEPARTMENT_ID
      AND CLARITY_DEP.SPECIALTY_DEP_C IN ('37','75','79','176','102305') 
    where pat_enc.PAT_ID = patient.PAT_ID
    and PAT_ENC_HSP.HOSP_DISCH_TIME < PAT_ENC.CONTACT_DATE
    and PAT_ENC.ENC_TYPE_C  <> 50
    and pat_enc.APPT_STATUS_C = 2 
    order by pat_enc.contact_date asc
  ) As OutPsych 
  LEFT JOIN CLARITY_SER PCP_Prov on Patient.CUR_PCP_PROV_ID = PCP_PROv.prov_ID
  LEFT JOIN ZC_DISP_ENC_TYPE on OutPsych.ENC_TYPE_C = ZC_DISP_ENC_TYPE.DISP_ENC_TYPE_C 
  LEFT JOIN CLARITY_SER visit_Prov on OutPsych.VISIT_PROV_ID = visit_Prov.PROV_ID 
  LEFT JOIN CLARITY_SER_SPEC on visit_Prov.PROV_ID = CLARITY_SER_SPEC.PROV_ID and CLARITY_SER_SPEC.LINE = 1
  LEFT JOIN ZC_SPECIALTY on CLARITY_SER_SPEC.SPECIALTY_C = ZC_SPECIALTY.SPECIALTY_C 
  left join CLARITY_DEp as OutPsychDept on OutPsych.DEPARTMENT_ID = OutPsychDept.DEPARTMENT_ID
  LEFT JOIN CLARITY_LOC as Outpsychloc ON OutPsychDept.REV_LOC_ID = Outpsychloc.LOC_ID
  LEFT JOIN PAT_ENC_2 on OutPsych.pat_enc_CSN_ID = pat_enc_2.pat_enc_CSN_ID 
  LEFT JOIN ZC_PAT_CLASS on PAT_ENC_2.ADT_PAT_CLASS_C = ZC_PAT_CLASS.ADT_PAT_CLASS_C
  outer apply
  (
    select top 1
      pat_enc.contact_date ContactDate
      ,PAT_ENC.PAT_ENC_CSN_ID
      ,PAT_ENC.ENC_TYPE_C
      ,CLARITY_DEP.DEPARTMENT_ID
      ,pat_enc.appt_status_c
    from PAT_ENC 
    inner join CLARITY_DEP
       on PAT_ENC.DEPARTMENT_ID = CLARITY_DEP.DEPARTMENT_ID
      AND CLARITY_DEP.SPECIALTY_DEP_C IN ('37','75','79','176','102305') 
    where pat_enc.PAT_ID = patient.PAT_ID
    and PAT_ENC_HSP.HOSP_DISCH_TIME < PAT_ENC.CONTACT_DATE
    and PAT_ENC.ENC_TYPE_C  <> 50
    and Datediff(d,PAT_ENC_HSP.HOSP_DISCH_TIME,Pat_Enc.CONTACT_DATE) <31
    and pat_enc.APPT_STATUS_C = 2 
    order by pat_enc.contact_date desc
  ) as  lastfollowupdadate 
where (PAT_ENC_HSP.HOSP_DISCH_TIME >= EPIC_UTIL.EFN_DIN('mb-2') AND PAT_ENC_HSP.HOSP_DISCH_TIME < EPIC_UTIL.EFN_DIN('me-2') + 1) 
And (PATIENT.PAT_NAME Not LIKE 'TEST,%' and PATIENT.PAT_NAME NOT LIKE 'zzz%' and PATIENT.PAT_NAME NOT LIKE '%,test')
and 
(
  Clarity_EDG.CURRENT_ICD10_LIST in
  (
    'F20.0', 'F29', 'F30.10', 'F30.11', 'F30.12', 'F30.13', 'F30.2', 'F30.3', 'F30.4', 'F30.8', 'F30.9', 'F31.0', 'F31.10', 'F31.11', 'F31.12', 'F31.13', 'F31.2', 'F31.30', 'F31.31', 'F31.32', 'F31.4', 'F31.5','F31.60', 'F31.61',
    'F31.62', 'F31.63', 'F31.64', 'F31.70', 'F31.71', 'F31.72', 'F31.73', 'F31.74', 'F31.75', 'F31.76', 'F31.77', 'F31.78', 'F31.81', 'F31.89', 'F31.9', 'F32.0', 'F32.1', 'F32.2', 'F32.3', 'F32.4', 'F32.5', 'F32.8', 'F32.9', 'F33.0', 'F33.1', 'F33.2', 
    'F33.3', 'F33.40', 'F33.41', 'F33.42', 'F33.8', 'F33.9', 'F34.0', 'F34.1', 'F34.8', 'F34.9', 'F39', 'F42', 'F43.0', 'F43.10', 'F43.11', 'F43.12', 'F43.20', 'F43.21', 'F43.22', 'F43.23', 'F43.24', 'F43.25', 'F43.29', 'F43.8', 'F43.9', 
    'F44.89', 'F53', 'F60.0', 'F60.1', 'F60.2', 'F60.3', 'F60.4', 'F60.5', 'F60.6', 'F60.7', 'F60.81', 'F60.89', 'F60.9', 'F63.0', 'F63.1', 'F63.2', 'F63.3','F63.81', 'F63.89', 'F63.9', 'F68.10', 'F68.11', 'F68.12', 'F68.13', 'F68.8', 'F84.0',
    'F84.2', 'F84.3', 'F84.5', 'F84.8', 'F84.9', 'F90.0', 'F90.1', 'F90.2', 'F90.8', 'F90.9', 'F91.0', 'F91.1','F91.2', 'F91.3', 'F91.8', 'F91.9', 'F93.0', 'F93.8', 'F93.9', 'F94.0', 'F94.1','F94.2', 'F94.8', 'F94.9'
  )
  Or Clarity_edg.CURRENT_ICD9_LIST in 
  (
    '295.00','295.01','295.02','295.03','295.04','295.05','295.10','295.11','295.12','295.13','295.14','295.15','295.20',
    '295.21','295.22','295.23','295.24','295.25','295.30','295.31','295.32','295.33','295.34','295.35','295.40','295.41',
    '295.42','295.43','295.44','295.45','295.50','295.51','295.52','295.53','295.54','295.55','295.60','295.61','295.62',
    '295.63','295.64','295.65','295.70','295.71','295.72','295.73','295.74','295.75','295.80','295.81','295.82','295.83',
    '295.84','295.85','295.90','295.91','295.92','295.93','295.94','295.95','296.00','296.01','296.02','296.03','296.04',
    '296.05','296.06','296.10','296.11','296.12','296.13','296.14','296.15','296.16','296.20','296.21','296.22','296.23',
    '296.24','296.25','296.26','296.30','296.31','296.32','296.33','296.34','296.35','296.36','296.40','296.41','296.42',
    '296.43','296.44','296.45','296.46','296.50','296.51','296.52','296.53','296.54','296.55','296.56','296.60','296.61',
    '296.62','296.63','296.64','296.65','296.66','296.7','296.80','296.81','296.82','296.89','296.90','296.99','297.0',
    '297.1','297.2','297.3','297.8','297.9','298.0','298.1','298.2','298.3','298.4','298.8','298.9','299.00','299.01',
    '299.10','299.11','299.80','299.81','299.90','299.91','300.3','300.4','301.0','301.10','301.11','301.12','301.13',
    '301.20','301.21','301.22','301.3','301.4','301.50','301.51','301.59','301.6','301.7','301.81','301.82','301.83',
    '301.84','301.89','301.9','308.0','308.1','308.2','308.3','308.4','308.9','309.0','309.1','309.21','309.22','309.23',
    '309.24','309.28','309.29','309.3','309.4','309.81','309.82','309.83','309.89','309.9','311','312.00','312.01','312.02',
    '312.03','312.10','312.11','312.12','312.13','312.20','312.21','312.22','312.23','312.30','312.31','312.32','312.33',
    '312.34','312.35','312.39','312.4','312.81','312.82','312.89','312.9','313.0','313.1','313.21','313.22','313.23',
    '313.3','313.81','313.82','313.83','313.89','313.9','314.00','314.01','314.1','314.2','314.8','314.9'
  )
)
and age.AGE_YEARS > 6
and PAT_ENC_HSP.HOSP_DISCH_TIME is not null
and pat_enc_2.adt_pat_class_c = 102 
Order by PAT_ENC_HSP.HOSP_DISCH_TIME;
