@@saveset

set echo off feed off termout off long 1000000 head off

var sql_id varchar2(30)
exec :sql_id := '&1'

set termout on

col sql_fulltext            format a160             word_wrapped

select * from 
    (select sql_fulltext from v$sql where sql_id = :sql_id
    union all
    select sql_text from dba_hist_sqltext where sql_id = :sql_id)
where rownum = 1;

@@loadset