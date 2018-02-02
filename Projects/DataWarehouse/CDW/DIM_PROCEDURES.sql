begin
  for r in
  (
    select object_type, owner, object_name
    from all_objects
    where owner = sys_context('userenv','current_schema')
    and object_type in ('TABLE','SEQUENCE')
    and object_name in ('DIM_PROCEDURES','SEQ_DIM_PROCEDURE_KEY')
  )
  loop
    execute immediate 'drop '||r.object_type||' '||r.owner||'.'||r.object_name||case when r.object_type = 'TABLE' then ' CASCADE CONSTRAINTS PURGE' end;
  end loop;
end;
/

CREATE TABLE dim_procedures
(
  proc_key      NUMBER(10) CONSTRAINT pk_dim_procedures PRIMARY KEY,
  proc_name     VARCHAR2(175 BYTE) NOT NULL,
  proc_type     VARCHAR2(40 BYTE) NOT NULL,
  kardex_group  VARCHAR2(40 BYTE),
  is_primary    CHAR(1 BYTE) NOT NULL CONSTRAINT chk_dim_proc_prim_flag CHECK(is_primary IN ('Y', 'N')),
  is_nursing    CHAR(1 BYTE) NOT NULL CONSTRAINT chk_dim_proc_nurse_flag CHECK(is_nursing IN ('Y', 'N')),
  source        VARCHAR2(60 BYTE) NOT NULL,
  network       CHAR(3 BYTE) NOT NULL,
  src_proc_id   NUMBER(10) NOT NULL,
  load_dt       DATE DEFAULT SYSDATE NOT NULL,
  loaded_by     VARCHAR2(30 BYTE) DEFAULT SYS_CONTEXT('USERENV','OS_USER') NOT NULL,
  CONSTRAINT uk_dim_procedures UNIQUE(source, network, src_proc_id)
) COMPRESS BASIC;

GRANT SELECT ON dim_procedures TO PUBLIC;

CREATE SEQUENCE seq_dim_procedure_key;

CREATE OR REPLACE TRIGGER bir_dim_procedures
BEFORE INSERT ON dim_procedures FOR EACH ROW
BEGIN
  IF :new.proc_key IS NULL THEN
    :new.proc_key := seq_dim_procedure_key.NEXTVAL;
  END IF;
END;
/
