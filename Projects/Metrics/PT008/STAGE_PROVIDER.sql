-- This is a query from Uma's I:\DataEnterprises\ETL_DOCS\STAGE_PROVIDER_ETL_JOB_INSTRUCTIONS_DOC.docx
SELECT
  FI.SOURCE,
  FI.NETWORK,
  FI.PROVIDER_ID,
  FI.PROVIDER_NAME,
  FI.TITLE_ID,
  FI.TITLE_NAME,
  FI.TITLE_PREFIX,
  FI.TITLE_SUFFIX,
  FI.PHYSICIAN_FLAG,
  FI.PHYSICIAN_GROUP_ID,
  FI.PHYSICIAN_GROUP_NAME,
  FI.EMP_ID,
  FI.EMP_VALUE,
  FI.LICENSE_ID,
  FI.LICENSE_VALUE,
  FI.SOCIAL_SECURITY_ID,
  FI.SOCIAL_SECURITY_VALUE,
  FI.SDG_EMP_NO_ID,
  FI.SDG_EMP_NO_VALUE,
  FI.PRAC_NPI_ID,
  FI.PRAC_NPI_VALUE,
  FI.NPI_ID,
  FI.NPI_VALUE,
  FI.LICENSE_EXP_DATE_ID,
  FI.LICENSE_EXP_DATE_VALUE,
  FI.PHYSICIAN_SERVICE_ID,
  FI.PHYSICIAN_SERVICE_NAME,
  CASE
   WHEN INSTR (FI.PHYSICIAN_SERVICE_ID,'|',1,1) > 0
    THEN SUBSTR (FI.PHYSICIAN_SERVICE_ID,1,INSTR (FI.PHYSICIAN_SERVICE_ID,'|',1,1) - 1)
    ELSE FI.PHYSICIAN_SERVICE_ID
  END AS PHYSICIAN_SERVICE_ID_1,
  CASE
    WHEN INSTR(FI.PHYSICIAN_SERVICE_NAME, '|', 1, 1) > 0
    THEN SUBSTR(FI.PHYSICIAN_SERVICE_NAME, 1, INSTR (FI.PHYSICIAN_SERVICE_NAME, '|', 1, 1) - 1)
    ELSE FI.PHYSICIAN_SERVICE_NAME
  END AS PHYSICIAN_SERVICE_NAME_1,
  CASE
    WHEN INSTR (FI.PHYSICIAN_SERVICE_ID,'|',1,1) > 0
    THEN
      CASE
        WHEN INSTR (FI.PHYSICIAN_SERVICE_ID,'|',1,2) > 0
        THEN SUBSTR (FI.PHYSICIAN_SERVICE_ID, INSTR (FI.PHYSICIAN_SERVICE_ID, '|') + 1, INSTR (FI.PHYSICIAN_SERVICE_ID,'|',1, 2) - INSTR (FI.PHYSICIAN_SERVICE_ID, '|')- 1)
        ELSE SUBSTR (FI.PHYSICIAN_SERVICE_ID,INSTR (FI.PHYSICIAN_SERVICE_ID,'|',1,1)+ 1, LENGTH (FI.PHYSICIAN_SERVICE_ID) - INSTR (FI.PHYSICIAN_SERVICE_ID, '|', 1, 1))
      END
  END AS PHYSICIAN_SERVICE_ID_2,
  CASE
    WHEN INSTR (FI.PHYSICIAN_SERVICE_ID,
                '|',
                1,
                1) > 0
    THEN
       CASE
          WHEN INSTR (FI.PHYSICIAN_SERVICE_NAME,
                      '|',
                      1,
                      2) > 0
          THEN
             SUBSTR (FI.PHYSICIAN_SERVICE_NAME,
                     INSTR (FI.PHYSICIAN_SERVICE_NAME, '|') + 1,
                       INSTR (FI.PHYSICIAN_SERVICE_NAME,
                              '|',
                              1,
                              2)
                     - INSTR (FI.PHYSICIAN_SERVICE_NAME, '|')
                     - 1)
          ELSE
             SUBSTR (FI.PHYSICIAN_SERVICE_NAME,
                       INSTR (FI.PHYSICIAN_SERVICE_NAME,
                              '|',
                              1,
                              1)
                     + 1,
                       LENGTH (FI.PHYSICIAN_SERVICE_NAME)
                     - INSTR (FI.PHYSICIAN_SERVICE_NAME,
                              '|',
                              1,
                              1))
       END
    ELSE
       NULL
  END
    AS PHYSICIAN_SERVICE_NAME_2,
  CASE
    WHEN INSTR (FI.PHYSICIAN_SERVICE_NAME,
                '|',
                1,
                2) > 0
    THEN
       CASE
          WHEN INSTR (FI.PHYSICIAN_SERVICE_ID,
                      '|',
                      1,
                      3) > 0
          THEN
             SUBSTR (FI.PHYSICIAN_SERVICE_ID,
                       INSTR (FI.PHYSICIAN_SERVICE_ID,
                              '|',
                              1,
                              2)
                     + 1,
                       INSTR (FI.PHYSICIAN_SERVICE_ID,
                              '|',
                              1,
                              3)
                     - INSTR (FI.PHYSICIAN_SERVICE_ID,
                              '|',
                              1,
                              2)
                     - 1)
          ELSE
             SUBSTR (FI.PHYSICIAN_SERVICE_ID,
                       INSTR (FI.PHYSICIAN_SERVICE_ID,
                              '|',
                              1,
                              2)
                     + 1,
                       LENGTH (FI.PHYSICIAN_SERVICE_ID)
                     - INSTR (FI.PHYSICIAN_SERVICE_ID,
                              '|',
                              1,
                              2))
       END
    ELSE
       NULL
  END
    AS PHYSICIAN_SERVICE_ID_3,
  CASE
    WHEN INSTR (FI.PHYSICIAN_SERVICE_NAME,
                '|',
                1,
                2) > 0
    THEN
       CASE
          WHEN INSTR (FI.PHYSICIAN_SERVICE_NAME,
                      '|',
                      1,
                      3) > 0
          THEN
             SUBSTR (FI.PHYSICIAN_SERVICE_NAME,
                       INSTR (FI.PHYSICIAN_SERVICE_NAME,
                              '|',
                              1,
                              2)
                     + 1,
                       INSTR (FI.PHYSICIAN_SERVICE_NAME,
                              '|',
                              1,
                              3)
                     - INSTR (FI.PHYSICIAN_SERVICE_NAME,
                              '|',
                              1,
                              2)
                     - 1)
          ELSE
             SUBSTR (FI.PHYSICIAN_SERVICE_NAME,
                       INSTR (FI.PHYSICIAN_SERVICE_NAME,
                              '|',
                              1,
                              2)
                     + 1,
                       LENGTH (FI.PHYSICIAN_SERVICE_NAME)
                     - INSTR (FI.PHYSICIAN_SERVICE_NAME,
                              '|',
                              1,
                              2))
       END
    ELSE
       NULL
  END
    AS PHYSICIAN_SERVICE_NAME_3,
  CASE
    WHEN INSTR (FI.PHYSICIAN_SERVICE_NAME,
                '|',
                1,
                3) > 0
    THEN
       CASE
          WHEN INSTR (FI.PHYSICIAN_SERVICE_ID,
                      '|',
                      1,
                      4) > 0
          THEN
             SUBSTR (FI.PHYSICIAN_SERVICE_ID,
                       INSTR (FI.PHYSICIAN_SERVICE_ID,
                              '|',
                              1,
                              3)
                     + 1,
                       INSTR (FI.PHYSICIAN_SERVICE_ID,
                              '|',
                              1,
                              4)
                     - INSTR (FI.PHYSICIAN_SERVICE_ID,
                              '|',
                              1,
                              3)
                     - 1)
          ELSE
             SUBSTR (FI.PHYSICIAN_SERVICE_ID,
                       INSTR (FI.PHYSICIAN_SERVICE_ID,
                              '|',
                              1,
                              3)
                     + 1,
                       LENGTH (FI.PHYSICIAN_SERVICE_ID)
                     - INSTR (FI.PHYSICIAN_SERVICE_ID,
                              '|',
                              1,
                              3))
       END
    ELSE
       NULL
  END
    AS PHYSICIAN_SERVICE_ID_4,
  CASE
    WHEN INSTR (FI.PHYSICIAN_SERVICE_NAME,
                '|',
                1,
                3) > 0
    THEN
       CASE
          WHEN INSTR (FI.PHYSICIAN_SERVICE_NAME,
                      '|',
                      1,
                      4) > 0
          THEN
             SUBSTR (FI.PHYSICIAN_SERVICE_NAME,
                       INSTR (FI.PHYSICIAN_SERVICE_NAME,
                              '|',
                              1,
                              3)
                     + 1,
                       INSTR (FI.PHYSICIAN_SERVICE_NAME,
                              '|',
                              1,
                              4)
                     - INSTR (FI.PHYSICIAN_SERVICE_NAME,
                              '|',
                              1,
                              3)
                     - 1)
          ELSE
             SUBSTR (FI.PHYSICIAN_SERVICE_NAME,
                       INSTR (FI.PHYSICIAN_SERVICE_NAME,
                              '|',
                              1,
                              3)
                     + 1,
                       LENGTH (FI.PHYSICIAN_SERVICE_NAME)
                     - INSTR (FI.PHYSICIAN_SERVICE_NAME,
                              '|',
                              1,
                              3))
       END
    ELSE
       NULL
  END
    AS PHYSICIAN_SERVICE_NAME_4,
  CASE
    WHEN INSTR (FI.PHYSICIAN_SERVICE_NAME,
                '|',
                1,
                4) > 0
    THEN
       CASE
          WHEN INSTR (FI.PHYSICIAN_SERVICE_ID,
                      '|',
                      1,
                      5) > 0
          THEN
             SUBSTR (FI.PHYSICIAN_SERVICE_ID,
                       INSTR (FI.PHYSICIAN_SERVICE_ID,
                              '|',
                              1,
                              4)
                     + 1,
                       INSTR (FI.PHYSICIAN_SERVICE_ID,
                              '|',
                              1,
                              5)
                     - INSTR (FI.PHYSICIAN_SERVICE_ID,
                              '|',
                              1,
                              4)
                     - 1)
          ELSE
             SUBSTR (FI.PHYSICIAN_SERVICE_ID,
                       INSTR (FI.PHYSICIAN_SERVICE_ID,
                              '|',
                              1,
                              4)
                     + 1,
                       LENGTH (FI.PHYSICIAN_SERVICE_ID)
                     - INSTR (FI.PHYSICIAN_SERVICE_ID,
                              '|',
                              1,
                              4))
       END
    ELSE
       NULL
  END
    AS PHYSICIAN_SERVICE_ID_5,
  CASE
    WHEN INSTR (FI.PHYSICIAN_SERVICE_NAME,
                '|',
                1,
                4) > 0
    THEN
       CASE
          WHEN INSTR (FI.PHYSICIAN_SERVICE_NAME,
                      '|',
                      1,
                      5) > 0
          THEN
             SUBSTR (FI.PHYSICIAN_SERVICE_NAME,
                       INSTR (FI.PHYSICIAN_SERVICE_NAME,
                              '|',
                              1,
                              4)
                     + 1,
                       INSTR (FI.PHYSICIAN_SERVICE_NAME,
                              '|',
                              1,
                              5)
                     - INSTR (FI.PHYSICIAN_SERVICE_NAME,
                              '|',
                              1,
                              4)
                     - 1)
          ELSE
             SUBSTR (FI.PHYSICIAN_SERVICE_NAME,
                       INSTR (FI.PHYSICIAN_SERVICE_NAME,
                              '|',
                              1,
                              4)
                     + 1,
                       LENGTH (FI.PHYSICIAN_SERVICE_NAME)
                     - INSTR (FI.PHYSICIAN_SERVICE_NAME,
                              '|',
                              1,
                              4))
       END
    ELSE
       NULL
  END
    AS PHYSICIAN_SERVICE_NAME_5,
  1 AS CURRENT_FLAG,
  FI.LOAD_DATE,
  FI.EPIC_FLAG
