bcp.exe fact.PatientVisitCorporate format nul -c -x -f CONTROL/fact_PatientVisitCorporate.xml -t"|" -S "CORPSQLDEVDSC.CORP.NYCHHC.ORG,51283" -d EDDashboard -T
bcp.exe fact.PatientVisitCorporate out DATA/fact_PatientVisitCorporate.dat -f CONTROL/fact_PatientVisitCorporate.xml -S "CORPSQLDEVDSC.CORP.NYCHHC.ORG,51283" -d EDDashboard -T
sqlldr userid=eddashboard/Compa55ED@higgsdv2 control=CONTROL/fact_PatientVisitCorporate.ctl data=DATA/fact_PatientVisitCorporate.dat direct=true
