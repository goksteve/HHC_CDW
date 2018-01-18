define TABLE=&1

call xl.begin_action('Copying &TABLE data');

@@copy_from CBN
@@copy_from GP1
@@copy_from GP2
@@copy_from NBN
@@copy_from NBX
@@copy_from SMN

call xl.end_action();
