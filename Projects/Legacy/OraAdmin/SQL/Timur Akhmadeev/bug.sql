@@saveset

set term off

var descr varchar2(200)
exec :descr := upper('%' || '&1' || '%')

col bugno                           format 999999999
col value                           format 999
col sql_feature                     format a40
col optimizer_feature_enable        format a10 heading 'Opt|features'

set term on

select bugno, value, sql_feature, description, optimizer_feature_enable
  from v$session_fix_control
 where session_id = userenv('sid')
   and (upper(description) like :descr or to_char(bugno) like :descr or optimizer_feature_enable like :descr)
 order by optimizer_feature_enable, bugno;
   
@@loadset