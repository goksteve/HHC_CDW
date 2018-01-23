CREATE TABLE dim_nyc_hc_networks
(
  network_cd  CHAR(3) CONSTRAINT dim_nyc_hc_networks_pk PRIMARY KEY,
  name        VARCHAR2(63) NOT NULL
);

INSERT INTO dim_nyc_hc_networks VALUES('CBN', 'Central Brooklyn');
INSERT INTO dim_nyc_hc_networks VALUES('GP1', 'Nothern Manhattan Gen 1');
INSERT INTO dim_nyc_hc_networks VALUES('GP2', 'Nothern Manhattan Gen 2');
INSERT INTO dim_nyc_hc_networks VALUES('NBN', 'North Brooklyn');
INSERT INTO dim_nyc_hc_networks VALUES('NBX', 'North Bronx');
INSERT INTO dim_nyc_hc_networks VALUES('QHN', 'Queens Health');
INSERT INTO dim_nyc_hc_networks VALUES('SBN', 'South Brooklyn');
INSERT INTO dim_nyc_hc_networks VALUES('SMN', 'South Manhattan');
INSERT INTO dim_nyc_hc_networks VALUES('NYH', 'New York Health Organization');
INSERT INTO dim_nyc_hc_networks VALUES('USH', 'United States Health Organization');

COMMIT;