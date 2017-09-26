CREATE OR REPLACE FUNCTION insurance_type(p_plan_group IN VARCHAR2) RETURN VARCHAR2 RESULT_CACHE AS
BEGIN
  RETURN CASE
    WHEN p_plan_group IN ('Medicaid', 'Medicare') OR p_plan_group IS NULL THEN p_plan_group
    WHEN p_plan_group = 'UNINSURED' THEN 'Self pay'
    ELSE 'Commercial'
  END;
END;
/

ALTER FUNCTION insurance_type COMPILE PLSQL_CODE_TYPE=NATIVE REUSE SETTINGS;

select * from user_PLSQL_OBJECT_SETTINGS where name = 'INSURANCE_TYPE';