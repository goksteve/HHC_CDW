bcp.exe dim.%1 format nul -c -x -f CONTROL/%1.xml -t"|" -S "CORPSQLDEVDSC.CORP.NYCHHC.ORG,51283" -d EDDashboard -T
bcp.exe dim.%1 out DATA/%1.dat -f CONTROL/%1.xml -S "CORPSQLDEVDSC.CORP.NYCHHC.ORG,51283" -d EDDashboard -T
sqlldr userid=eddashboard/Compa55ED@higgsdv2 control=CONTROL/%1.ctl data=DATA/%1.dat direct=true errors=0