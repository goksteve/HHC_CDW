@saveset

set termout off

var sql_id varchar2(30)
exec :sql_id := '&1'

set termout on

select * from table(dbms_xplan.display_cursor(:sql_id));

@loadset