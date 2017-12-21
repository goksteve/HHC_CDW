column network new_value nw  

select substr(name, 1, 3) network from v$database; 

COPY FROM cdw/cdw@higgsdv3 APPEND ref_clinic_codes USING -
SELECT * FROM cd_clinic_codes_dimension -
where network = '&nw';

exit