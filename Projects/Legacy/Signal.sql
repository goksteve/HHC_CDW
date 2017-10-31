create table tst_ok_signals
(
  proc_id NUMBER(30),
  num     NUMBER(6),
  val     NUMBER(4)
) compress basic;

create or replace procedure tst_signal(p_distance in pls_integer, p_max_speed in pls_integer, p_acceleration in pls_integer) as
  type buffer_type is table of  tst_ok_signals%rowtype index by pls_integer;
begin
  xl.open_log('TST_OK_SIGNALS', 'P_DISTANCE='||p_distance||', P_MAX_SPEED='||p_max_speeed||', P_ACCELERATION='||p_acceleration, TRUE);
  
  xl.begin_action('Calculating signal parameters');
  
  xl.
  
  for i in 1..1000000 loop
    
  end loop;
  
  xl.close_log('Successfully completed');
exception
 when others then
  xl.close_log(sqlerrm);
  raise;
end;
/

with
  driver(rnum) as
  (
    select 1 rnum from dual
    union all
    select rnum+1 from driver
    where rnum < 101
  )
select rnum-1 num, round(sin((rnum-1)*3.14159265358/50),10) val
from driver;
