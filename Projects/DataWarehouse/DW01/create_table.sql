define TABLE=&1

prompt Creating table &TABLE in all source databases ...
@@create_table_in_db CBN  
@@create_table_in_db GP1  
@@create_table_in_db GP2  
@@create_table_in_db NBN  
@@create_table_in_db NBX  
@@create_table_in_db SMN