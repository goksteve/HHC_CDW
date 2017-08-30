load data
into table edd_stg_time truncate
fields terminated by '|'
trailing nullcols
(
  DimTimeKey ,
  Date_ "TO_TIMESTAMP(:Date_, 'yyyy-mm-dd HH24:mi:ss.ff3')",
  Time  "DECODE(:Time, CHR(00), ' ', :Time)",
  Time24  "DECODE(:Time24, CHR(00), ' ', :Time24)",
  Hour ,
  HourName  "DECODE(:HourName, CHR(00), ' ', :HourName)",
  Minute ,
  MinuteKey ,
  MinuteName  "DECODE(:MinuteName, CHR(00), ' ', :MinuteName)",
  Hour24 ,
  AM  "DECODE(:AM, CHR(00), ' ', :AM)",
  Year  "DECODE(:Year, CHR(00), ' ', :Year)",
  Quarter  "DECODE(:Quarter, CHR(00), ' ', :Quarter)",
  ShortQuarter  "DECODE(:ShortQuarter, CHR(00), ' ', :ShortQuarter)",
  Month  "DECODE(:Month, CHR(00), ' ', :Month)",
  ShortMonth  "DECODE(:ShortMonth, CHR(00), ' ', :ShortMonth)",
  MonthSort ,
  DateHour "TO_TIMESTAMP(:DateHour, 'yyyy-mm-dd HH24:mi:ss.ff3')",
  Day  "DECODE(:Day, CHR(00), ' ', :Day)",
  ShortDay  "DECODE(:ShortDay, CHR(00), ' ', :ShortDay)",
  WeekSort ,
  DayOfWeek  "DECODE(:DayOfWeek, CHR(00), ' ', :DayOfWeek)",
  ShortDOW  "DECODE(:ShortDOW, CHR(00), ' ', :ShortDOW)",
  DaySort 
)
