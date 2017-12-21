COPY FROM khaykino/Window_12@&1.DW01 APPEND imp_street_addresses USING -
SELECT * FROM exp_street_addresses;
