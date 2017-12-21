whenever sqlerror exit 1
set feedback off

prompt Importing source data from 6 CDW databases ...

rem truncate table IMP_STREET_ADDRESSES;
rem @@copy_table STREET_ADDRESSES

truncate table tst_ok_other_facilities;
@@copy_table OTHER_FACILITY

exit 0
