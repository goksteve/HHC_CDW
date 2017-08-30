exec dbm.drop_tables('LKP_TRIAGEADULTPEDS');

CREATE TABLE lkp_TriageAdultPeds
(
  TriageAdultPedsKey NUMBER(10,0) CONSTRAINT pk_TriageAdultPeds PRIMARY KEY,
  TriageAdultPedsInd NVARCHAR2(1000)
) ORGANIZATION INDEX;

GRANT SELECT ON lkp_TriageAdultPeds TO PUBLIC;
