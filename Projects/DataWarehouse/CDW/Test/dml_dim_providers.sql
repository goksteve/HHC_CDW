/* Formatted on 2/5/2018 15:42:45 (QP5 v5.287) */
SELECT --       PROVIDER_SEQ.NEXTVAL PROVIDER_KEY,
  fi.source,
  fi.network,
  fi.provider_id,
  fi.provider_name,
  fi.title_id,
  fi.title_name,
  fi.title_prefix,
  fi.title_suffix,
  fi.physician_flag,
  fi.physician_group_id,
  fi.physician_group_name,
  fi.emp_id,
  fi.license,
  fi.social_security,
  fi.sdg_emp_no,
  fi.prac_npi,
  fi.npi,
  fi.license_exp_date,
  fi.physician_service_id,
  fi.physician_service_name,
  CASE
    WHEN INSTR(fi.physician_service_id,'|',1,1) > 0
    THEN SUBSTR (fi.physician_service_id,1,INSTR (fi.physician_service_id,'|',1,1)- 1)
    ELSE fi.physician_service_id
  END AS physician_service_id_1,
  CASE
    WHEN INSTR (fi.physician_service_name,'|',1,1) > 0
    THEN SUBSTR (fi.physician_service_name,1,INSTR (fi.physician_service_name,'|',1,1)- 1)
    ELSE fi.physician_service_name
  END AS physician_service_name_1,
  CASE
    WHEN INSTR (fi.physician_service_id,'|',1,1) > 0
    THEN 
      CASE
        WHEN INSTR (fi.physician_service_id,'|',1,2) > 0
        THEN SUBSTR (fi.physician_service_id,INSTR (fi.physician_service_id, '|') + 1,INSTR (fi.physician_service_id,'|',1,2)- INSTR (fi.physician_service_id, '|')- 1)
        ELSE SUBSTR (fi.physician_service_id,iNSTR (fi.physician_service_id,'|',1,1)+ 1, LENGTH (fi.physician_service_id)- INSTR (fi.physician_service_id,'|',1,1))
      END
    ELSE
      NULL
  END AS physician_service_id_2,
  CASE
    WHEN INSTR (fi.physician_service_id,'|',1,1) > 0
    THEN
      CASE
        WHEN INSTR(fi.physician_service_name,'|',1,2) > 0
        THEN SUBSTR(fi.physician_service_name,INSTR (fi.physician_service_name, '|') + 1,INSTR (fi.physician_service_name,'|',1,2)- INSTR (fi.physician_service_name, '|')- 1)
        ELSE SUBSTR (fi.physician_service_name,INSTR (fi.physician_service_name,'|',1,1)+ 1,LENGTH (fi.physician_service_name)- INSTR (fi.physician_service_name,'|',1,1))
      END          
    ELSE
      NULL
  END AS physician_service_name_2,
  CASE
    WHEN INSTR (fi.physician_service_name,'|',1,2) > 0
    THEN
      CASE
        WHEN INSTR (fi.physician_service_id,'|',1,3) > 0
        THEN SUBSTR (fi.physician_service_id,INSTR (fi.physician_service_id,'|',1,2)+ 1,INSTR (fi.physician_service_id,'|',1,3)- INSTR (fi.physician_service_id,'|',1,2)- 1)
        ELSE  SUBSTR (fi.physician_service_id, INSTR (fi.physician_service_id,'|',1, 2)+ 1, LENGTH (fi.physician_service_id)- INSTR (fi.physician_service_id,'|',1, 2))
      END
    ELSE
      NULL
  END AS physician_service_id_3,
  CASE
    WHEN INSTR (fi.physician_service_name,'|',1,2) > 0
    THEN
      CASE
        WHEN INSTR (fi.physician_service_name,'|',1,3) > 0
        THEN SUBSTR (fi.physician_service_name,INSTR (fi.physician_service_name,'|',1,2)+ 1,INSTR (fi.physician_service_name,'|',1,3)- INSTR (fi.physician_service_name,'|',1,2)- 1)
        ELSE SUBSTR (fi.physician_service_name,INSTR (fi.physician_service_name,'|',1,2)+ 1,LENGTH (fi.physician_service_name)- INSTR (fi.physician_service_name,'|',1,2))
      END
    ELSE
      NULL
  END AS physician_service_name_3,
  CASE
    WHEN INSTR (fi.physician_service_name,'|',1,3) > 0
    THEN
      CASE
        WHEN INSTR (fi.physician_service_id,'|',1,4) > 0
        THEN  SUBSTR (fi.physician_service_id,INSTR (fi.physician_service_id,'|',1,3)+ 1,INSTR (fi.physician_service_id,'|',1,4)- INSTR (fi.physician_service_id,'|',1, 3)- 1)
        ELSE SUBSTR (fi.physician_service_id,INSTR (fi.physician_service_id,'|',1,3)+ 1,LENGTH (fi.physician_service_id)- INSTR (fi.physician_service_id,'|',1,3))
      END
    ELSE
      NULL
  END AS physician_service_id_4,
  CASE
    WHEN INSTR (fi.physician_service_name,  '|',1,3) > 0 
    THEN
      CASE
        WHEN INSTR (fi.physician_service_name,'|',1,4) > 0
        THEN SUBSTR (fi.physician_service_name,INSTR (fi.physician_service_name,'|',1,3)+ 1,INSTR (fi.physician_service_name,'|',1,4)- INSTR (fi.physician_service_name,'|',1,3)- 1)
        ELSE SUBSTR (fi.physician_service_name,INSTR (fi.physician_service_name,'|',1,3)+ 1,LENGTH (fi.physician_service_name)- INSTR (fi.physician_service_name,'|',1,3))
      END
    ELSE
      NULL
    END AS physician_service_name_4,
  CASE
    WHEN INSTR (fi.physician_service_name,'|',1,4) > 0
    THEN  
      CASE
        WHEN INSTR (fi.physician_service_id,'|',1,5) > 0
        THEN SUBSTR (fi.physician_service_id,INSTR (fi.physician_service_id,'|',1,4)+ 1,INSTR (fi.physician_service_id,'|',1,5)- INSTR (fi.physician_service_id,'|',1,4)- 1)
        ELSE  SUBSTR (FI.PHYSICIAN_SERVICE_ID,INSTR (FI.PHYSICIAN_SERVICE_ID,'|',1,4)+ 1,LENGTH (FI.PHYSICIAN_SERVICE_ID)- INSTR (FI.PHYSICIAN_SERVICE_ID,'|',1,4))
      END
    ELSE
      NULL
  END AS PHYSICIAN_SERVICE_ID_5,
  CASE
    WHEN INSTR (FI.PHYSICIAN_SERVICE_NAME,'|',1,4) > 0
    THEN
      CASE
        WHEN INSTR (FI.PHYSICIAN_SERVICE_NAME,'|',1,5) > 0
        THEN SUBSTR (FI.PHYSICIAN_SERVICE_NAME,INSTR (FI.PHYSICIAN_SERVICE_NAME,'|',1,4)+ 1,INSTR (FI.PHYSICIAN_SERVICE_NAME,'|',1,5) - INSTR (FI.PHYSICIAN_SERVICE_NAME,'|',1,4)- 1)
        ELSE SUBSTR (FI.PHYSICIAN_SERVICE_NAME,INSTR (FI.PHYSICIAN_SERVICE_NAME,'|',1,4)+ 1,LENGTH (FI.PHYSICIAN_SERVICE_NAME)- INSTR (FI.PHYSICIAN_SERVICE_NAME,'|',1,4))
      END
    ELSE
      NULL
  END AS PHYSICIAN_SERVICE_NAME_5,
  1 AS CURRENT_FLAG,
  FI.LOAD_DATE,
  FI.EPIC_FLAG
