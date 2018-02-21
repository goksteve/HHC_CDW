@@saveset

set termout off

var hint varchar2(30)
exec :hint := '%' || upper('&1') || '%'

set termout on

col name                format a30
col inverse             format a30

select name, inverse, version, version_outline
  from v$sql_hint
 where name like :hint;
 
@@loadset