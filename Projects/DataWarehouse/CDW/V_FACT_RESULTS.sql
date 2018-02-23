CREATE OR REPLACE VIEW v_fact_results AS
SELECT
 -- 22-Feb-2018, OK: created
  r.network,
  r.visit_id,
  r.event_id,
  r.result_report_number,
  r.multi_field_occurrence_number,
  r.item_number,
  e.date_time AS result_dt,
  v.patient_key,
  NVL(pef.facility_key, p.facility_key) AS proc_facility_key,
  p.proc_key,
  e.event_status_id,
  e.event_type_id,
  r.data_element_id,
  r.value AS result_value,
  rf.decode_source_id,
  vd.decoded_value,
  r.cid,
  SYSDATE AS load_dt
FROM result r
JOIN proc_event pe ON pe.network = r.network AND pe.visit_id = r.visit_id AND pe.event_id = r.event_id
JOIN event e ON e.network = r.network AND e.visit_id = r.visit_id AND e.event_id = r.event_id
JOIN result_field rf ON rf.network = r.network AND rf.data_element_id = r.data_element_id
JOIN dim_procedures p ON p.network = pe.network AND p.src_proc_id = pe.proc_id AND p.source = 'QCPR'
JOIN fact_visits v ON v.network = r.network AND v.visit_id = r.visit_id
LEFT JOIN value_decode vd ON vd.network = r.network AND vd.decode_source_id = rf.decode_source_id AND vd.encoded_value = r.value
LEFT JOIN dim_hc_facilities pef ON pef.network = pe.network AND pef.facility_id = pe.facility_id;
