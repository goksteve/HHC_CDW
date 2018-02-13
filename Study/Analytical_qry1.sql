WITH
  sal AS
  (
    SELECT /*+ materialize */ *
    FROM
    (
      SELECT c.cust_city_id, s.prod_id, t.calendar_quarter_id, s.amount_sold
      FROM sales s
      JOIN customers c ON c.cust_id = s.cust_id
      JOIN countries co ON co.country_id = c.country_id
      JOIN channels ch ON ch.channel_id = s.channel_id AND ch.channel_total_id = 1
      JOIN times t ON t.time_id = s.time_id AND t.calendar_quarter_id IN (1772, 1776)
      WHERE s.promo_id = 999
    )
    PIVOT
    (
      SUM(amount_sold) AS sold
      FOR calendar_quarter_id IN (1772 old, 1776 new) 
    )
  ),
  tot as
  (
    SELECT SUM(old_sold) old_total_sold, SUM(new_sold) new_total_sold
    FROM sal
  ),
  city_list as
  ( -- Cities with 20% or more change in Sales:
    SELECT cust_city_id 
    FROM
    (-- Total Sales for Cities in 2 quarters:
      SELECT cust_city_id, SUM(old_sold) old_sold, SUM(new_sold)
      FROM sal
    )
    PIVOT
    (
      SUM(amount_sold) sales
      FOR calendar_quarter_id IN (1772 as old_cust, 1776 as new_cust)
    )
    WHERE (new_cust_sales - old_cust_sales)/old_cust_sales >= 0.20
  ),
  prod_list AS -- Top 20% of Products:
  ( 
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