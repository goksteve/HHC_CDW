CREATE OR REPLACE VIEW v_fact_proc_events AS
 -- 5-FEB-2018, OK: created
SELECT *
FROM proc_event pe
JOIN dim_procedures pr
  ON pr.network = pe.network AND pr.src_proc_id = pe.proc_id
JOIN event e
  ON e.network = pe.network AND e.visit_id = pe.visit_id AND e.event_id = pe.event_id
LEFT JOIN dim_hc_facilities f1
  ON f1.network = pe.network AND f1.src_facility_id = pe.facility_id

/*
LEFT JOIN proc_event_archive pea
  ON pea.network = pe.network AND pea.visit_id = pe.visit_id AND pea.event_id = pe.event_id
LEFT JOIN ref_proc_event_archive_types peat
  ON peat.archive_type_id = pea.archive_type_id;
*/