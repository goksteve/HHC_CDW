select * from table(dbms_xplan.display_cursor(null,null,'iostats last'));