FROM 
( 
  SELECT 
    DISTINCT SOURCE,
    NETWORK,
    PROVIDER_ID,
    PROVIDER_NAME,
    TITLE_ID,
    TITLE_NAME,
    TITLE_PREFIX,
    TITLE_SUFFIX,
    PHYSICIAN_FLAG,
    PHYSICIAN_GROUP_ID,
    PHYSICIAN_GROUP_NAME,
    EMP_ID,
    LICENSE,	
    SOCIAL_SECURITY,	
    SDG_EMP_NO,	
    PRAC_NPI,	
    NPI,	
    LICENSE_EXP_DATE,
    LISTAGG (PHYSICIAN_SERVICE_ID, '|') WITHIN GROUP (ORDER BY NETWORK,PROVIDER_ID, PHYSICIAN_SERVICE_ID) OVER (PARTITION BY NETWORK,PROVIDER_ID) AS PHYSICIAN_SERVICE_ID, LISTAGG (NAME, '|')
    WITHIN GROUP (ORDER BY NETWORK,PROVIDER_ID, PHYSICIAN_SERVICE_ID) OVER (PARTITION BY NETWORK,PROVIDER_ID) AS PHYSICIAN_SERVICE_NAME,
    ROW_NUMBER() OVER (PARTITION BY NETWORK,PROVIDER_ID ORDER BY NULL) AS RNK,
    EPIC_FLAG,
    LOAD_DATE
    FROM
    (
      WITH emp_prvdr_addtnl_dtls
      AS
      (
        SELECT * 
        FROM
        (
          SELECT 
            t1.emp_provider_id,
            t1.network, 
            case 
  when t2.external_number_id='2' then  'EMP_ID'
  when t2.external_number_id='4' then 'LICENSE'
  when t2.external_number_id='27' then 'SOCIAL_SECURITY'  
  when t2.external_number_id='29' then 'SDG_EMP_NO'
  when t2.external_number_id='36' then 'PRAC_NPI'
  when t2.external_number_id='39' then 'NPI'
  when t2.external_number_id='40' then 'LICENSE_EXP_DATE'
 
end External_number_type,
value
from emp_provider t1
join emp_facility_external_number t2 on t1.emp_provider_id=t2.emp_provider_id
where --t1.emp_provider_id=1004 and 
t1.network='CBN'
and 
case
  when t2.external_number_id='2' then 'EMP_ID' 
  when t2.external_number_id='4' then 'LICENSE'
  when t2.external_number_id='27' then 'SOCIAL_SECURITY'  
  when t2.external_number_id='29' then 'SDG_EMP_NO'
  when t2.external_number_id='36' then 'PRAC_NPI'
  when t2.external_number_id='39' then 'NPI'
  when t2.external_number_id='40' then 'LICENSE_EXP_DATE'
 
end is not null
)
pivot
(
max(value) for External_number_type in ('EMP_ID' EMP_ID, 'LICENSE' LICENSE, 'SOCIAL_SECURITY' SOCIAL_SECURITY, 'SDG_EMP_NO' SDG_EMP_NO, 'PRAC_NPI' PRAC_NPI, 'NPI' NPI, 'LICENSE_EXP_DATE' LICENSE_EXP_DATE)
)
)
SELECT DISTINCT
                       'QCPR' AS SOURCE,
                       EP.NETWORK,
                       EP.EMP_PROVIDER_ID AS PROVIDER_ID,
                       EP.NAME AS PROVIDER_NAME,
                       EP.TITLE_ID,
                       T.NAME AS TITLE_NAME,
                       T.PREFIX AS TITLE_PREFIX,
                       T.SUFFIX AS TITLE_SUFFIX,
                       EP.PHYSICIAN AS PHYSICIAN_FLAG,
                       EP.PHYSICIAN_GROUP_ID,
                       PG.NAME AS PHYSICIAN_GROUP_NAME,
--                       EMP_ID.EXTERNAL_NUMBER_ID AS EMP_ID,
--                       EMP_ID.VALUE AS EMP_VALUE,
                      empd.emp_id,
--                       LICENSE.EXTERNAL_NUMBER_ID AS LICENSE_ID,
--                       LICENSE.VALUE AS LICENSE_VALUE,
                       empd.license, 
--                       SOCIAL_SECURITY.EXTERNAL_NUMBER_ID AS SOCIAL_SECURITY_ID,
--                       SOCIAL_SECURITY.VALUE AS SOCIAL_SECURITY_VALUE,
                       empd.social_security,
--                       SDG_EMP_NO.EXTERNAL_NUMBER_ID AS SDG_EMP_NO_ID,
--                       SDG_EMP_NO.VALUE AS SDG_EMP_NO_VALUE,
                       empd.sdg_emp_no,
--                       PRAC_NPI.EXTERNAL_NUMBER_ID AS PRAC_NPI_ID,
--                       PRAC_NPI.VALUE AS PRAC_NPI_VALUE,
                       empd.prac_npi,
--                       NPI.EXTERNAL_NUMBER_ID AS NPI_ID,
--                       NPI.VALUE AS NPI_VALUE,
                       empd.npi,
--                       LICENSE_EXP_DATE.EXTERNAL_NUMBER_ID AS LICENSE_EXP_DATE_ID,
--                       LICENSE_EXP_DATE.VALUE AS LICENSE_EXP_DATE_VALUE,
                       LICENSE_EXP_DATE,
                       MS.PHYSICIAN_SERVICE_ID,
                       MS.NAME,
                       --   pivot(MS.PARENT_PHYSICIAN_SERVICE_ID),
                       'N' AS EPIC_FLAG,
                       SYSDATE AS LOAD_DATE
                  FROM EMP_PROVIDER EP,
                       TITLE T,
                       PHYSICIAN_GROUP PG,
                       EMP_FACILITY_MED_SPEC EFMS,
                       MEDICAL_SPECIALTY MS,
                       emp_prvdr_addtnl_dtls empd
                 WHERE     
--                        EP.EMP_PROVIDER_ID = EMP_ID.EMP_PROVIDER_ID(+)
--                       AND  EP.NETWORK=EMP_ID.NETWORK(+)
--                       AND EP.EMP_PROVIDER_ID = LICENSE.EMP_PROVIDER_ID(+)
--                       AND  EP.NETWORK=LICENSE.NETWORK(+)
--                       AND EP.EMP_PROVIDER_ID = SOCIAL_SECURITY.EMP_PROVIDER_ID(+)
--                       AND  EP.NETWORK=SOCIAL_SECURITY.NETWORK(+)
--                       AND EP.EMP_PROVIDER_ID = SDG_EMP_NO.EMP_PROVIDER_ID(+)
--                       AND  EP.NETWORK=SDG_EMP_NO.NETWORK(+)
--                       AND EP.EMP_PROVIDER_ID = PRAC_NPI.EMP_PROVIDER_ID(+)
--                       AND  EP.NETWORK=PRAC_NPI.NETWORK(+)
--                       AND EP.EMP_PROVIDER_ID = NPI.EMP_PROVIDER_ID(+)
--                       AND  EP.NETWORK=NPI.NETWORK(+)
--                       
--                       AND EP.EMP_PROVIDER_ID = LICENSE_EXP_DATE.EMP_PROVIDER_ID(+)
--                       AND  EP.NETWORK=LICENSE_EXP_DATE.NETWORK(+)
                       ep.emp_provider_id=empd.emp_provider_id(+)
                       and ep.network=empd.network(+) 
                       and ep.network='CBN'
                       AND EP.TITLE_ID = T.TITLE_ID(+)
                       AND  EP.NETWORK=T.NETWORK(+)
                       
                       AND EP.PHYSICIAN_GROUP_ID = PG.PHYSICIAN_GROUP_ID(+)
                       AND  EP.NETWORK=PG.NETWORK(+)
                       AND EP.EMP_PROVIDER_ID = EFMS.EMP_PROVIDER_ID(+)
                       AND  EP.NETWORK=EFMS.NETWORK(+)
                       
                       AND EFMS.PHYSICIAN_SERVICE_ID = MS.PHYSICIAN_SERVICE_ID(+)
                       AND EFMS.FACILITY_ID = MS.FACILITY_ID(+)
                       AND  EFMS.NETWORK=MS.NETWORK(+))FI2)FI WHERE RNK=1;
                       
                       
--                       39,620