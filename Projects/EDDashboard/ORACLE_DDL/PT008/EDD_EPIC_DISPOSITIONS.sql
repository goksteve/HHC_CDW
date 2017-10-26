set define off

exec dbm.drop_tables('EDD_EPIC_DISPOSITIONS');

CREATE TABLE edd_epic_dispositions
(
  id          NUMBER(10) CONSTRAINT pk_edd_epic_dispositions PRIMARY KEY,
  epic_name   VARCHAR2(64) NOT NULL,
  common_name VARCHAR2(30) NOT NULL,
  title       VARCHAR2(64) NOT NULL,
  abbr        VARCHAR2(20) NOT NULL,
  CONSTRAINT fk_edd_epic_common_disp FOREIGN KEY(common_name) REFERENCES edd_dim_dispositions
);

GRANT SELECT ON edd_epic_dispositions TO PUBLIC; 

INSERT INTO edd_epic_dispositions VALUES(1,'Discharge','Discharged','DISCHARGE','Discharge');
INSERT INTO edd_epic_dispositions VALUES(2,'Transfer to Another Facility','Transferred','TRANSFER TO ANOTHER FACILITY','Transfer');
INSERT INTO edd_epic_dispositions VALUES(3,'Admit','Admitted','ADMIT','Admit');
INSERT INTO edd_epic_dispositions VALUES(4,'AMA','Left Against Medical Advice','AMA','AMA');
INSERT INTO edd_epic_dispositions VALUES(5,'Eloped','Eloped','ELOPED','Eloped');
INSERT INTO edd_epic_dispositions VALUES(6,'LWBS before Triage','Left Without Being Seen','LWBS BEFORE TRIAGE','LWBS Before');
INSERT INTO edd_epic_dispositions VALUES(7,'LWBS after Triage','Left Without Being Seen','LWBS AFTER TRIAGE','LWBS After');
INSERT INTO edd_epic_dispositions VALUES(8,'Expired','Expired','EXPIRED','Expired');
INSERT INTO edd_epic_dispositions VALUES(9,'Send to L&D','Transferred','SEND TO L&D','Send to L&D');
INSERT INTO edd_epic_dispositions VALUES(10,'Observation','Observation','OBSERVATION','Obs');
INSERT INTO edd_epic_dispositions VALUES(11,'Transfer to Cath Lab','Transferred','TRANSFER TO CATH LAB','Cath');
INSERT INTO edd_epic_dispositions VALUES(12,'Extended Observation Unit','Extended monitoring','EXTENDED OBSERVATION UNIT','EOU');
INSERT INTO edd_epic_dispositions VALUES(13,'Lincoln Hospital','Transfer to Another Facility','LINCOLN HOSPITAL','Lincoln Hosp');
INSERT INTO edd_epic_dispositions VALUES(14,'North Central Bronx','Transfer to Another Facility','NORTH CENTRAL BRONX','North Centra');
INSERT INTO edd_epic_dispositions VALUES(15,'Jacobi Hospital','Transfer to Another Facility','JACOBI HOSPITAL','Jacobi');
INSERT INTO edd_epic_dispositions VALUES(16,'Bellevue Hospital','Transfer to Another Facility','BELLEVUE HOSPITAL','Bellevue');
INSERT INTO edd_epic_dispositions VALUES(17,'Metropolitan Hospital','Transfer to Another Facility','METROPOLITAN HOSPITAL','Metropolitan');
INSERT INTO edd_epic_dispositions VALUES(18,'Harlem Hospital','Transfer to Another Facility','HARLEM HOSPITAL','Harlem Hospi');
INSERT INTO edd_epic_dispositions VALUES(19,'Elmhurst Hospital','Transfer to Another Facility','ELMHURST HOSPITAL','Elmhurst Hos');
INSERT INTO edd_epic_dispositions VALUES(20,'Queens Hospital','Transfer to Another Facility','QUEENS HOSPITAL','Queens Hospi');
INSERT INTO edd_epic_dispositions VALUES(21,'Coney Island Hospital','Transfer to Another Facility','CONEY ISLAND HOSPITAL','Coney Island');
INSERT INTO edd_epic_dispositions VALUES(22,'Kings County Hospital','Transfer to Another Facility','KINGS COUNTY HOSPITAL','Kings County');
INSERT INTO edd_epic_dispositions VALUES(23,'Woodhull Hospital','Transfer to Another Facility','WOODHULL HOSPITAL','Woodhull Hos');
INSERT INTO edd_epic_dispositions VALUES(24,'Riker''s Correctional Facility','Correctional Facility','RIKER''S CORRECTIONAL FACILITY','Riker''s Corr');
INSERT INTO edd_epic_dispositions VALUES(25,'Send to OR','Transferred','SEND TO OR','Send to OR');
INSERT INTO edd_epic_dispositions VALUES(26,'Send to Peds ED','Transferred','SEND TO PEDS ED','Peds ED');
INSERT INTO edd_epic_dispositions VALUES(27,'Send to Adult ED','Transferred','SEND TO ADULT ED','Adult ED');
INSERT INTO edd_epic_dispositions VALUES(28,'Place in Amb Surg','Ambulatory Surgery','PLACE IN AMB SURG','Amb Surg');
INSERT INTO edd_epic_dispositions VALUES(29,'Send to CPEP/PES','Transferred','SEND TO CPEP/PES','CPEP / PES');
INSERT INTO edd_epic_dispositions VALUES(30,'Admitted Patient - Discharged by IP Team','Discharged','ADMITTED PATIENT - DISCHARGED BY IP TEAM','BoarderDisch');
INSERT INTO edd_epic_dispositions VALUES(31,'LDE / Left During Evaluation','Eloped','LDE / LEFT DURING EVALUATION','LDE');

COMMIT;
