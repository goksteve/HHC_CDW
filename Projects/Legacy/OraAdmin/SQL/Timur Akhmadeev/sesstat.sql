@@saveset

set termout off

var stat_name varchar2(200)
exec :stat_name := lower('%&1%')

set termout on

col name            format a50

select n.name, s.value
  from v$sesstat s, v$statname n
 where s.statistic# = n.statistic#
   and s.sid = userenv('sid')
   and lower(n.name) like :stat_name;
   
@@loadset