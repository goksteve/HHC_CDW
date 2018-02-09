WITH
  sal AS
  (
    select --+ materialize
      c.cust_city_id, s.prod_id, t.calendar_quarter_id, sum(s.amount_sold) amount_sold
    FROM sales s, customers c, countries co, channels ch, times t
    WHERE s.channel_id = ch.channel_id AND ch.channel_total_id = 1
    AND s.cust_id = c.cust_id
    AND c.country_id = co.country_id
    AND s.promo_id = 999
    AND s.time_id = t.time_id
    AND (t.calendar_quarter_id = 1776 OR t.calendar_quarter_id = 1772)
    GROUP BY c.cust_city_id, s.prod_id, t.calendar_quarter_id
  ),
  tot as
  (
    SELECT --+ materialize
      *
    FROM
    (
      SELECT calendar_quarter_id, amount_sold
      FROM sal
    )
    PIVOT
    (        
      SUM(amount_sold) sold
      FOR calendar_quarter_id IN (1772 as old, 1776 as new)
    )
  ),
  city_list as
  ( -- Cities with 20% or more change:
    SELECT cust_city_id 
    FROM
    (-- Total sales for Cities in 2 quarters:
      SELECT cust_city_id, calendar_quarter_id, amount_sold
      FROM sal
    )
    PIVOT
    (
      SUM(amount_sold) sales
      FOR calendar_quarter_id IN (1772 as old_cust, 1776 as new_cust)
    )
    WHERE (new_cust_sales - old_cust_sales)/old_cust_sales >= 0.20
  ),
  prod_list AS 
  ( -- Top 20% of Products:
    SELECT prod_id
    FROM
    (
      SELECT
        s.prod_id,
        SUM(s.amount_sold),
        CUME_DIST() OVER (ORDER BY SUM(s.amount_sold)) cume_dist_prod
      FROM city_list ct 
      JOIN sal s ON s.cust_city_id = ct.cust_city_id AND s.calendar_quarter_id = 1776 
      GROUP BY s.prod_id
    )
    WHERE cume_dist_prod > 0.8
  )
SELECT
  prod_id,
  round(((g.new_sales/tot.new_sold) - (g.old_sales/tot.old_sold))*100, 10) share_changes
FROM
(-- Sales by Product:
  SELECT
    s.prod_id,
    SUM(CASE WHEN s.calendar_quarter_id = 1776 THEN s.amount_sold ELSE 0 END ) new_sales,
    SUM(CASE WHEN s.calendar_quarter_id = 1772 THEN s.amount_sold ELSE 0 END) old_sales
  from prod_list p
  join sal s on s.prod_id = p.prod_id
  group by s.prod_id
) g
cross join tot 
order by prod_id;