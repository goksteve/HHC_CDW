/* One-time DDL:
@TST_OK_PRESCRIPTIONS.sql
@TST_OK_DRUG_NAMES.sql
@TST_OK_DRUG_DESCRIPTIONS.sql
@TST_OK_TR016_A1C_GLUCOSE_LVL.sql
*/
select * 
from meta_criteria
where criterion_cd like '%BIPOLAR%'
or criterion_cd like '%SCHIZO%' 
or criterion_cd like '%PSYCH%'
or criterion_cd like '%DIABET%' 
or criterion_cd like '%A1C%' 
or criterion_cd like '%LDL%' 
or criterion_cd like '%GLU%' 
order by 1
;

-- Every month:
prompt Preparing DSRIP report TR016

exec xl.open_log('DSRIP-TR016', 'Preparing DSRIP report TR016', TRUE);
exec xl.begin_action('Truncating staging tables');
truncate table TST_OK_TR016_A1C_GLUCOSE_LVL;
exec xl.end_action;

@copy_table.sql TR016_A1C_GLUCOSE_LVL
/*
select
  cr.criterion_id, cr.criterion_cd, cr.description, c.network, c.condition_type_cd, c.qualifier, c.value
from meta_criteria cr
join meta_conditions c on c.criterion_id = cr.criterion_id
where cr.criterion_id 
--in (6, 31, 32, 33, 34*)
in (4, 10, 23)
order by 1, 2, 3; 

--@DSRIP_TR016_DENOMINATOR.sql

exec dbms_session.set_identifier(ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'),-24));
select SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER') from dual;

select * from tst_ok_prescriptions where drug_name is null;

--CREATE OR REPLACE VIEW v_dsrip_report_tr016 AS;
WITH
  pr AS
  ( 
    SELECT --+ materialize
      pr.network,
      pr.patient_id,
      MIN(pr.order_dt) start_dt,
      MAX(NVL(pr.rx_dc_dt, TRUNC(SYSDATE))) end_dt
    FROM tst_ok_prescriptions pr
    LEFT JOIN tst_ok_drug_names dn ON dn.drug_name = pr.drug_name 
    LEFT JOIN tst_ok_drug_descriptions dd ON dd.drug_description = pr.drug_description 
    WHERE dn.drug_type = 'ANTIPSYCHOTIC' OR dd.drug_type = 'ANTIPSYCHOTIC'
    GROUP BY pr.network, pr.patient_id
  ),
  dd AS
  (
    SELECT DISTINCT --+ materialize 
      dd.network,
      dd.patient_id,
      MIN(onset_date) onset_date
    FROM patient_diag_dimension dd
    JOIN meta_conditions lkp
      ON lkp.qualifier = DECODE(dd.diag_coding_scheme, '5', 'ICD9', 'ICD10')
     AND lkp.value = dd.diag_code AND lkp.criterion_id = 6 -- DIAGNOSIS:DIABETES
    WHERE dd.diag_coding_scheme IN (5, 10)
    GROUP BY dd.network, dd.patient_id
  )
SELECT COUNT(1) cnt FROM dd;

select distinct qualifier
from meta_conditions where criterion_id = 6;

First Name
Last Name
DOB
Age
Is Medicaid patient? – Yes/No (in lieu of CIN) – if Medicaid exists as any of the patients payer, flag yes
MRN
Facility
Speciality
Dates of service for any BH providers involved in care (e.g. Social Worker, Psychologist, Psychiatrist)
Name of BH Provider
Payer
Plan
PCP - General Med
Date of last PCP Visit
*/