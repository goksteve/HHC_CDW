CREATE OR REPLACE VIEW v_fact_proc_events AS
 -- 5-FEB-2018, OK: created
SELECT *
FROM proc_event pe
JOIN event e
  ON e.network = pe.network AND e.visit_id = pe.visit_id AND e.event_id = pe.event_id
LEFT JOIN proc_event_archive pea
  ON pea.network = pe.network AND pea.visit_id = pe.visit_id AND pea.event_id = pe.event_id
LEFT JOIN proc_event_archive_type peat
  ON peat  