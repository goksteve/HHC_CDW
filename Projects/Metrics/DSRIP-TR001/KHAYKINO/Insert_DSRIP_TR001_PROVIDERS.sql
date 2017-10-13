prompt Populating table DSRIP_TR001_PROVIDERS ... 

TRUNCATE TABLE dsrip_tr001_providers;

INSERT INTO dsrip_tr001_providers
 SELECT network, visit_id, attending_emp_provider_id AS provider_id
 FROM dsrip_tr001_visits
 WHERE attending_emp_provider_id IS NOT NULL
UNION 
 SELECT network, visit_id, resident_emp_provider_id AS provider_id
 FROM dsrip_tr001_visits
 WHERE resident_emp_provider_id IS NOT NULL
UNION
 SELECT --+ noparallel index(pea) 
   v.network, v.visit_id, pea.emp_provider_id AS provider_id
 FROM dsrip_tr001_visits v
 JOIN ud_master.proc_event_archive pea
  ON pea.visit_id = v.visit_id AND pea.emp_provider_id IS NOT NULL;

COMMIT;