exec dbm.drop_tables('EDD_QMED_DISPOSITIONS');

SET DEFINE OFF

CREATE TABLE edd_qmed_dispositions
(
  DispositionKey    NUMBER(10,0) CONSTRAINT pk_edd_qmed_dispositions PRIMARY KEY,
  Disposition       VARCHAR2(1000) CONSTRAINT uk_edd_qmed_dispositions UNIQUE NOT NULL,
  DispositionLookup VARCHAR2(1000),
  common_name       VARCHAR2(30) NOT NULL,
  disposition_class VARCHAR2(30) AS
  (
    CASE
      WHEN DispositionLookup in ('Discharged to Home or Self Care','Transferred to Skilled Nursing Facility','Transferred to Another Hospital','Transferred to Psych ED') THEN 'DISCHARGED'
      WHEN dispositionLookup = 'Admitted as Inpatient' THEN 'ADMITTED'
    END
  ),
  CONSTRAINT fk_edd_qmed_common_disp FOREIGN KEY(common_name) REFERENCES edd_dim_dispositions
) COMPRESS BASIC;

GRANT SELECT ON edd_qmed_dispositions TO PUBLIC;

INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(-1,'Unknown','Unknown','Unknown');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(2,'Admitted as an Inpatient','Admitted as Inpatient','Admitted');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(3,'Admitted to Observation Unit','Admitted to Observation Unit','Observation');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(4,'Discharged to Home or Self Care','Discharged to Home or Self Care','Discharged');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(5,'Expired','Expired','Expired');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(6,'Left Against Medical Advice','Left Against Medical Advice','Left Against Medical Advice');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(7,'Left Without Being Seen','Left Without Being Seen','Left Without Being Seen');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(8,'Transferred to Another Hospital','Transferred to Another Hospital','Transfer to Another Facility');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(9,'Transferred to Psych ED','Transferred to Psych ED','Transfer to Psych ED');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(10,'Walked Out During Evaluation','Walked Out During Evaluation','Eloped');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(11,'Transferred to Observation Unit','Transferred to Observation Unit','Observation');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(12,'Transferred to a Skilled Nursing Facility (SNF)','Transferred to Skilled Nursing Facility','Transfer to Another Facility');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(13,'Transferred to Skilled Nursing Facility (SNF)','Transferred to Skilled Nursing Facility','Transfer to Another Facility');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(14,'Admitted as Inpatient','Admitted as Inpatient','Admitted');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(15,'Walked Out During Evaluation (Eloped)','Walked Out During Evaluation','Eloped');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(16,'Admitted to AmbSurg <23 hours','Admitted to AmbSurg <23 hours','Ambulatory Surgery');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(17,'Discharged to Home or Self-Care','Discharged to Home or Self Care','Discharged');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(18,'Transferred to Skilled Nursing Facility','Transferred to Skilled Nursing Facility','Transfer to Another Facility');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(19,'Extended monitoring on L&D','Extended monitoring on L&D','Extended monitoring');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(20,'Transferred to Observation Unit (CPOU)','Transferred to Observation Unit','Observation');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(21,'Discharged to home or self care (or in Custody)','Discharged to Home or Self Care','Discharged');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(22,'Extended monitoring on L\T\D','Extended monitoring on L\T\D','Extended monitoring');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(23,'Transferred to Chest Pain Unit (<23 hrs)','Transferred to Chest Pain Unit (<23 hrs)','Transferred');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(24,'Discharged to Skilled Nursing Facility (SNF)','Discharged to Skilled Nursing Facility','Transfer to Another Facility');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(25,'Admit to Observation Unit','Admitted to Observation Unit','Observation');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(26,'Transferred to Observation Unit (EDOU)','Transferred to Observation Unit','Observation');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(27,'Dsch/Transf to Correctional Facility','','Correctional Facility');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(28,'Transfer to Observation Unit','','Observation');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(29,'Hold for Observation Status','','Observation');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(30,'Placed in Observation','','Observation');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(31,'Assign to Observation','','Observation');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(32,'Assigned to Observation','','Observation');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(33,'Refer to Observation Status','','Observation');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(34,'Observation','','Observation');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(35,'Placed on Observation','','Observation');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(36,'Place on Observation (EDOU)','','Observation');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(37,'Transferred to another Psych Hospital','','Transfer to Another Facility');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(38,'Admitted to Psych Inpatient','','Admitted');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(39,'Transferred to a State Facility','','Transfer to Another Facility');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(40,'Transferfed to Home Care Facility','','Transfer to Another Facility');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(41,'Transferred to Chest Pain Unit (<23 hrs) Observation','Transferred to Chest Pain Unit (<23 hrs)','Transferred');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(42,'Placed in Observation in Short Stay Unit','','Observation');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(43,'Transfer to Ambulatory Surgery','','Ambulatory Surgery');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(44,'Admitted to OB/GYN IP Service','','Admitted');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(45,'Admited for emergency ambulatory surgery','','Ambulatory Surgery');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(46,'Transfer for emergency ambulatory surgery','','Ambulatory Surgery');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(47,'Admitted for emergency ambulatory surgery','','Ambulatory Surgery');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(48,'Admit to inpatient: I attest that meets clinical criteria for inpatient service greater than two midnights.','Admitted as Inpatient','Admitted');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(49,'Ambulatory Surgery < 23 Hrs Stay','','Ambulatory Surgery');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(50,'ED Observation','','Observation');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(51,'Walked Out During Treatment','Walked Out During Evaluation','Eloped');
INSERT INTO edd_qmed_dispositions(DispositionKey, Disposition, DispositionLookup, common_name) VALUES(52,'Discharged to AmbSurgery','','Ambulatory Surgery');
 
COMMIT;
