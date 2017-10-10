call xl.begin_action('Executing procedure in 6 databases');

host sqlplus /nolog @exec_my_proc CBN
host sqlplus /nolog @exec_my_proc GP1
host sqlplus /nolog @exec_my_proc GP2
host sqlplus /nolog @exec_my_proc NBN
host sqlplus /nolog @exec_my_proc NBX
host sqlplus /nolog @exec_my_proc SMN

call xl.end_action();
