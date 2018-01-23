select * from v_pqi90_7_detail_cdw;
select * from v_pqi90_8_detail_cdw;
select * from v_pqi90_summary_cdw;

select * from pt008.payer_mapping
where payer_name = 'M11 Medicaid Psych DRG';

select distinct payer_group from  pt008.payer_mapping;

select * from pt008.payer_mapping  
where upper(payer_name) like '%MEDICAID%' and payer_group <> 'Medicaid'; 