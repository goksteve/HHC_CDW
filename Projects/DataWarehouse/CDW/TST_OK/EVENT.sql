CREATE TABLE event
(
  NETWORK                   CHAR(3 BYTE) NOT NULL,
  visit_id                  NUMBER(12) NOT NULL,
  event_id                  NUMBER(15) NOT NULL,
  date_time                 DATE,
  event_status_id           NUMBER(12),
  event_type_id             NUMBER(12),
  patient_schedule_display  VARCHAR2(100 BYTE),
  cid                       NUMBER(14),
  event_interface_id        VARCHAR2(128 BYTE),
  CONSTRAINT fk_event_visit FOREIGN KEY(network, visit_id) REFERENCES visit(network, visit_id)
)
COMPRESS BASIC
PARTITION BY REFERENCE (fk_event_visit);


