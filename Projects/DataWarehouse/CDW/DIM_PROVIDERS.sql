CREATE TABLE DIM_PROVIDERS
--partition by list(network)
--(
--partition pcbn values('CBN'),
--partition pgp1 values('GP1'),
--partition pgp2 values('GP2'),
--partition pnbn values('NBN'),
--partition pnbx values('NBX'),
--partition pqhn values('QHN'),
--partition psbn values('SBN'),
--partition psmn values('SMN')
--)
AS
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
                       EMP_ID.EXTERNAL_NUMBER_ID AS EMP_ID,
                       EMP_ID.VALUE AS EMP_VALUE,
                       LICENSE.EXTERNAL_NUMBER_ID AS LICENSE_ID,
                       LICENSE.VALUE AS LICENSE_VALUE,
                       SOCIAL_SECURITY.EXTERNAL_NUMBER_ID
                          AS SOCIAL_SECURITY_ID,
                       SOCIAL_SECURITY.VALUE AS SOCIAL_SECURITY_VALUE,
                       SDG_EMP_NO.EXTERNAL_NUMBER_ID AS SDG_EMP_NO_ID,
                       SDG_EMP_NO.VALUE AS SDG_EMP_NO_VALUE,
                       PRAC_NPI.EXTERNAL_NUMBER_ID AS PRAC_NPI_ID,
                       PRAC_NPI.VALUE AS PRAC_NPI_VALUE,
                       NPI.EXTERNAL_NUMBER_ID AS NPI_ID,
                       NPI.VALUE AS NPI_VALUE,
                       LICENSE_EXP_DATE.EXTERNAL_NUMBER_ID
                          AS LICENSE_EXP_DATE_ID,
                       LICENSE_EXP_DATE.VALUE AS LICENSE_EXP_DATE_VALUE,
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
                       (SELECT DISTINCT 
                       EE.NETWORK,
                       EP.EMP_PROVIDER_ID,
                                        EE.EXTERNAL_NUMBER_ID,
                                        EN.NAME,
                                        EE.VALUE
                          FROM EMP_PROVIDER EP
                               JOIN EMP_FACILITY_EXTERNAL_NUMBER EE
                                  ON EP.EMP_PROVIDER_ID = EE.EMP_PROVIDER_ID AND  EP.NETWORK=EE.NETWORK
                               JOIN EXTERNAL_NUMBER EN
                                  ON     EE.EXTERNAL_NUMBER_ID =
                                            EN.EXTERNAL_NUMBER_ID 
                                     AND EE.FACILITY_ID = EN.FACILITY_ID AND EE.NETWORK=EN.NETWORK
                                                              WHERE EE.EXTERNAL_NUMBER_ID = '2' ) EMP_ID,
                       (SELECT DISTINCT
                       EP.NETWORK, 
                       EP.EMP_PROVIDER_ID,
                                        EE.EXTERNAL_NUMBER_ID,
                                        EN.NAME,
                                        EE.VALUE
                          FROM EMP_PROVIDER EP
                               JOIN EMP_FACILITY_EXTERNAL_NUMBER EE
                                  ON EP.EMP_PROVIDER_ID = EE.EMP_PROVIDER_ID AND  EP.NETWORK=EE.NETWORK
                               JOIN EXTERNAL_NUMBER EN
                                  ON     EE.EXTERNAL_NUMBER_ID =
                                            EN.EXTERNAL_NUMBER_ID
                                     AND EE.FACILITY_ID = EN.FACILITY_ID AND  EE.NETWORK=EN.NETWORK
                         WHERE EE.EXTERNAL_NUMBER_ID = '4') LICENSE,
                       (SELECT DISTINCT 
                       EP.NETWORK, 
                       
                       EP.EMP_PROVIDER_ID,
                                        EE.EXTERNAL_NUMBER_ID,
                                        EN.NAME,
                                        EE.VALUE
                          FROM EMP_PROVIDER EP
                               JOIN EMP_FACILITY_EXTERNAL_NUMBER EE
                                  ON EP.EMP_PROVIDER_ID = EE.EMP_PROVIDER_ID AND  EP.NETWORK=EE.NETWORK
                               JOIN EXTERNAL_NUMBER EN
                                  ON     EE.EXTERNAL_NUMBER_ID =
                                            EN.EXTERNAL_NUMBER_ID
                                     AND EE.FACILITY_ID = EN.FACILITY_ID AND  EE.NETWORK=EN.NETWORK
                         WHERE EE.EXTERNAL_NUMBER_ID = '27') SOCIAL_SECURITY,
                       (SELECT DISTINCT 
                                              EP.NETWORK, 

                       EP.EMP_PROVIDER_ID,
                                        EE.EXTERNAL_NUMBER_ID,
                                        EN.NAME,
                                        EE.VALUE
                          FROM EMP_PROVIDER EP
                               JOIN EMP_FACILITY_EXTERNAL_NUMBER EE
                                  ON EP.EMP_PROVIDER_ID = EE.EMP_PROVIDER_ID AND  EP.NETWORK=EE.NETWORK
                               JOIN EXTERNAL_NUMBER EN
                                  ON     EE.EXTERNAL_NUMBER_ID =
                                            EN.EXTERNAL_NUMBER_ID
                                     AND EE.FACILITY_ID = EN.FACILITY_ID AND  EE.NETWORK=EN.NETWORK
                         WHERE EE.EXTERNAL_NUMBER_ID = '29') SDG_EMP_NO,
                       (SELECT DISTINCT 
                                              EP.NETWORK, 

                       EP.EMP_PROVIDER_ID,
                                        EE.EXTERNAL_NUMBER_ID,
                                        EN.NAME,
                                        EE.VALUE
                          FROM EMP_PROVIDER EP
                               JOIN EMP_FACILITY_EXTERNAL_NUMBER EE
                                  ON EP.EMP_PROVIDER_ID = EE.EMP_PROVIDER_ID AND  EP.NETWORK=EE.NETWORK
                               JOIN EXTERNAL_NUMBER EN
                                  ON     EE.EXTERNAL_NUMBER_ID =
                                            EN.EXTERNAL_NUMBER_ID
                                     AND EE.FACILITY_ID = EN.FACILITY_ID AND  EE.NETWORK=EN.NETWORK
                         WHERE EE.EXTERNAL_NUMBER_ID = '36') PRAC_NPI,
                       (SELECT DISTINCT 
                                              EP.NETWORK, 

                       EP.EMP_PROVIDER_ID,
                                        EE.EXTERNAL_NUMBER_ID,
                                        EN.NAME,
                                        EE.VALUE
                          FROM EMP_PROVIDER EP
                               JOIN EMP_FACILITY_EXTERNAL_NUMBER EE
                                  ON EP.EMP_PROVIDER_ID = EE.EMP_PROVIDER_ID  AND  EP.NETWORK=EE.NETWORK
                               JOIN EXTERNAL_NUMBER EN
                                  ON     EE.EXTERNAL_NUMBER_ID =
                                            EN.EXTERNAL_NUMBER_ID
                                     AND EE.FACILITY_ID = EN.FACILITY_ID AND  EE.NETWORK=EN.NETWORK
                         WHERE EE.EXTERNAL_NUMBER_ID = '39') NPI,
                       (SELECT DISTINCT 
                                              EP.NETWORK, 

                       EP.EMP_PROVIDER_ID,
                                        EE.EXTERNAL_NUMBER_ID,
                                        EN.NAME,
                                        EE.VALUE
                          FROM EMP_PROVIDER EP
                               JOIN EMP_FACILITY_EXTERNAL_NUMBER EE
                                  ON EP.EMP_PROVIDER_ID = EE.EMP_PROVIDER_ID  AND  EP.NETWORK=EE.NETWORK
                               JOIN EXTERNAL_NUMBER EN
                                  ON     EE.EXTERNAL_NUMBER_ID =
                                            EN.EXTERNAL_NUMBER_ID
                                     AND EE.FACILITY_ID = EN.FACILITY_ID AND  EE.NETWORK=EN.NETWORK
                         WHERE EE.EXTERNAL_NUMBER_ID = '40') LICENSE_EXP_DATE
                 WHERE     EP.EMP_PROVIDER_ID = EMP_ID.EMP_PROVIDER_ID(+)
                       AND  EP.NETWORK=EMP_ID.NETWORK(+)
                       AND EP.EMP_PROVIDER_ID = LICENSE.EMP_PROVIDER_ID(+)
                       AND  EP.NETWORK=LICENSE.NETWORK(+)
                       AND EP.EMP_PROVIDER_ID = SOCIAL_SECURITY.EMP_PROVIDER_ID(+)
                       AND  EP.NETWORK=SOCIAL_SECURITY.NETWORK(+)
                       AND EP.EMP_PROVIDER_ID = SDG_EMP_NO.EMP_PROVIDER_ID(+)
                       AND  EP.NETWORK=SDG_EMP_NO.NETWORK(+)
                       AND EP.EMP_PROVIDER_ID = PRAC_NPI.EMP_PROVIDER_ID(+)
                       AND  EP.NETWORK=PRAC_NPI.NETWORK(+)
                       AND EP.EMP_PROVIDER_ID = NPI.EMP_PROVIDER_ID(+)
                       AND  EP.NETWORK=NPI.NETWORK(+)
                       
                       AND EP.EMP_PROVIDER_ID = LICENSE_EXP_DATE.EMP_PROVIDER_ID(+)
                       AND  EP.NETWORK=LICENSE_EXP_DATE.NETWORK(+)
                       
                       AND EP.TITLE_ID = T.TITLE_ID(+)
                       AND  EP.NETWORK=T.NETWORK(+)
                       
                       AND EP.PHYSICIAN_GROUP_ID = PG.PHYSICIAN_GROUP_ID(+)
                       AND  EP.NETWORK=PG.NETWORK(+)
                       AND EP.EMP_PROVIDER_ID = EFMS.EMP_PROVIDER_ID(+)
                       AND  EP.NETWORK=EFMS.NETWORK(+)
                       
                       AND EFMS.PHYSICIAN_SERVICE_ID = MS.PHYSICIAN_SERVICE_ID(+)
                       AND EFMS.FACILITY_ID = MS.FACILITY_ID(+)
                       AND  EFMS.NETWORK=MS.NETWORK(+);
                       