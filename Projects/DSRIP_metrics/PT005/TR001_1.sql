-- One-time DDL:
@TR001_VISITS.sql
@TR001_DIAGNOSES.sql
@TR001_PAYERS.sql
@TR001_PROVIDERS.sql
@REF_HEDIS_VALUE_SETS.sql

select count(1) cnt -- 109,832
from ref_hedis_value_sets;

-- ========= Visits =====================
truncate table tst_ok_tr001_visits;
@copy_table.sql TR001_VISITS

select network, count(1) cnt,
  max(discharge_dt) max_dt,
  min(discharge_dt) min_dt
from tst_ok_tr001_visits
group by network order by network;
-- CBN: 264,288
-- GP1: 451,988
-- GP2: 130,237
-- NBN: 181,235
-- NBX: 204,580
-- SMN: 256,516

-- =========== Diagnoses ================
truncate table tst_ok_tr001_diagnoses;
@copy_table.sql TR001_DIAGNOSES

select network, count(1) cnt
from tst_ok_tr001_diagnoses
group by network order by network;

-- ============ Providers ================
truncate table tst_ok_tr001_providers;
@copy_table.sql TR001_PROVIDERS

select network, count(1) cnt
from tst_ok_tr001_providers
group by network order by network;

-- ============ Payers ===================
truncate table tst_ok_tr001_payers;
@copy_table.sql TR001_PAYERS

select network, count(1) cnt
from tst_ok_tr001_payers
group by network order by network;
