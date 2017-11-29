SELECT /*+ ALL_ROWS FULL(l) FULL(f) FULL(a) FULL(sa) FULL(ssa) NOPARALLEL(l) NOPARALLEL(f) NOPARALLEL(a) NOPARALLEL(sa) NOPARALLEL(ssa) */
  l.location_id AS location_id,
  regexp_substr(l.location_id, '^([0-9~]*)~[0-9]*$', 1, 1, 'c', 1) tr,
  l.parent_location_id,
  NVL(a.NAME, 'NA') AS area,
  NVL(sa.NAME, 'NA') AS subarea,
  NVL(ssa.NAME, 'NA') AS sub_subarea,
  DECODE(UPPER(l.bed), 'TRUE', 'True', 'False') AS bed_flag,
  NVL (f.NAME, 'Unknown') AS facility
FROM ud_master.location l
LEFT JOIN ud_master.facility f ON f.facility_id = l.facility_id
LEFT JOIN ud_master.location a ON a.location_id = 
 DECODE(TRANSLATE(l.location_id, '~-0123456789', 'I'), NULL, l.location_id, SUBSTR(l.location_id, 1, INSTR (l.location_id, '~', 1, 1)-1))
LEFT JOIN ud_master.location sa ON sa.location_id =  
 DECODE(TRANSLATE (l.location_id, '~-0123456789', 'I'), NULL, '-1', 'I', l.location_id, SUBSTR(l.location_id, 1, INSTR(l.location_id, '~', 1, 2)-1)) 
LEFT JOIN ud_master.location ssa ON ssa.location_id =
 DECODE(TRANSLATE (l.location_id, '~-0123456789', 'I'), NULL, '-1', 'I', '-1', 'II', l.location_id);
 
SELECT cfg_value
FROM hhc_custom.dw_cfg
WHERE cfg_group_id = 10301;

