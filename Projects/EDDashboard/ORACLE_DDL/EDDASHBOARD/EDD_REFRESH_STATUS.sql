CREATE TABLE edd_refresh_status
(
  refresh_status CHAR(1) CHECK(refresh_status IN ('C','R')),
  start_timestamp DATE,
  end_timestamp DATE
);

INSERT INTO edd_refresh_status VALUES ('C', DATE '2001-01-01', DATE '2001-01-01');
COMMIT;

GRANT SELECT ON edd_refresh_status TO PUBLIC;
