LOAD DATA APPEND INTO TABLE ref_hedis_value_sets
FIELDS TERMINATED BY x'09'
(
  Value_Set_Name,
  Value_Set_OID,
  Value_Set_Version,
  Code,
  Definition char(512),
  Code_System,
  Code_System_OID,
  Code_System_Version
)