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
  
INSERT INTO dim_procedures
(
  proc_key, proc_name, proc_type, kardex_group, is_primary, is_nursing, 
  source, network, src_proc_id 
)
SELECT seq_dim_procedure_key.NEXTVAL, q.*
FROM
(
  SELECT
    p.name AS proc_name, pt.proc_type_name AS proc_type, kg.name AS kardex_group,
    DECODE(primary_proc_flag, 'T', 'Y', 'F', 'N') is_primary,
    DECODE(nursing_proc_flag, 'T', 'Y', 'F', 'N') is_nursing, 
    'UD_MASTER.PROC' AS source, p.network, p.proc_id  
  FROM proc p
  LEFT JOIN proc_type pt ON pt.network = p.network AND pt.proc_type_id = p.proc_type_id 
  LEFT JOIN kardex_group kg ON kg.network = p.network AND kg.kardex_group_id = p.kardex_group_id
  WHERE p.name IS NOT NULL 
  ORDER BY p.network, p.proc_id
) q;

COMMIT;
