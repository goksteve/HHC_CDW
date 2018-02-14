begin
  for r in
  (
    select object_type, owner, object_name
    from all_objects
    where owner = sys_context('userenv','current_schema')
    and object_type in ('TABLE','SEQUENCE')
    and object_name in ('DIM_PAYERS','SEQ_PAYER_MAPPINGS')
  )
  loop
    execute immediate 'drop '||r.object_type||' '||r.owner||'.'||r.object_name||case when r.object_type = 'TABLE' then ' CASCADE CONSTRAINTS PURGE' end;
  end loop;
end;
/

CREATE TABLE dim_payers
(
  payer_key    NUMBER(12) NOT NULL CONSTRAINT pk_dim_payers PRIMARY KEY,
  network      VARCHAR2(150 BYTE) NOT NULL,
  payer_id     VARCHAR2(150 BYTE) NOT NULL,
  PAYER_NAME   VARCHAR2(150 BYTE) NOT NULL,
  PAYER_GROUP  VARCHAR2(2048 BYTE) NOT NULL,
  CONSTRAINT uk_dim_payers UNIQUE(network, payer_id)
) COMPRESS BASIC;

CREATE SEQUENCE seq_payer_mappings;

CREATE OR REPLACE TRIGGER bir_dim_payers
BEFORE INSERT ON dim_payers FOR EACH ROW
BEGIN
  :new.payer_key := seq_payer_mappings.NEXTVAL;
END;
/