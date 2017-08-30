set define off

merge into meta_conditions t
using
(
  SELECT 'CBN' network, 4 criterion_id, 'EI' condition_type_cd, 'NONE' qualifier, 'AG/1353/2/1155/1' value, 'Hgb A1C  (%)' value_description, 'OR' logical_operator, '=' comparison_operator, 'Y' hint_ind FROM dual UNION ALL
  SELECT 'CBN', 4, 'EI', 'NONE', 'AG/1411/1/1297/22', 'HgbA1C level', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'CBN', 4, 'EI', 'NONE', 'AG/1652/1/1224/1', 'Hgb A1C       (%)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'CBN', 4, 'EI', 'NONE', 'AG/1922/2/1400/1', 'Hgb A1C       (%)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'CBN', 4, 'EI', 'NONE', 'MC/5409/22/604/91', 'Hgb A1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'CBN', 4, 'EI', 'NONE', 'MC/5421/22/604/91', 'Hgb A1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'CBN', 4, 'EI', 'NONE', 'MC/5800/89/604/91', 'Hgb A1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'CBN', 4, 'EI', 'NONE', 'MC/6539/22/604/91', 'Hgb A1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'CBN', 4, 'EI', 'NONE', 'MC/6540/22/604/91', 'Hgb A1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'CBN', 4, 'EI', 'NONE', 'MC/6553/137/604/91', 'Hgb A1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'CBN', 4, 'EI', 'NONE', 'MC/7164/89/740/12', 'Hgb A1C   (%)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'CBN', 4, 'EI', 'NONE', 'MC/7165/92/740/12', 'Hgb A1C   (%)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'CBN', 4, 'EI', 'NONE', 'MC/7390/140/740/12', 'Hgb A1C   (%)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'CBN', 4, 'EI', 'NONE', 'MC/7391/135/740/12', 'Hgb A1C   (%)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'CBN', 4, 'EI', 'NONE', 'MC/7804/92/740/12', 'Hgb A1C   (%)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'CBN', 4, 'EI', 'NONE', 'MC/7805/89/740/12', 'Hgb A1C   (%)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'CBN', 4, 'EI', 'NONE', 'MC/8292/140/740/12', 'Hgb A1C   (%)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'CBN', 4, 'EI', 'NONE', 'MC/8293/92/740/12', 'Hgb A1C   (%)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'CBN', 4, 'EI', 'NONE', 'MC/8375/89/740/12', 'Hgb A1C   (%)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'CBN', 4, 'EI', 'NONE', 'MC/8885/140/740/12', 'Hgb A1C   (%)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'CBN', 4, 'EI', 'NONE', 'MC/9081/22/604/91', 'Hgb A1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'CBN', 4, 'EI', 'NONE', 'MC/9370/140/740/12', 'Hgb A1C   (%)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'CBN', 4, 'EI', 'NONE', 'MC/9378/92/740/12', 'Hgb A1C   (%)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'CBN', 4, 'EI', 'NONE', 'MC/9379/135/740/12', 'Hgb A1C   (%)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'CBN', 4, 'EI', 'NONE', 'MC/9380/89/740/12', 'Hgb A1C   (%)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'CBN', 4, 'EI', 'NONE', 'MC/9850/92/740/12', 'Hgb A1C   (%)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'CBN', 4, 'EI', 'NONE', 'MC/9851/135/740/12', 'Hgb A1C   (%)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'CBN', 4, 'EI', 'NONE', 'MC/9852/89/740/12', 'Hgb A1C   (%)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'CBN', 4, 'EI', 'NONE', 'RD/2825/6', 'Hgb A1C (%)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'CBN', 4, 'EI', 'NONE', 'RD/5315/6', 'Hgb A1C (%)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'CBN', 4, 'PI', 'NONE', '11901', 'Nutrition Monthly Note Dialysis', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'CBN', 4, 'PI', 'NONE', '11922', 'Nutrition Assessment IP Pediatric', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'CBN', 4, 'PI', 'NONE', '11948', 'Nutrition Followup IP Pediatric', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'CBN', 4, 'PI', 'NONE', '11950', 'Nutrition Followup IP Adult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'CBN', 4, 'PI', 'NONE', '12092', 'Nutrition Assessment IP Adult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'CBN', 4, 'PI', 'NONE', '12564', 'Nutrition Assessment(Clinic)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'CBN', 4, 'PI', 'NONE', '15124', 'Nutrition Assessment (Adult)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'CBN', 4, 'PI', 'NONE', '15970', 'Nutrition Assessment (Peds)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'CBN', 4, 'PI', 'NONE', '16870', 'Internal Medicine:PreOP Inpatient Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'CBN', 4, 'PI', 'NONE', '17362', 'Ambcare Note: PreOP Medicine Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'CBN', 4, 'PI', 'NONE', '17401', 'Pre-Op Medicine Clinic Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'CBN', 4, 'PI', 'NONE', '17932', 'Initial Assessment (Geriatric Clinic Nurse)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'CBN', 4, 'PI', 'NONE', '17943', 'Initial Assessment (Geriatric Clinic Nurse)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'CBN', 4, 'PI', 'NONE', '18206', 'Ambcare Note: PreOP Medicine Followup', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'CBN', 4, 'PI', 'NONE', '18436', 'Nutrition Assessment(Psych Clinic)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'CBN', 4, 'PI', 'NONE', '18586', 'Medicine Pre-OP Evaluation', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'CBN', 4, 'PI', 'NONE', '10330', 'Glycated A1C Hemoglobin Level', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'CBN', 4, 'PI', 'NONE', '16178', 'Glycated A1C Hemoglobin Level for Patient Dashboard', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'CBN', 4, 'PI', 'NONE', '7433', 'Glycated A1C Hemoglobin Level', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'CBN', 4, 'PI', 'NONE', '8416', 'Glycated A1C Hemoglobin Level', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP1', 4, 'EN', 'NONE', '%A1C (R)%', '', 'AND', 'NOT LIKE', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'EN', 'NONE', '%A1C%NEVER%USED%', '', 'AND', 'NOT LIKE', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'EN', 'NONE', '%A1C%ORDER%', '', 'AND', 'NOT LIKE', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'EN', 'NONE', '%CURRENT HBA1C%', '', 'AND', 'NOT LIKE', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'EN', 'NONE', '%EQUIVALENT HEMOGLOBIN A1C%', '', 'AND', 'NOT LIKE', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'EN', 'NONE', '%GLYCATED A1C HEMOGLOBIN%', '', 'AND', 'NOT LIKE', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'EN', 'NONE', '%GLYCOSYLATED HBG (HGB A1C) TWICE A YEAR%', '', 'AND', 'NOT LIKE', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'EN', 'NONE', '%HGA1C-HIS%', '', 'AND', 'NOT LIKE', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'EN', 'NONE', '%HGB A1C COMMENT%', '', 'AND', 'NOT LIKE', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'EN', 'NONE', '%HGBA1C%TRIMESTER%', '', 'AND', 'NOT LIKE', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'EN', 'NONE', '%LAST HEMOGLOBIN A1C%', '', 'AND', 'NOT LIKE', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'EN', 'NONE', '%LAST%A1C%', '', 'AND', 'NOT LIKE', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'EN', 'NONE', '%MOST RECENT HGB A1C%', '', 'AND', 'NOT LIKE', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'EN', 'NONE', '%ORDER%A1C%', '', 'AND', 'NOT LIKE', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'EN', 'NONE', '%REVIEW GLU/A1C,HGB,FERR,IRON SATURATION%', '', 'AND', 'NOT LIKE', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'EN', 'NONE', '%A1C%', '', 'AND', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '12135', 'Comprehensive Discharge Summary (Psychiatry)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '12562', 'zzVisit Note (Endocrine/Diabetic)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '14278', 'Progress Note By Physician (Surgery)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '14279', 'Palliative Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '14979', 'Attending Progress Note (MICU)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '15039', 'Preoperative  Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '15642', 'Cardiology Consult (Adult)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '24823', 'Visit Note (Pediatric)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '24850', 'Diabetes Screening', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '26225', 'Consultation (Med)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '27928', 'Pharmacotherapy Note (Inpatient)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '29142', 'GI Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '29317', 'History & Physical (PICU)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '29320', 'Progress Note By Physician (OBS)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '29431', 'Visit Note (Pediatric)*', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '29533', 'Visit Note (Pain/Palliative) By', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '29572', 'Comprehensive Discharge Summary (Medicine)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '29594', 'Visit Note (Surgery) Initial', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '29634', 'Diabetes Screening', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '29682', 'History & Physical (Medicine)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '29741', 'On Call Attending Note (Medicine)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '29852', 'ED MD Disposition Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '29854', 'ED MD Progress Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '29878', 'Visit Note (APC) (DM) By', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '29937', 'Visit Note (APC/DM)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '29986', 'Visit Note (Surgery) Initial', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30015', 'Visit Note (Pediatric Endocrine/Diabetes/Obesity)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30016', 'Visit Note (Pediatric Endo/Diabetes/Obesity) By', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30070', 'Visit Note (Peds Endocrine/Diabetes/Obestiy)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30072', 'Visit Note (Peds Endo/Diabetes/Obesity)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30247', 'Progress Note By Medical Student', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30295', 'Visit Note (Surgery) Subsequent', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30297', 'Visit Note (Surgical Pediatrics) Initial', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30306', 'Visit Note (Neurosurgery) Initial', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30307', 'Visit Note (Vascular Surgery)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30311', 'Procedure Testing For Q/A Only (Coding Scheme)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30315', 'Visit Note (Surgical Oncology) Comprehensive', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30337', 'MICU Attending/Fellow Progress Note By', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30341', 'Visit Note (Thoracic Surgery) Initial', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30376', 'Visit Note (Vascular Surg) Subsequent', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30382', 'Visit Note (Adolescent)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30384', 'Visit Note (Acute Illness/Follow Up)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30404', 'History & Physical (Surgery)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30407', 'Visit Note (Podiatric Surgery) Initial', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30433', 'Visit Note (Surgical Pediatrics) Subsequent', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30436', 'Visit Note (Hand)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30437', 'Visit Note (Plastic)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30450', 'Visit Note (ENT Surgery) Initial', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30471', 'Medicine Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30472', 'Dermatology Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30473', 'Endocrine Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30474', 'Ethics Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30475', 'Geriatrics Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30476', 'Hematology/Oncology Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30477', 'Infectious Disease Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30478', 'Obstetrics Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30479', 'MICU/CCU Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30480', 'Neurology Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30481', 'Neurosurgery Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30482', 'Orthopedic Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30483', 'Pediatric Adolescent Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30484', 'Psychiatry Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30485', 'Pulmonary Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30487', 'Renal Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30488', 'Rheumatology Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30489', 'General Surgery/Trauma Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30491', 'Gynecology Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30493', 'History & Physical (GYN)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30594', 'History & Physical (Nursery)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30595', 'History & Physical (Pediatric)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30596', 'Progress Note By Physician (Nursery)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30597', 'Progress Note By Physician (Pediatric)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30621', 'Pediatric Cardiology Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30645', 'History & Physical (Oral Surgery)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30647', 'Progress Note By Attending Physician (SICU)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30655', 'Progress Note By Resident Physician (SICU)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30730', 'Food & Nutrition Initial Assessment (Hemodialysis)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30737', 'Visit Note (Pediatric Adolescent)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30744', 'Visit Note (Surgery) Initial', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30746', 'Visit Note (Surgery)Subsequent', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30786', 'Surgical Endoscopy Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30794', 'Visit Note (Pain Management)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30802', 'Progress Note By Food & Nutrition (Hemodialysis)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30807', 'Visit Note (Adolescent)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30817', 'Visit Note (APC Diabetes)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30931', 'Consultation (Surg)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30933', 'Consultation (Peds)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '30995', 'Progress Note By Physician (PICU)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31012', 'Consultation (Peds Neur,Pulm,Uro,Rheum,ChildPsych)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31013', 'Consultation (ER)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31016', 'Pediatric Neurology Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31017', 'Pediatric Pulmonary Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31018', 'Pediatric Infectious Disease Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31019', 'Inpatient Consult Follow-up Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31020', 'Progress Note By Physician (Medicine)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31028', 'Pediatric Urology Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31029', 'Pediatric Allergy/Asthma Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31075', 'Pediatric Immunology Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31076', 'Urology Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31087', 'Consultation Dental Medicine By', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31123', 'Pediatric Orthopedic Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31124', 'Pediatric Endocrine Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31125', 'Breast Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31136', 'Colorectal Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31137', 'Pediatric Surgery Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31139', 'Thoracic Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31140', 'Surgical Oncology Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31141', 'Plastic Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31142', 'Hand Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31144', 'Gynecology Follow-up Consult Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31146', 'Orthopedics Consult Note (Inpatient)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31151', 'Pediatric Genetics Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31152', 'Pediatric Dental/OMS Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31153', 'Pediatric GI Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31154', 'Pediatric Hema/Oncology Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31155', 'Pediatric CASA Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31156', 'Pediatric Renal Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31171', 'Visit Note (Oral Surgery)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31173', 'Oral Surgery Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31174', 'Progress Note By Attending Physician (Medicine)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31179', 'Hemodialysis Physician Intake Summary', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31180', 'Hemodialysis Physician Monthly Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31182', 'History & Physical ( Annual Hemodialysis )', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31183', 'On Call/Short Note By Physician (Medicine)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31186', 'Anesthesia Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31188', 'Neonatology Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31191', 'Vascular Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31212', 'Visit Note (APC Follow-up)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31213', 'Rehabilitation Consult Follow-up Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31291', 'Food & Nutrition Annual Assessment (Hemodialysis)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31292', 'Food & Nutrition Monthly Note (Hemodialysis)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31340', 'zzClinic Referral (New)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31456', 'Pain Management Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31489', 'Visit Note (APC Follow-up)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31609', 'Endocrine Consult Follow-up Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31610', 'Cardiology Consult Follow-up Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31611', 'Medicine Consult Follow-up Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31612', 'Neurology Consult Follow-up Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31613', 'Infectious Disease Consult Follow-up Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31614', 'Pulmonary Consult Follow-up Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31616', 'Gynecology Consult Follow-up Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31617', 'Obstetrics Consult Follow-up Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31619', 'Renal (Dialysis) Consult Follow-up Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31620', 'Rheumatology Consult Follow-up Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31622', 'Pain Management Consult Follow-up Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31623', 'Dermatology Consult Follow-up Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31624', 'GI Consult Follow-up Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31626', 'Vascular Consult Follow-up Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31632', 'Visit Note (Peds Initial)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31664', 'Visit Note (Rheumatology) Initial', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31666', 'Consultation (Bioethics)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31676', 'Consultation (Pain/Palliative Care)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31682', 'Visit Note (Rheumatology) Subsequent', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31699', 'Procedure Testing For Q/A Only (Family Planning)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31700', 'Clinic Referral To Medicine/Specialties', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31701', 'Clinic Referral To Surgical Specialties', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31702', 'Clinic Referral To Pediatrics/Specialties', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31716', 'Visit Note (Neurosurgery) Subsequent', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31893', 'HIV Annual Comprehensive', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31894', 'HIV Initial Comprehensive', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31900', 'HIV Routine/HIV Monitor/Intermediate-Extended', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31901', 'HIV Therapeutic Visit', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31902', 'HIV Visit/Walk-In Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31922', 'HIV Initial Comprehensive', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31923', 'HIV Annual Comprehensive', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31928', 'HIV Routine/HIV Monitor/Intermediate-Extended', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31929', 'HIV Therapeutic Visit', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31930', 'HIV Visit/Walk-In Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31936', 'HIV Annual Comprehensive', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31937', 'HIV Initial Comprehensive', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31944', 'HIV Routine/HIV Monitor/Intermediate-Extended', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31945', 'HIV Therapeutic Visit', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31946', 'HIV Visit/Walk-In Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31954', 'Palliative Consult Follow-Up Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31960', 'Medical Clearance Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31961', 'Psychiatry Consult Follow-up Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31977', 'Visit Note (Pediatric Obesity)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31991', 'Hemodialysis Monthly Note (Nursing)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '31996', 'Renal (Non Dialysis) Consult Follow-up Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '32003', 'Psychiatric Emergency Service Progress Note By Provider', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '32087', 'History & Physical (MICU)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '32088', 'Progress Note By Physician (MICU)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '32089', 'On Call/Short Note By Physician (MICU)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '32261', 'Progress Note By Attending Physician (Pulmonary)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '32340', 'History & Physical (Psychiatry)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '32341', 'Progress Note By Physician (Psychiatry)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '32357', 'Psychiatric Emergency Service Discharge Note By Provider', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '32360', 'Progress Note By Attending Physician (Psychiatry)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '32407', 'Visit Note (APC Follow-up)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '32410', 'Visit Note (Pediatric Obesity)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '32411', 'Medical Clearance Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '32412', 'Medical Clearance Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '32443', 'Visit Note (CASA)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '32471', 'Pre-Admission Screening Note (Rehabilitation Medicine)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '32522', 'Procedure Testing For Q/A Only (Nursing Amb Surg)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '32529', 'Visit Note (Interventional Neuro Radiology) Initial', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '32542', 'Visit Note (Interventional Radiology) Initial', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '32544', 'Interventional Radiology Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '32545', 'Interventional Radiology Consult Follow-up Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '32557', 'Visit Note (Surgery) Subsequent', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '32807', 'Visit Note Pediatric (Surgery)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '32837', 'On Call/Short Note By Physician (PICU)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '33156', 'ENT Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '33157', 'ENT Consult Follow-up Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '33221', 'PICU Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '33223', 'SICU Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '33224', 'SICU Consult Follow-up Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '33225', 'NICU Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '33321', 'Food & Nutrition Initial Comprehensive Re-Assessment (Hemodialysis)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '33322', 'Hemodialysis Physician Initial Comprehensive Re-Assessment Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '33578', 'History & Physical (Ambulatory Surgery)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '33738', 'Pharmacotherapy Note (Outpatient)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '33789', 'Visit Note (Breast) Subsequent', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '33790', 'Clinic Referral Psychiatry', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '34050', 'Visit Note (Geriatric)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '34075', 'Pharmacotherapy Note (Outpatient)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '34133', 'Pharmacotherapy Note (Geriatric)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '34212', 'Procedure for testing (QA) Discharge Type', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '34272', 'Pediatric Developmental Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '34274', 'Pediatric Developmental Consult Follow-Up Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '34285', 'MICU Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '34286', 'CCU Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '34377', 'Visit Transfer/Off Service By Physician (Medicine)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '34378', 'Transfer/Off Service By Physician (Medicine)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '34381', 'Visit Note (Palliative) Subsequent', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '34514', 'Consultation (Neurology/Stroke)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '34522', 'Progress Note By Pulmonary Fellow', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '34523', 'Rapid Response Team Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '34531', 'PES Progress Note By Provider', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '34701', 'PASA Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '34815', 'Psychiatry Visit Note (Medicine)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '34816', 'Pharmacotherapy Note (Hepatitis)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '34845', 'Visit Note (Annual Health Assessment)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '34889', 'Psychiatry Consult  (copy)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '35103', 'Progress Note By Physician (NICU)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '35123', 'Ophthalmology Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '35124', 'Ophthalmology Consult Follow-Up Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '35187', 'Progress Note By Physician (Psychiatry)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '20387', 'Glycated (A1C) Hemoglobin Level (BHC)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '21409', 'Glycated (A1C) Hgb (BHC)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '21966', 'POCT Hgb A1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '22310', 'Glycated (A1C) Hgb (BHC)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '23077', 'Glycated (A1C) Hemoglobin Level (BHC)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '32499', 'POCT Hgb A1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '32500', 'POCT Hgb A1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '33470', 'Hemoglobin A1C (Send Out)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '33471', 'Hemoglobin A1C (Send Out)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '33472', 'Hemoglobin A1C (Send Out)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PI', 'NONE', '33476', 'Hemoglobin A1C Level (Send Out)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP1', 4, 'PN', 'NONE', '%REVIEW A1C/FINGERSTICK GLU%', '', 'AND', 'NOT LIKE', 'N' FROM dual UNION ALL
  SELECT 'GP2', 4, 'EI', 'NONE', 'AD/327/21', 'A1c', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP2', 4, 'EI', 'NONE', 'AD/450/3', 'HgB A1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP2', 4, 'EI', 'NONE', 'AD/529/22', 'Hgb A1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP2', 4, 'EI', 'NONE', 'AG/213/3/638/13', 'A1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP2', 4, 'EI', 'NONE', 'AG/229/12/855/2', 'HbA1c', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP2', 4, 'EI', 'NONE', 'AG/229/20/864/2', 'HbA1c', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP2', 4, 'EI', 'NONE', 'AG/229/6/849/2', 'Hemoglobin A1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP2', 4, 'EI', 'NONE', 'MC/10201/42/785/14', 'HbA1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP2', 4, 'EI', 'NONE', 'MC/10203/42/789/14', 'HbA1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP2', 4, 'EI', 'NONE', 'MC/10247/42/785/14', 'HbA1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP2', 4, 'EI', 'NONE', 'MC/8395/40/738/14', 'HbA1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP2', 4, 'EI', 'NONE', 'MC/9119/42/655/14', 'HbA1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP2', 4, 'EI', 'NONE', 'RD/4243/32', 'Hemoglobin A1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP2', 4, 'EI', 'NONE', 'RD/4992/2', 'HgbA1c', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP2', 4, 'EI', 'NONE', 'RD/5600/9', 'A1C, Calculated    (%)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP2', 4, 'EI', 'NONE', 'RD/7944/1', 'A1C, Calc', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP2', 4, 'EI', 'NONE', 'RD/8515/2', 'Hemoglobin A1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP2', 4, 'EI', 'NONE', 'RD/8608/5', 'HgB A1C (%)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP2', 4, 'EI', 'NONE', 'RD/8630/9', 'Hgb A1C  (%)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '21529', 'Visit Note (Medicine)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '21585', 'Discharge Summary (Medicine)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '22814', 'Discharge Summary (Rehab)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '22884', 'Visit Note (Medicine)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '22892', 'Diabetes Screening', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '22990', 'Visit Note (Podiatry)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '23060', 'Visit Note (Podiatry)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '23168', 'Visit Note (Medication Refill/Brief Note)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '23204', 'Hemodialysis History and Physical', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '23208', 'Hemodialysis Initial Nutritional Assessment', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '23209', 'Hemodialysis Progress Note By Food & Nutrition', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '23259', 'Rehabilitation Medicine Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '23265', 'Progress Note By Attending Physician (Medicine)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '23276', 'Monofilament Test', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '23304', 'Pediatric Pre-Operative Assessment by Intern', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '23305', 'Pediatric Pre-Operative Assessment by Resident', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '23351', 'Pre-Admission Assessment (Rehabilitation Medicine)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '23354', 'Pre-Operative Note/Updated H&P', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '23583', 'Hemodialysis Physician Monthly Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '23586', 'Visit Note (Medication Refill)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '24559', 'Visit Note Adult Intake (Psychiatry)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '24586', 'Visit Note Follow-Up (Child Psychiatry)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '24837', 'Visit  Note (Blood Pressure Check)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '24838', 'Visit Note (Blood Pressure Check)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '24933', 'Visit Note (Follow-Up) Medicine', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '24934', 'Visit Note (Geriatrics)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '25044', 'Visit Note (Geriatrics)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '25452', 'Hemodialysis Short Progress Note By Physician', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '18456', 'Hemoglobin A1c', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '18858', 'Hemoglobin A1c', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '19610', 'Glycated (A1C) Hgb (BHC)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '20087', 'Glycated (A1C) Hgb (BHC)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '23563', 'Hemoglobin A1C (Send Out)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '23791', 'POCT Hgb A1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '23835', 'Hemoglobin A1C, Blood', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '23985', 'Diabetes Educator Comprehensive Assessment', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '23986', 'Diabetes Educator Revisit Note', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '8699', 'Diabetes Self-Management Goals (Nursing)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'GP2', 4, 'PI', 'NONE', '9318', 'Hemoglobin A1C (HHC)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBN', 4, 'EI', 'NONE', 'AD/1157/1', 'Hemoglobin A1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBN', 4, 'EI', 'NONE', 'AD/433/1', 'Hemoglobin A1c', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBN', 4, 'EI', 'NONE', 'RD/3430/6', 'HbA1C (g/dL)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBN', 4, 'EI', 'NONE', 'RD/3430/9', 'HbA1c    (%)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBN', 4, 'EI', 'NONE', 'RD/4215/6', 'Hgb A1C (%)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBN', 4, 'EI', 'NONE', 'RD/5354/2', 'Hemoglobin A1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBN', 4, 'EI', 'NONE', 'RD/5901/22', 'Hgb A1c', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBN', 4, 'EI', 'NONE', 'RD/5937/17', 'Hgb A1c', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBN', 4, 'PI', 'NONE', '10300', 'Nursing Assessment/Notes', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'NBN', 4, 'PI', 'NONE', '10691', 'Clinic Nurse Assessment-HIV', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'NBN', 4, 'PI', 'NONE', '11110', 'HMT Automated Ordering', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'NBN', 4, 'PI', 'NONE', '11193', 'HMT Historical Documentation', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'NBN', 4, 'PI', 'NONE', '11281', 'HMT Automated Ordering', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'NBN', 4, 'PI', 'NONE', '11282', 'HMT Historical Documentation', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'NBN', 4, 'PI', 'NONE', '11364', 'Ambcare Note - Adult (HHC Testing)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'NBN', 4, 'PI', 'NONE', '11721', 'Clinic Nursing Initial/Annual Assessment', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'NBN', 4, 'PI', 'NONE', '11726', 'Clinic Nursing Initial/Annual Assessment', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'NBN', 4, 'PI', 'NONE', '11728', 'Clinic Nursing Re-Assessment*', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'NBN', 4, 'PI', 'NONE', '11762', 'Clinic Nursing Additional Notes', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'NBN', 4, 'PI', 'NONE', '11763', 'Clinic Nursing Re-Assessment', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'NBN', 4, 'PI', 'NONE', '12848', 'Ambcare Note - Adult*', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'NBN', 4, 'PI', 'NONE', '13358', 'Clinic Nursing Init/Annual Assessment', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'NBN', 4, 'PI', 'NONE', '13456', 'Ambcare Note (Adult)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'NBN', 4, 'PI', 'NONE', '9133', 'Nursing Assessment/notes', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'NBN', 4, 'PI', 'NONE', '9273', 'Ambcare Note - Adult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'NBN', 4, 'PI', 'NONE', '9274', 'Ambcare Note (Adult)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'NBN', 4, 'PI', 'NONE', '10327', 'Hemoglobin A1C (Quest)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBN', 4, 'PI', 'NONE', '10377', 'Diabetic Protocol', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBN', 4, 'PI', 'NONE', '10509', 'Hemoglobin A1C (Quest)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBN', 4, 'PI', 'NONE', '10617', 'Ambcare note Diabetic', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBN', 4, 'PI', 'NONE', '10669', 'Diabetics Self management assessment', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBN', 4, 'PI', 'NONE', '10671', 'Diabetic Self management Assessment', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBN', 4, 'PI', 'NONE', '5607', 'Hemoglobin A1C (WHH)(retired 2/12/01)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBN', 4, 'PI', 'NONE', '5608', 'Hemoglobin A1C (CUM)(retired 2/12/01)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBN', 4, 'PI', 'NONE', '7419', 'Glycated (A1c) Hemoglobin (KCH)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBN', 4, 'PI', 'NONE', '7952', 'Glycated (A1C) Hemoglobin (KCH)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBN', 4, 'PI', 'NONE', '9801', 'Ambcare Note Diabetic', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBX', 4, 'EI', 'NONE', 'AD/38/146', 'Hgb A1c', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBX', 4, 'EI', 'NONE', 'AD/451/88', 'HgA1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBX', 4, 'EI', 'NONE', 'MC/7965/2/896/62', 'HgbA1c', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBX', 4, 'EI', 'NONE', 'MC/8005/2/907/62', 'HgbA1c', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBX', 4, 'EI', 'NONE', 'MC/8015/2/896/62', 'HgbA1c', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBX', 4, 'EI', 'NONE', 'MC/8029/2/907/62', 'HgbA1c', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBX', 4, 'EI', 'NONE', 'MC/9297/2/896/62', 'HgbA1c', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBX', 4, 'EI', 'NONE', 'MC/9303/2/896/62', 'HgbA1c', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBX', 4, 'EI', 'NONE', 'MC/9306/2/907/62', 'HgbA1c', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBX', 4, 'EI', 'NONE', 'MC/9308/2/896/62', 'HgbA1c', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBX', 4, 'EI', 'NONE', 'MC/9309/2/896/62', 'HgbA1c', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBX', 4, 'EI', 'NONE', 'MC/9310/2/907/62', 'HgbA1c', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBX', 4, 'EI', 'NONE', 'MC/9311/2/907/62', 'HgbA1c', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBX', 4, 'EI', 'NONE', 'RD/10949/6', 'Hgb A1c', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBX', 4, 'EI', 'NONE', 'RD/5321/6', 'Hgb A1c', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBX', 4, 'EI', 'NONE', 'RD/9248/6', 'Hgb A1c', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBX', 4, 'PI', 'NONE', '15195', 'Initial Follow-up Visit Note (Bariatric Clinic)(r 7/12)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'NBX', 4, 'PI', 'NONE', '15245', 'ACS Nutrition Assessment/Screening Encounter', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'NBX', 4, 'PI', 'NONE', '15275', 'PCS Nutrition Assessment/Screening Encounter', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'NBX', 4, 'PI', 'NONE', '15277', 'ACS Nutrition Re-Assessment Encounter', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'NBX', 4, 'PI', 'NONE', '15301', 'ACS Nutrition Annual Assessment/Screening  Encounter', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'NBX', 4, 'PI', 'NONE', '15303', 'PCS Nutrition Re-Assessment Encounter', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'NBX', 4, 'PI', 'NONE', '15304', 'PCS Nutrition Annual Assessment/Screening Encounter', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'NBX', 4, 'PI', 'NONE', '15818', 'ACS Nutrition Annual Assessment/Screening Encounter', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'NBX', 4, 'PI', 'NONE', '15819', 'ACS Nutrition Assessment/Screening Encounter', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'NBX', 4, 'PI', 'NONE', '15820', 'ACS Nutrition Re-Assessment Encounter', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'NBX', 4, 'PI', 'NONE', '11386', 'Hgb A1c HPLC', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBX', 4, 'PI', 'NONE', '11387', 'Hgb A1c HPLC', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBX', 4, 'PI', 'NONE', '14957', 'PSC Diabetes Initial Visit Note (r08/07)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBX', 4, 'PI', 'NONE', '14958', 'PSC Diabetes Follow-Up Visit Note (r08/07)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBX', 4, 'PI', 'NONE', '14972', 'Peds - Diabetes Clinic Follow-Up Note', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBX', 4, 'PI', 'NONE', '16414', 'Peds - Diabetes Clinic Initial Visit Note', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBX', 4, 'PI', 'NONE', '16419', 'Peds - Diabetes Clinic Follow-Up Note', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBX', 4, 'PI', 'NONE', '17252', 'Hgb A1c OPD Only', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'NBX', 4, 'PI', 'NONE', '17263', 'Hgb A1c OPD Only', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'QHN', 4, 'EI', 'NONE', 'AD/258/18', 'A1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'QHN', 4, 'EI', 'NONE', 'AG/265/1/49/5', 'HgbA1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'QHN', 4, 'EI', 'NONE', 'AG/622/10/966/28', 'HgA1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'QHN', 4, 'EI', 'NONE', 'RD/3985/32', 'Hemoglobin A1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'QHN', 4, 'EI', 'NONE', 'RD/4243/32', 'Hemoglobin A1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'QHN', 4, 'EI', 'NONE', 'RD/6085/46', 'Hemoglobin A1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'QHN', 4, 'EI', 'NONE', 'RD/8789/14', 'Hemoglobin a1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'QHN', 4, 'EI', 'NONE', 'RD/9139/16', 'Hgb A1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '11634', 'Cardiology Clinic Referral/Visit', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '11697', 'Endocrinology Referral/Visit', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '15266', 'Nutritional Consult IP', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '15301', 'Cardiology IP/EP Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '15320', 'Cardiology Clinic Progress Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '15399', 'Test Tobacco MU', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '15677', 'CCU Admission Assessment*', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '15770', 'Discharge/Transfer Summary*', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '15990', 'Pulmonary IP/EP Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '15991', 'Pulmonary IP/EP Daily Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '16115', 'Pulmonary IP/EP Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '16116', 'Pulmonary IP/EP Daily Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '16371', 'Endocrine IP/EP Daily Note **', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '16791', 'Cardiology Clinic Progress Note*', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '16818', 'Cardiology Clinic Referral/Visit*', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '16876', 'Cardiology Consult Inpatient/ER', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '16877', 'CCU Admission Assessment', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '16996', 'Cardiology Clinic Referral/Visit', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '16997', 'Cardiology Clinic Progress Notes', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '16998', 'Cardiology IP/EP Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '17000', 'CCU Admission Assessment', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '17225', 'Cardiology Consult Inpatient/ER Follow-up', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '17555', 'Electrophysiology IP/EP Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '17556', 'Electrophysiology Inpatient/ER Follow-up Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '17558', 'Electrophysiology IP/EP Consult', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '17559', 'Electrophysiology Progress Note Inpatient/ER', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '17561', 'Electrophysiology Clinic Referral/Visit', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '17562', 'Electrophysiology Clinic Referral/Visit', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '17563', 'Electrophysiology Clinic Progress Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '17564', 'Electrophysiology Clinic Progress Notes', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '18521', 'Nutrition Assessment (Initial)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '18522', 'Nutrition Reassessment', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '18523', 'Nutrition Assessment (Initial)', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '18524', 'Nutrition Reassessment', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '19700', 'Obstetrics Admission History & Physical', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '19701', 'Obstetric Admission History & Physical', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '19814', 'Obstetrics Attending Daily Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '19818', 'Obstetric Post Partum Progress Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '19819', 'Obstetric Post Partum Progress Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '19824', 'Obstetric Attending Admission Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '19826', 'Obstetric Post Operative Progress Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '19827', 'Obstetric Post Operative Progress Note', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '19951', 'Obstetric L&D Triage Note*', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '6490', 'Nutritional Consult IP', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '13024', 'Glycated (A1C) Hemoglobin Level', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '13143', 'Glycated(A1C)Hemoglobin Level', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '15478', 'NST Diabetes Progress Note', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '16355', 'Diabetes OP Consult', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '16357', 'Diabetes OP Progress Note', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '16363', 'Diabetes OP Assessment/Plan', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '16364', 'Diabetes OP Consult', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '16366', 'Diabetes OP Progress Note', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '16370', 'Diabetes IP/EP Consult', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '16373', 'Diabetes IP/EP Daily Note', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '17004', 'Diabetes Referral/Visit', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '17340', 'Diabetes IP/EP Daily Note', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '20370', 'Hemoglobin a1C POC', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '20775', 'Diabetes OP Assessment/Plan', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '8147', 'Hemoglobin A1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '9318', 'Hemoglobin A1C (new)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'QHN', 4, 'PI', 'NONE', '9602', 'Hemoglobin A1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'SBN', 4, 'EI', 'NONE', 'RD/10359/2', 'HbA1C %', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'SBN', 4, 'EI', 'NONE', 'RD/12148/5', 'A1C Result', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'SBN', 4, 'EI', 'NONE', 'RD/12186/5', 'A1C Result', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'SBN', 4, 'EI', 'NONE', 'RD/13082/4', 'HgB A1C', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'SBN', 4, 'EI', 'NONE', 'RD/5835/5', 'Hemoglobin A1C (%)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'SBN', 4, 'EI', 'NONE', 'RD/6722/6', 'Hgb A1C (%)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'SBN', 4, 'EI', 'NONE', 'RD/9139/6', 'Hgb A1C (%)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'SBN', 4, 'PI', 'NONE', '23619', 'Patient Self Management Goals/Care Plans', 'AND', '<>', 'N' FROM dual UNION ALL
  SELECT 'SBN', 4, 'PI', 'NONE', '20026', 'Hemoglobin A1C (CIH)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'SBN', 4, 'PI', 'NONE', '21223', 'Hgb A1C (KCH)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'SBN', 4, 'PI', 'NONE', '24215', 'Hemoglobin A1C (POC)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'SBN', 4, 'PI', 'NONE', '24393', 'Hgb A1C (CIH)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'SMN', 4, 'EI', 'NONE', 'RD/11777/35', 'Hemoglobin A1C %', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'SMN', 4, 'EI', 'NONE', 'RD/6078/9', 'A1c, Calculated     (%)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'SMN', 4, 'EI', 'NONE', 'RD/9472/3', 'Hemoglobin A1C %', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'SMN', 4, 'EI', 'NONE', 'RD/9472/34', 'Hemoglobin A1C %', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'SMN', 4, 'PI', 'NONE', '20542', 'Glycated (A1C) Hemoglobin Level*', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'SMN', 4, 'PI', 'NONE', '20611', 'Glycated (A1C) Hemoglobin Level*', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'SMN', 4, 'PI', 'NONE', '22222', 'Glycated (A1C) Hemoglobin Level*', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'SMN', 4, 'PI', 'NONE', '22277', 'Glycated (A1C) Hemoglobin Level*', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'SMN', 4, 'PI', 'NONE', '24771', 'Hemoglobin A1C Level (Send Out)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'SMN', 4, 'PI', 'NONE', '29585', 'Hemoglobin A1C Level (Send Out)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'SMN', 4, 'PI', 'NONE', '29690', 'Glycated (A1c) Hgb Level*', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'SMN', 4, 'PI', 'NONE', '30945', 'Hemoglobin A1C Level (Send Out)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'SMN', 4, 'PI', 'NONE', '31092', 'Hemoglobin A1C Level (Send Out)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'SMN', 4, 'PI', 'NONE', '31175', 'Hemoglobin A1C Level (Send Out)', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.10', 'Type 1 diabetes mellitus with ketoacidosis without coma', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.11', 'Type 1 diabetes mellitus with ketoacidosis with coma', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.21', 'Type 1 diabetes mellitus with diabetic nephropathy', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.22', 'Type 1 diabetes mellitus w diabetic chronic kidney disease', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.29', 'Type 1 diabetes mellitus w oth diabetic kidney complication', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.311', 'Type 1 diabetes mellitus with unspecified diabetic retinopathy with macular edema', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.319', 'Type 1 diabetes mellitus with unspecified diabetic retinopathy without macular edema', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.321', 'Type 1 diabetes mellitus with mild nonproliferative diabetic retinopathy with macular edema', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.329', 'Type 1 diabetes mellitus with mild nonproliferative diabetic retinopathy without macular edema', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.331', 'Type 1 diabetes mellitus with moderate nonproliferative diabetic retinopathy with macular edema', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.339', 'Type 1 diabetes mellitus with moderate nonproliferative diabetic retinopathy without macular edema', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.341', 'Type 1 diabetes mellitus with severe nonproliferative diabetic retinopathy with macular edema', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.349', 'Type 1 diabetes mellitus with severe nonproliferative diabetic retinopathy without macular edema', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.351', 'Type 1 diabetes mellitus with proliferative diabetic retinopathy with macular edema', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.359', 'Type 1 diabetes mellitus with proliferative diabetic retinopathy without macular edema', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.36', 'Type 1 diabetes mellitus with diabetic cataract', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.39', 'Type 1 diabetes mellitus with other diabetic ophthalmic complication', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.40', 'Type 1 diabetes mellitus with diabetic neuropathy, unspecified', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.41', 'Type 1 diabetes mellitus with diabetic mononeuropathy', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.42', 'Type 1 diabetes mellitus with diabetic mononeuropathy', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.43', 'Type 1 diabetes mellitus with diabetic autonomic (poly)neuropathy', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.44', 'Type 1 diabetes mellitus with diabetic amyotrophy', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.49', 'Type 1 diabetes mellitus with other diabetic neurological complication', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.51', 'Type 1 diabetes mellitus with diabetic peripheral angiopathy without gangrene', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.52', 'Type 1 diabetes mellitus with diabetic peripheral angiopathy with gangrene', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.59', 'Type 1 diabetes mellitus with other circulatory complications', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.610', 'Type 1 diabetes mellitus with diabetic neuropathic arthropathy', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.618', 'Type 1 diabetes mellitus with other diabetic arthropathy', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.620', 'Type 1 diabetes mellitus with diabetic dermatitis', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.621', 'Type 1 diabetes mellitus with foot ulcer', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.622', 'Type 1 diabetes mellitus with other skin ulcer', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.628', 'Type 1 diabetes mellitus with other skin complications', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.630', 'Type 1 diabetes mellitus with periodontal disease', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.638', 'Type 1 diabetes mellitus with other oral complications', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.641', 'Type 1 diabetes mellitus with hypoglycemia with coma', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.649', 'Type 1 diabetes mellitus with hypoglycemia without coma', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.65', 'Type 1 diabetes mellitus with hyperglycemia', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.69', 'Type 1 diabetes mellitus with other specified complication', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.8', 'Type 1 diabetes mellitus with unspecified complications', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E10.9', 'Type 1 diabetes mellitus without complications', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.00', 'Type 2 diabetes mellitus with hyperosmolarity without nonketotic hyperglycemic-hyperosmolar coma (NKHHC)', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.01', 'Type 2 diabetes mellitus with hyperosmolarity with coma', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.21', 'Type 2 diabetes mellitus with diabetic nephropathy', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.22', 'Type 2 diabetes mellitus with diabetic chronic kidney disease', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.29', 'Type 2 diabetes mellitus with other diabetic kidney complication', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.311', 'Type 2 diabetes mellitus with unspecified diabetic retinopathy with macular edema', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.319', 'Type 2 diabetes mellitus with unspecified diabetic retinopathy without macular edema', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.321', 'Type 2 diabetes mellitus with mild nonproliferative diabetic retinopathy with macular edema', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.329', 'Type 2 diabetes mellitus with mild nonproliferative diabetic retinopathy without macular edema', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.331', 'Type 2 diabetes mellitus with moderate nonproliferative diabetic retinopathy with macular edema', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.339', 'Type 2 diabetes mellitus with moderate nonproliferative diabetic retinopathy without macular edema', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.341', 'Type 2 diabetes mellitus with severe nonproliferative diabetic retinopathy with macular edema', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.349', 'Type 2 diabetes mellitus with severe nonproliferative diabetic retinopathy without macular edema', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.351', 'Type 2 diabetes mellitus with proliferative diabetic retinopathy with macular edema', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.359', 'Type 2 diabetes mellitus with proliferative diabetic retinopathy without macular edema', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.36', 'Type 2 diabetes mellitus with diabetic cataract', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.39', 'Type 2 diabetes mellitus with other diabetic ophthalmic complication', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.40', 'Type 2 diabetes mellitus with diabetic neuropathy, unspecified', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.41', 'Type 2 diabetes mellitus with diabetic mononeuropathy', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.42', 'Type 2 diabetes mellitus with diabetic polyneuropathy', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.43', 'Type 2 diabetes mellitus with diabetic autonomic (poly) neuropathy', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.44', 'Type 2 diabetes mellitus with diabetic amyotrophy', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.49', 'Type 2 diabetes mellitus with other diabetic neurological complication', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.51', 'Type 2 diabetes mellitus with diabetic peripheral angiopathy without gangrene', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.52', 'Type 2 diabetes mellitus with diabetic peripheral angiopathy with gangrene', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.59', 'Type 2 diabetes mellitus with other circulatory complications', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.610', 'Type 2 diabetes mellitus with diabetic neuropathic arthropathy', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.618', 'Type 2 diabetes mellitus with other diabetic arthropathy', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.620', 'Type 2 diabetes mellitus with diabetic dermatitis', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.621', 'Type 2 diabetes mellitus with foot ulcer', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.622', 'Type 2 diabetes mellitus with other skin ulcer', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.628', 'Type 2 diabetes mellitus with other skin complications', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.630', 'Type 2 diabetes mellitus with periodontal disease', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.638', 'Type 2 diabetes mellitus with other oral complications', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.641', 'Type 2 diabetes mellitus with hypoglycemia with coma', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.649', 'Type 2 diabetes mellitus with hypoglycemia without coma', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.65', 'Type 2 diabetes mellitus with hyperglycemia', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.69', 'Type 2 diabetes mellitus with other specified complication', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.8', 'Type 2 diabetes mellitus with unspecified complications', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'E11.9', 'Type 2 diabetes mellitus without complications', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'O24.011', 'Pre-existing diabetes mellitus, type 1, in pregnancy, first trimester', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'O24.012', 'Pre-existing diabetes mellitus, type 1, in pregnancy, second trimester', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'O24.013', 'Pre-existing diabetes mellitus, type 1, in pregnancy, third trimester', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'O24.019', 'Pre-existing diabetes mellitus, type 1, in pregnancy, unspecified trimester', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'O24.02', 'Pre-existing diabetes mellitus, type 1, in childbirth', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'O24.03', 'Pre-existing diabetes mellitus, type 1, in the puerperium', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'O24.111', 'Pre-existing diabetes mellitus, type 2, in pregnancy, first trimester', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'O24.112', 'Pre-existing diabetes mellitus, type 2, in pregnancy, second trimester', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'O24.113', 'Pre-existing diabetes mellitus, type 2, in pregnancy, third trimester', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'O24.119', 'Pre-existing diabetes mellitus, type 2, in pregnancy, unspecified trimester', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'O24.12', 'Pre-existing diabetes mellitus, type 2, in childbirth', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD10', 'O24.13', 'Pre-existing diabetes mellitus, type 2, in the puerperium', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250', 'Diabetes mellitus without mention of complication, type II or unspecified type, not stated as uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.01', 'Diabetes mellitus without mention of complecation, type I [juvenile type], not stated as uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.02', 'Diabetes mellitus without mention of complication, type II or unspecified type, uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.03', 'Diabetes mellitus without mention of complecation, type I [juvenile type], uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.1', 'Diabetes with ketoacidosis, type II or unspecified type, not stated as uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.11', 'Diabetes with ketoacidosis, type I [ juvenile type], not stated as uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.12', 'Diabetes with ketoacidosis, type II or unspecified type, uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.13', 'Diabetes with ketoacidosis, type I [ juvenile type], uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.2', 'Diabetes with hyperosmolarity, type II or unspecified type, not stated as uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.21', 'Diabetes with hyperosmolarity, type I [ juvenile type ], not stated as uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.22', 'Diabetes with hyperosmolarity, type II or unspecified type, uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.23', 'Diabetes with hyperosmolarity, type I [ juvenile type ], uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.3', 'Diabetes with other coma, type II or unspecified type, not stated as uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.31', 'Diabetes with other coma, type I [ juvenile type ], not stated as uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.32', 'Diabetes with other coma, type II or unspecified type, uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.33', 'Diabetes with other coma, type I [ juvenile type ], uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.4', 'Diabetes with renal manifestations, type II or unspecified type, not stated as uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.41', 'Diabetes with renal manifestations, type I [ juvenile type ], not stated as uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.42', 'Diabetes with renal manifestations, type II or unspecified type, uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.43', 'Diabetes with renal manifestations, type II [ juvenile type ], uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.5', 'Diabetes with opthalmic manifestations, type II or unspecified type, not stated as uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.51', 'Diabetes with opthalmic manifestations, type I [ juvenile type ], not stated as uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.52', 'Diabetes with opthalmic manifestations, type II or unspecified type, uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.53', 'Diabetes with opthalmic manifestations, type I [ juvenile type ], uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.6', 'Diabetes with neurological manifestations, type II or unspecified type, Not stated as uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.61', 'Diabetes with neurological manifestations, type I [ juvenile type ], Not stated as uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.62', 'Diabetes with neurological manifestations, type II or unspecified type, uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.63', 'Diabetes with neurological manifestations, type I [ juvenile type ], uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.7', 'Diabetes with peripheral circulatory disorders, type II or unspecified type, not stated as uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.71', 'Diabetes with peripheral circulatory disorders, type I [ juvenile type ], not stated as uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.72', 'Diabetes with peripheral circulatory disorders, type II or unspecified type, uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.73', 'Diabetes with peripheral circulatory disorders, type I [ juvenile type ], uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.8', 'Diabetes with other specified manifestations, type II or unspecified type, not stated as uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.81', 'Diabetes with other specified manifestations, type I [ juvenile type ], not stated as uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.82', 'Diabetes with other specified manifestations, type II or unspecified type, uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.83', 'Diabetes with other specified manifestations, type I [ juvenile type ], uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.9', 'Diabetes with unspecified complication, type II or unspecified type, not stated as uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.91', 'Diabetes with unspecified complication, type I [ juvenile type ], not stated as uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.92', 'Diabetes with unspecified complication, type II or unspecified type, uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '250.93', 'Diabetes with unspecified complication, type I [ juvenile type ], uncontrolled', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '357.2', 'Polyneuropathy indiabetes', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '362.01', 'Background diabetic retinopathy', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '362.02', 'Proliferative diabetic retinopathy', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '362.03', 'Nonproliferative diabetic retinopathy NOS', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '362.04', 'Mild nonproliferative diabetic retinopathy', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '362.05', 'Moderate nonproliferative diabetic retinopathy', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '362.06', 'Severe nonproliferative diabetic retinopathy', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '362.07', 'Diabetic macular edema', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '366.41', 'Diabetic cataract', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '648', 'Diabetes mellitus of mother, complicating pregnancy, childbirth, or the puerperium, unspecified as to episode of care or not applicable', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '648.01', 'Diabetes mellitus of mother, complicating pregnancy, childbirth, or the puerperium, delivered, with or without mention of antepartum condition', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '648.02', 'Diabetes mellitus of mother, complicating pregnancy, childbirth, or the puerperium, delivered, with mention of postpartum complication', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '648.03', 'Diabetes mellitus of mother, complicating pregnancy, childbirth, or the puerperium, antepartum condition or complication', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 6, 'DI', 'ICD9', '648.04', 'Diabetes mellitus of mother, complicating pregnancy, childbirth, or the puerperium, postpartum condition or complication', 'OR', '=', 'N' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD10', 'F20.0', 'Paranoid schizophrenia', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD10', 'F20.1', 'Disorganized schizophrenia', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD10', 'F20.2', 'Catatonic schizophrenia', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD10', 'F20.3', 'Undifferentiated schizophrenia', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD10', 'F20.5', 'Residual schizophrenia', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD10', 'F20.81', 'Schizophreniform disorder', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD10', 'F20.89', 'Other schizophrenia', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD10', 'F20.9', 'Schizophrenia, unspecified', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD10', 'F21', 'Schizotypal disorder', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD10', 'F25.0', 'Schizoaffective disorder, bipolar type', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD10', 'F25.1', 'Schizoaffective disorder, depressive type', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD10', 'F25.8', 'Other schizoaffective disorders', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD10', 'F25.9', 'Schizoaffective disorder, unspecified', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD10', 'V11.0', 'Personal history of schizophrenia', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '259.53', 'Latent schizophrenia, subchronic with acute exacerbation', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295', 'Schizophrenic disorders', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.01', 'Simple type schizophrenia, subchronic', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.02', 'Simple type schizophrenia, chronic', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.03', 'Simple type schizophrenia, subchronic with acute exacerbation', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.04', 'Simple type schizophrenia, chronic with acute exacerbation', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.05', 'Simple type schizophrenia, in remission', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.1', 'Disorganized type schizophrenia', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.11', 'Disorganized type schizophrenia, subchronic', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.12', 'Disorganized type schizophrenia, chronic', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.13', 'Disorganized type schizophrenia, subchronic with acute exacerbation', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.14', 'Disorganized type schizophrenia, chronic with acute exacerbation', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.15', 'Disorganized type schizophrenia, in remission', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.2', 'Catatonic type schizophrenia', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.21', 'Catatonic type schizophrenia, subchronic', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.22', 'Catatonic type schizophrenia, chronic', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.23', 'Catatonic type schizophrenia, subchronic with acute exacerbation', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.24', 'Catatonic type schizophrenia, chronic with acute exacerbation', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.25', 'Catatonic type schizophrenia, in remission', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.3', 'Paranoid type schizophrenia', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.31', 'Paranoid type schizophrenia, subchronic', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.32', 'Paranoid type schizophrenia, chronic', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.33', 'Paranoid type schizophrenia, subchronic with acute exacerbation', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.34', 'Paranoid type schizophrenia, chronic with acute exacerbation', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.35', 'Paranoid type schizophrenia, in remission', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.4', 'Schizophreniform disorder', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.41', 'Schizophreniform disorder, subchronic', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.42', 'Schizophreniform disorder, chronic', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.43', 'Schizophreniform disorder, subchronic with acute exacerbation', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.44', 'Schizophreniform disorder, chronic with acute exacerbation', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.45', 'Schizophreniform disorder, in remission', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.5', 'Latent schizophrenia', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.51', 'Latent schizophrenia, subchronic', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.52', 'Latent schizophrenia, chronic', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.54', 'Latent schizophrenia, chronic with acute exacerbation', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.55', 'Latent schizophrenia, in remission', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.6', 'Schizophrenic disorder, residual type', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.61', 'Schizophrenic disorders, residual type, subchronic', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.62', 'Schizophrenic disorders, residual type, chronic', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.63', 'Schizophrenic disorders, residual type, subchronic with acute exacerbation', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.64', 'Schizophrenic disorders, residual type, chronic with acute exacerbation', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.65', 'Schizophrenic disorders, residual type, in remission', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.7', 'Schizoaffective disorder', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.71', 'Schizoaffective disorder, subchronic', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.72', 'Schizoaffective disorder, chronic', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.73', 'Schizoaffective disorder, subchronic with acute exacerbation', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.74', 'Schizoaffective disorder, chronic with acute exacerbation', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.75', 'Schizoaffective disorder, in remission', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.8', 'Other specified types of schizophrenia', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.81', 'Other specified types of schizophrenia, subchronic', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.82', 'Other specified types of schizophrenia, chronic', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.83', 'Other specified types of schizophrenia, subchronic with acute exacerbation', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.84', 'Other specified types of schizophrenia, chronic with acute exacerbation', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.85', 'Other specified types of schizophrenia, in remission', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.9', 'Unspecified schizophrenia', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.91', 'Unspecified schizophrenia, subchronic', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.92', 'Unspecified schizophrenia, chronic', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.93', 'Unspecified schizophrenia, subchronic with acute exacerbation', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.94', 'Unspecified schizophrenia, chronic with acute exacerbation', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 31, 'DI', 'ICD9', '295.95', 'Unspecified schizophrenia, in remission', 'OR', '=', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 32, 'DI', 'ICD10', 'F31', 'Bipolar disorder', 'OR', '=', '' FROM dual UNION ALL
  SELECT 'ALL', 32, 'DI', 'ICD10', 'F31.0', 'Bipolar disorder, current episode hypomanic', 'OR', '=', '' FROM dual UNION ALL
  SELECT 'ALL', 32, 'DI', 'ICD10', 'F31.1', 'Bipolar disorder, current episode manic without psychotic features', 'OR', '=', '' FROM dual UNION ALL
  SELECT 'ALL', 32, 'DI', 'ICD10', 'F31.10', 'Bipolar disorder, current episode manic without psychotic features?? unspecified', 'OR', '=', '' FROM dual UNION ALL
  SELECT 'ALL', 32, 'DI', 'ICD10', 'F31.11', 'Bipolar disorder, current episode manic without psychotic features?? mild', 'OR', '=', '' FROM dual UNION ALL
  SELECT 'ALL', 32, 'DI', 'ICD10', 'F31.12', 'Bipolar disorder, current episode manic without psychotic features?? moderate', 'OR', '=', '' FROM dual UNION ALL
  SELECT 'ALL', 32, 'DI', 'ICD10', 'F31.13', 'Bipolar disorder, current episode manic without psychotic features?? severe', 'OR', '=', '' FROM dual UNION ALL
  SELECT 'ALL', 32, 'DI', 'ICD10', 'F31.2', 'Bipolar disorder, current episode manic severe with psychotic features', 'OR', '=', '' FROM dual UNION ALL
  SELECT 'ALL', 32, 'DI', 'ICD10', 'F31.3', 'Bipolar disorder, current episode depressed, mild or moderate severity', 'OR', '=', '' FROM dual UNION ALL
  SELECT 'ALL', 32, 'DI', 'ICD10', 'F31.30', 'Bipolar disorder, current episode depressed, mild or moderate severity?? unspecified', 'OR', '=', '' FROM dual UNION ALL
  SELECT 'ALL', 32, 'DI', 'ICD10', 'F31.31', 'Bipolar disorder, current episode depressed, mild', 'OR', '=', '' FROM dual UNION ALL
  SELECT 'ALL', 32, 'DI', 'ICD10', 'F31.32', 'Bipolar disorder, current episode depressed, moderate', 'OR', '=', '' FROM dual UNION ALL
  SELECT 'ALL', 32, 'DI', 'ICD10', 'F31.4', 'Bipolar disorder, current episode depressed, severe, without psychotic features', 'OR', '=', '' FROM dual UNION ALL
  SELECT 'ALL', 32, 'DI', 'ICD10', 'F31.5', 'Bipolar disorder, current episode depressed, severe, with psychotic features', 'OR', '=', '' FROM dual UNION ALL
  SELECT 'ALL', 32, 'DI', 'ICD10', 'F31.6', 'Bipolar disorder, current episode mixed', 'OR', '=', '' FROM dual UNION ALL
  SELECT 'ALL', 32, 'DI', 'ICD10', 'F31.60', 'Bipolar disorder, current episode mixed ?? unspecified', 'OR', '=', '' FROM dual UNION ALL
  SELECT 'ALL', 32, 'DI', 'ICD10', 'F31.61', 'Bipolar disorder, current episode mixed?? mild', 'OR', '=', '' FROM dual UNION ALL
  SELECT 'ALL', 32, 'DI', 'ICD10', 'F31.62', 'Bipolar disorder, current episode mixed ?? moderate', 'OR', '=', '' FROM dual UNION ALL
  SELECT 'ALL', 32, 'DI', 'ICD10', 'F31.63', 'Bipolar disorder, current episode mixed  ?? severe, without psychotic features', 'OR', '=', '' FROM dual UNION ALL
  SELECT 'ALL', 32, 'DI', 'ICD10', 'F31.64', 'Bipolar disorder, current episode mixed ?? severe, with psychotic features', 'OR', '=', '' FROM dual UNION ALL
  SELECT 'ALL', 32, 'DI', 'ICD10', 'F31.7', 'Bipolar disorder, currently in remission', 'OR', '=', '' FROM dual UNION ALL
  SELECT 'ALL', 32, 'DI', 'ICD10', 'F31.70', 'Bipolar disorder, currently in remission?? most recent episode unspecified', 'OR', '=', '' FROM dual UNION ALL
  SELECT 'ALL', 32, 'DI', 'ICD10', 'F31.71', 'Bipolar disorder, in partial remission, most recent episode hypomanic', 'OR', '=', '' FROM dual UNION ALL
  SELECT 'ALL', 32, 'DI', 'ICD10', 'F31.72', 'Bipolar disorder, in full remission, most recent episode hypomanic', 'OR', '=', '' FROM dual UNION ALL
  SELECT 'ALL', 32, 'DI', 'ICD10', 'F31.73', 'Bipolar disorder, in partial remission, most recent episode manic', 'OR', '=', '' FROM dual UNION ALL
  SELECT 'ALL', 32, 'DI', 'ICD10', 'F31.74', 'Bipolar disorder, in full remission, most recent episode manic', 'OR', '=', '' FROM dual UNION ALL
  SELECT 'ALL', 32, 'DI', 'ICD10', 'F31.75', 'Bipolar disorder, in partial remission, most recent episode depressed', 'OR', '=', '' FROM dual UNION ALL
  SELECT 'ALL', 32, 'DI', 'ICD10', 'F31.76', 'Bipolar disorder, in full remission, most recent episode depressed', 'OR', '=', '' FROM dual UNION ALL
  SELECT 'ALL', 32, 'DI', 'ICD10', 'F31.77', 'Bipolar disorder, in partial remission, most recent episode mixed', 'OR', '=', '' FROM dual UNION ALL
  SELECT 'ALL', 32, 'DI', 'ICD10', 'F31.78', 'Bipolar disorder, in full remission, most recent episode mixed', 'OR', '=', '' FROM dual UNION ALL
  SELECT 'ALL', 32, 'DI', 'ICD10', 'F31.8', 'Other bipolar disorders', 'OR', '=', '' FROM dual UNION ALL
  SELECT 'ALL', 32, 'DI', 'ICD10', 'F31.81', 'Bipolar II disorder', 'OR', '=', '' FROM dual UNION ALL
  SELECT 'ALL', 32, 'DI', 'ICD10', 'F31.89', 'Other bipolar disorder', 'OR', '=', '' FROM dual UNION ALL
  SELECT 'ALL', 32, 'DI', 'ICD10', 'F31.9', 'Bipolar disorder, unspecified', 'OR', '=', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%acarbose%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%actoplus%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%actos%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%albiglutide%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%alogliptin %', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%amaryl%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%apidra%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%avandamet%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%avandaryl%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%avandia%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%bromocriptine %', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%bydureon%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%byetta%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%canagliflozin%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%chlorpropamide %', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%dapagliflozin %', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%diabeta%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%diabinese%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%duetact%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%dulaglutide %', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%empagliflozin%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%exenatide %', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%farxiga%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%flexpen%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%fortamet%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%gliclazide%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%glimepiride %', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%glipizide %', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%glucophage%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%glucotrol%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%glucovance%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%glumetza%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%glyburide%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%glynase%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%glyset%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%glyxambi%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%humalog%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%humulin  %', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%insulin %', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%invokamet%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%invokana%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%janumet%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%januvia%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%jardiance%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%jentadueto%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%juvisync%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%kazano%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%kombiglyze%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%lantus%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%levemir%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%linagliptin%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%liraglutide%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%metaglip%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%metformin%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%micronase%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%miglitol %', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%nateglinide%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%nesina%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%novolin%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%novolog%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%onglyza%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%orinase%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%oseni%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%parlodel%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%pioglitazone%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%pramlintide %', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%prandimet%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%prandin%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%precose%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%repaglinide%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%riomet%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%rosiglitazone%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%ryzodeg %', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%saxagliptin%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%simvastatin %', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%sitagliptin%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%starlix%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%symlinpen%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%synjardy%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%tanzeum%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%tol-tab%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%tolazamide %', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%tolbutamide %', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%tolinase%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%toujeo%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%tradjenta%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%tresiba%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%trulicity%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%victoza%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 33, 'MED', 'NONE', '%xigduo%', 'Diabetes medication', 'OR', 'LIKE', '' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%abilify%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%amitriptyline%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%aripiprazole%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%chlorpromazine%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%compazine %', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%compro %', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%etrafon,%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%fanapt%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%fluphenazine%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%geodon%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%haldol%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%haloperidol%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%iloperidone%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%invega%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%latuda%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%loxapine%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%loxitane%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%lurasidone%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%mellaril%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%moban%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%molindone%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%navane%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%olanzapine%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%orap%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%oxilapine%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%paliperidone%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%permitil%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%perphenazine%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%pimozide%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%prochlorperazine%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%procomp%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%prolixin%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%promapar%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%quetiapine%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%risperdal%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%risperidone%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%seroquel %', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%seroquel%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%stelazine%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%symbyax%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%thioridazine%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%thiothixene%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%thorazine%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%triavil%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%trifluoperazine%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%trilafon%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%ziprasidone%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual UNION ALL
  SELECT 'ALL', 34, 'MED', 'NONE', '%zyprexa%', 'Antipsychotic  medication', 'OR', 'LIKE', 'Y' FROM dual
) q
on (t.criterion_id = q.criterion_id and t.condition_type_cd = q.condition_type_cd and t.network = q.network and t.qualifier = q.qualifier and t.value = q.value)
when matched then update set t.value_description = q.value_description, t.logical_operator = q.logical_operator, t.comparison_operator = q.comparison_operator, t.hint_ind = q.hint_ind
when not matched then insert values(q.criterion_id, q.network, q.condition_type_cd, q.qualifier, q.value, q.value_description, q.logical_operator, q.comparison_operator, q.hint_ind);

commit;