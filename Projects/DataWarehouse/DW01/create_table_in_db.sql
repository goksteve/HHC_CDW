define DB=&1

prompt - Creating table &TABLE in &DB.DW01 database 
conn khaykino/&pwd@&DB.DW01
@@&TABLE..sql
