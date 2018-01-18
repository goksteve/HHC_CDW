CREATE TABLE meta_condition_types
(
  condition_type_cd  VARCHAR2(6) CONSTRAINT meta_condition_types_pk PRIMARY KEY,
  DESCRIPTION        VARCHAR2(1023) NOT NULL
);

Insert into META_CONDITION_TYPES(condition_type_cd, description) Values('EI', 'Data Element ID');
Insert into META_CONDITION_TYPES(condition_type_cd, description) Values('EN', 'Data Element Name');
Insert into META_CONDITION_TYPES(condition_type_cd, description) Values('PI', 'Procedure ID');
Insert into META_CONDITION_TYPES(condition_type_cd, description) Values('PN', 'Procedure Name'); 
Insert into META_CONDITION_TYPES(condition_type_cd, description) Values('DI', 'Diagnosis');
Insert into META_CONDITION_TYPES(condition_type_cd, description) Values('MED', 'Medication');

COMMIT;

GRANT SELECT ON meta_condition_types TO PUBLIC;