FROM
(
  SELECT DISTINCT
    SOURCE,
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
    EMP_VALUE,
    LICENSE_ID,
    LICENSE_VALUE,
    SOCIAL_SECURITY_ID,
    SOCIAL_SECURITY_VALUE,
    SDG_EMP_NO_ID,
    SDG_EMP_NO_VALUE,
    PRAC_NPI_ID,
    PRAC_NPI_VALUE,
    NPI_ID,
    NPI_VALUE,
    LICENSE_EXP_DATE_ID,
    LICENSE_EXP_DATE_VALUE,
    LISTAGG (PHYSICIAN_SERVICE_ID, '|')
      WITHIN GROUP (ORDER BY PROVIDER_ID, PHYSICIAN_SERVICE_ID)
      OVER (PARTITION BY PROVIDER_ID, LICENSE_VALUE)
      AS PHYSICIAN_SERVICE_ID,
    LISTAGG (NAME, '|')
      WITHIN GROUP (ORDER BY PROVIDER_ID, PHYSICIAN_SERVICE_ID)
      OVER (PARTITION BY PROVIDER_ID, LICENSE_VALUE)
      AS PHYSICIAN_SERVICE_NAME,
    ROW_NUMBER () OVER (PARTITION BY PROVIDER_ID ORDER BY LICENSE_VALUE) AS RNK,
    EPIC_FLAG,
    LOAD_DATE
  FROM 
  (
    SELECT DISTINCT
      'QCPR' AS SOURCE,
      (SELECT SUBSTR (ORA_DATABASE_NAME, 1, 3) FROM DUAL) AS NETWORK,
      EP.EMP_PROVIDER_ID AS PROVIDER_ID,
      EP.NAME AS PROVIDER_NAME,
      EP.TITLE_ID,
      T.NAME AS TITLE_NAME,
      T.PREFIX AS TITLE_PREFIX,
      T.SUFFIX AS TITLE_SUFFIX,
      EP.PHYSICIAN AS PHYSICIAN_FLAG,
      EP.PHYSICIAN_GROUP_ID,
      PG.NAME AS PHYSICIAN_GROUP_NAME,
      EMP_ID.EXTERNAL_NUMBER_ID AS EMP_ID,
      EMP_ID.VALUE AS EMP_VALUE,
      LICENSE.EXTERNAL_NUMBER_ID AS LICENSE_ID,
      LICENSE.VALUE AS LICENSE_VALUE,
      SOCIAL_SECURITY.EXTERNAL_NUMBER_ID AS SOCIAL_SECURITY_ID,
      SOCIAL_SECURITY.VALUE AS SOCIAL_SECURITY_VALUE,
      SDG_EMP_NO.EXTERNAL_NUMBER_ID AS SDG_EMP_NO_ID,
      SDG_EMP_NO.VALUE AS SDG_EMP_NO_VALUE,
      PRAC_NPI.EXTERNAL_NUMBER_ID AS PRAC_NPI_ID,
      PRAC_NPI.VALUE AS PRAC_NPI_VALUE,
      NPI.EXTERNAL_NUMBER_ID AS NPI_ID,
      NPI.VALUE AS NPI_VALUE,
      LICENSE_EXP_DATE.EXTERNAL_NUMBER_ID AS LICENSE_EXP_DATE_ID,
      LICENSE_EXP_DATE.VALUE AS LICENSE_EXP_DATE_VALUE,
      MS.PHYSICIAN_SERVICE_ID,
      MS.NAME,
      --   pivot(MS.PARENT_PHYSICIAN_SERVICE_ID),
      'N' AS EPIC_FLAG,
      SYSDATE AS LOAD_DATE
    FROM
      UD_MASTER.EMP_PROVIDER EP,
      UD_MASTER.TITLE T,
      UD_MASTER.PHYSICIAN_GROUP PG,
      UD_MASTER.EMP_FACILITY_MED_SPEC EFMS,
      UD_MASTER.MEDICAL_SPECIALTY MS,
      (
        SELECT DISTINCT
          EP.EMP_PROVIDER_ID,
          EE.EXTERNAL_NUMBER_ID,
          EN.NAME,
          EE.VALUE
        FROM UD_MASTER.EMP_PROVIDER EP
        JOIN UD_MASTER.EMP_FACILITY_EXTERNAL_NUMBER EE
          ON EP.EMP_PROVIDER_ID = EE.EMP_PROVIDER_ID
        JOIN UD_MASTER.EXTERNAL_NUMBER EN
          ON EE.EXTERNAL_NUMBER_ID = EN.EXTERNAL_NUMBER_ID
        AND EE.FACILITY_ID = EN.FACILITY_ID
        WHERE EE.EXTERNAL_NUMBER_ID = '2'
      ) EMP_ID,
      (
        SELECT DISTINCT
          EP.EMP_PROVIDER_ID,
          EE.EXTERNAL_NUMBER_ID,
          EN.NAME,
          EE.VALUE
        FROM UD_MASTER.EMP_PROVIDER EP
        JOIN UD_MASTER.EMP_FACILITY_EXTERNAL_NUMBER EE
          ON EP.EMP_PROVIDER_ID = EE.EMP_PROVIDER_ID
        JOIN UD_MASTER.EXTERNAL_NUMBER EN
          ON EE.EXTERNAL_NUMBER_ID = EN.EXTERNAL_NUMBER_ID
         AND EE.FACILITY_ID = EN.FACILITY_ID
        WHERE EE.EXTERNAL_NUMBER_ID = '4'
      ) LICENSE,
      (
        SELECT DISTINCT
          EP.EMP_PROVIDER_ID,
          EE.EXTERNAL_NUMBER_ID,
          EN.NAME,
          EE.VALUE
        FROM UD_MASTER.EMP_PROVIDER EP
        JOIN UD_MASTER.EMP_FACILITY_EXTERNAL_NUMBER EE
          ON EP.EMP_PROVIDER_ID = EE.EMP_PROVIDER_ID
        JOIN UD_MASTER.EXTERNAL_NUMBER EN
          ON EE.EXTERNAL_NUMBER_ID = EN.EXTERNAL_NUMBER_ID
         AND EE.FACILITY_ID = EN.FACILITY_ID
        WHERE EE.EXTERNAL_NUMBER_ID = '27'
      ) SOCIAL_SECURITY,
      (
        SELECT DISTINCT
          EP.EMP_PROVIDER_ID,
          EE.EXTERNAL_NUMBER_ID,
          EN.NAME,
          EE.VALUE
        FROM UD_MASTER.EMP_PROVIDER EP
        JOIN UD_MASTER.EMP_FACILITY_EXTERNAL_NUMBER EE
          ON EP.EMP_PROVIDER_ID = EE.EMP_PROVIDER_ID
        JOIN UD_MASTER.EXTERNAL_NUMBER EN
          ON EE.EXTERNAL_NUMBER_ID = EN.EXTERNAL_NUMBER_ID
         AND EE.FACILITY_ID = EN.FACILITY_ID
        WHERE EE.EXTERNAL_NUMBER_ID = '29'
      ) SDG_EMP_NO,
      (
        SELECT DISTINCT EP.EMP_PROVIDER_ID,
                      EE.EXTERNAL_NUMBER_ID,
                      EN.NAME,
                      EE.VALUE
        FROM UD_MASTER.EMP_PROVIDER EP
             JOIN UD_MASTER.EMP_FACILITY_EXTERNAL_NUMBER EE
                ON EP.EMP_PROVIDER_ID = EE.EMP_PROVIDER_ID
             JOIN UD_MASTER.EXTERNAL_NUMBER EN
                ON     EE.EXTERNAL_NUMBER_ID =
                          EN.EXTERNAL_NUMBER_ID
                   AND EE.FACILITY_ID = EN.FACILITY_ID
        WHERE EE.EXTERNAL_NUMBER_ID = '36'
      ) PRAC_NPI,
      (
        SELECT DISTINCT
          EP.EMP_PROVIDER_ID,
          EE.EXTERNAL_NUMBER_ID,
          EN.NAME,
          EE.VALUE
        FROM UD_MASTER.EMP_PROVIDER EP
        JOIN UD_MASTER.EMP_FACILITY_EXTERNAL_NUMBER EE
          ON EP.EMP_PROVIDER_ID = EE.EMP_PROVIDER_ID
        JOIN UD_MASTER.EXTERNAL_NUMBER EN
          ON  EE.EXTERNAL_NUMBER_ID = EN.EXTERNAL_NUMBER_ID
         AND EE.FACILITY_ID = EN.FACILITY_ID
        WHERE EE.EXTERNAL_NUMBER_ID = '39'
      ) NPI,
      (
        SELECT DISTINCT
          EP.EMP_PROVIDER_ID,
          EE.EXTERNAL_NUMBER_ID,
          EN.NAME,
          EE.VALUE
        FROM UD_MASTER.EMP_PROVIDER EP
        JOIN UD_MASTER.EMP_FACILITY_EXTERNAL_NUMBER EE
                ON EP.EMP_PROVIDER_ID = EE.EMP_PROVIDER_ID
             JOIN UD_MASTER.EXTERNAL_NUMBER EN
                ON     EE.EXTERNAL_NUMBER_ID =
                          EN.EXTERNAL_NUMBER_ID
                   AND EE.FACILITY_ID = EN.FACILITY_ID
       WHERE EE.EXTERNAL_NUMBER_ID = '40') LICENSE_EXP_DATE
WHERE     EP.EMP_PROVIDER_ID = EMP_ID.EMP_PROVIDER_ID(+)
     AND EP.EMP_PROVIDER_ID = LICENSE.EMP_PROVIDER_ID(+)
     AND EP.EMP_PROVIDER_ID =
            SOCIAL_SECURITY.EMP_PROVIDER_ID(+)
     AND EP.EMP_PROVIDER_ID = SDG_EMP_NO.EMP_PROVIDER_ID(+)
     AND EP.EMP_PROVIDER_ID = PRAC_NPI.EMP_PROVIDER_ID(+)
     AND EP.EMP_PROVIDER_ID = NPI.EMP_PROVIDER_ID(+)
     AND EP.EMP_PROVIDER_ID =
            LICENSE_EXP_DATE.EMP_PROVIDER_ID(+)
     AND EP.TITLE_ID = T.TITLE_ID(+)
     AND EP.PHYSICIAN_GROUP_ID = PG.PHYSICIAN_GROUP_ID(+)
     AND EP.EMP_PROVIDER_ID = EFMS.EMP_PROVIDER_ID(+)
     AND EFMS.PHYSICIAN_SERVICE_ID =
            MS.PHYSICIAN_SERVICE_ID(+)
     AND EFMS.FACILITY_ID = MS.FACILITY_ID(+)--  AND EP.EMP_PROVIDER_ID = 10188
                                             --    AND EP.EMP_PROVIDER_ID = 1096
                                             --  AND EP.EMP_PROVIDER_ID = 10188
) FI2) FI
WHERE RNK = 1;

