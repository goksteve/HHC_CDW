set line 100
set verify off
set feedback off
set serverout on

ALTER SESSION ENABLE PARALLEL DML;
ALTER SESSION SET STAR_TRANSFORMATION_ENABLED=TRUE;

column 1 new_value 1
select '' "1" from dual where rownum = 0;
define MON='&1'

begin
  dbms_session.set_identifier(NVL('&MON', TRUNC(SYSDATE, 'MONTH')));
  dbms_output.put_line('Month: '||SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER'));
end;
/

@Insert_TR016_A1C_GLUCOSE_RSLT.sql
@Insert_TR016_PAYERS.sql

exit