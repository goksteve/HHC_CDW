exec dbm.drop_tables('LKP_CURRENTEVENTSTATES');

CREATE TABLE lkp_CurrentEventStates
(
  CurrentEventStateKey  NUMBER(10,0) CONSTRAINT pk_CurrentEventState PRIMARY KEY,
  CurrentEventState     VARCHAR2(1000),
  CurrentEventStateSort NUMBER(10,0)
) ORGANIZATION INDEX;

GRANT SELECT ON lkp_CurrentEventStates TO PUBLIC;