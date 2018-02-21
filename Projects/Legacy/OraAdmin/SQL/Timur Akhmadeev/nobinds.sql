select max(sql_text), max(sql_id), count(*)
  from v$sqlarea
 where force_matching_signature <> 0
 group by force_matching_signature
 having count(*) > 5
 order by count(*);