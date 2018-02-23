exec dbm.drop_tables('DIM_DATE_TIME'); 

CREATE TABLE dim_date_time
(
  DATENUM           NUMBER(8),
  DAYS_IN_DATE      DATE,
  YEAR              NUMBER(4),
  YEARMONTHNUM      NUMBER(6),
  CALENDAR_QUARTER  VARCHAR2(10 BYTE),
  MONTHNUM          NUMBER,
  MONTHNAME         VARCHAR2(16 BYTE),
  MONTHSHORTNAME    VARCHAR2(3 BYTE),
  WEEKNUM           NUMBER(2),
  DAYNUMOFYEAR      NUMBER(3),
  DAYNUMOFMONTH     NUMBER(2),
  DAYNUMOFWEEK      NUMBER(1),
  DAYNAME           VARCHAR2(16 BYTE),
  DAYSHORTNAME      VARCHAR2(64 BYTE),
  quarter_num       NUMBER(1),
  yearquarternum    NUMBER(5),
  daynumofquarter   NUMBER(2)
);

GRANT SELECT ON dim_date_time TO PUBLIC;

ALTER TABLE dim_date_time ADD
(
  CONSTRAINT PK_DIM_DATE_TIME PRIMARY KEY(datenum),
  CONSTRAINT UK_DIM_DATE_TIME  UNIQUE (DAYS_IN_DATE)
);
