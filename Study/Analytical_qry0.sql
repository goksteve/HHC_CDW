WITH prod_list AS --START: Top 20% of products
( SELECT prod_id prod_subset, cume_dist_prod
FROM --START: All products Sales for city subset
( SELECT s.prod_id, SUM(amount_sold),
CUME_DIST() OVER (ORDER BY SUM(amount_sold)) cume_dist_prod
FROM sales s, customers c, channels ch, products p, times t
WHERE s.prod_id = p.prod_id AND p.prod_total_id = 1 AND
s.channel_id = ch.channel_id AND ch.channel_total_id = 1 AND
s.cust_id = c.cust_id AND
s.promo_id = 999 AND
s.time_id = t.time_id AND t.calendar_quarter_id = 1776 AND
c.cust_city_id IN
(SELECT cust_city_id --START: Top 20% of cities
FROM
(
SELECT cust_city_id, ((new_cust_sales - old_cust_sales)
/ old_cust_sales ) pct_change, old_cust_sales
FROM
(
SELECT cust_city_id, new_cust_sales, old_cust_sales
FROM
( --START: Cities AND sales for 1 country in 2 periods
SELECT cust_city_id,
SUM(CASE WHEN t.calendar_quarter_id = 1776
THEN amount_sold ELSE 0 END ) new_cust_sales,
SUM(CASE WHEN t.calendar_quarter_id = 1772
THEN amount_sold ELSE 0 END) old_cust_sales
FROM sales s, customers c, channels ch,
products p, times t
WHERE s.prod_id = p.prod_id AND p.prod_total_id = 1 AND
s.channel_id = ch.channel_id AND ch.channel_total_id = 1 AND
s.cust_id = c.cust_id AND c.country_id = 52790 AND
s.promo_id = 999 AND
s.time_id = t.time_id AND
(t.calendar_quarter_id = 1776 OR t.calendar_quarter_id =1772)
GROUP BY cust_city_id
) cust_sales_wzeroes
WHERE old_cust_sales > 0
) cust_sales_woutzeroes
) --END: Cities and sales for country in 2 periods
WHERE old_cust_sales > 0 AND pct_change >= 0.20)
--END: Top 20% of cities
GROUP BY s.prod_id
) prod_sales --END: All products sales for city subset
WHERE cume_dist_prod > 0.8 --END: Top 20% products
)
--START: Main query bloc
SELECT prod_id, round(( (new_subset_sales/new_tot_sales)
- (old_subset_sales/old_tot_sales)
) *100, 10) share_changes
FROM
( --START: Total sales for country in later period
SELECT prod_id,
SUM(CASE WHEN t.calendar_quarter_id = 1776
THEN amount_sold ELSE 0 END ) new_subset_sales,
(SELECT SUM(amount_sold) FROM sales s, times t, channels ch,
customers c, countries co, products p
WHERE s.time_id = t.time_id AND t.calendar_quarter_id = 1776 AND
s.channel_id = ch.channel_id AND ch.channel_total_id = 1 AND
s.cust_id = c.cust_id AND
c.country_id = co.country_id AND co.country_total_id = 52806 AND
s.prod_id = p.prod_id AND p.prod_total_id = 1 AND
s.promo_id = 999
) new_tot_sales,
--END: Total sales for country in later period
--START: Total sales for country in earlier period
SUM(CASE WHEN t.calendar_quarter_id = 1772
THEN amount_sold ELSE 0 END) old_subset_sales,
(SELECT SUM(amount_sold) FROM sales s, times t, channels ch,
customers c, countries co, products p
WHERE s.time_id = t.time_id AND t.calendar_quarter_id = 1772 AND
s.channel_id = ch.channel_id AND ch.channel_total_id = 1 AND
s.cust_id = c.cust_id AND
c.country_id = co.country_id AND co.country_total_id = 52806 AND
s.prod_id = p.prod_id AND p.prod_total_id = 1 AND
s.promo_id = 999
) old_tot_sales
--END: Total sales for country in earlier period
FROM sales s, customers c, countries co, channels ch, times t
WHERE s.channel_id = ch.channel_id AND ch.channel_total_id = 1 AND
s.cust_id = c.cust_id AND
c.country_id = co.country_id AND co.country_total_id = 52806 AND
s.promo_id = 999 AND
s.time_id = t.time_id AND
(t.calendar_quarter_id = 1776 OR t.calendar_quarter_id = 1772)
AND s.prod_id IN
(SELECT prod_subset FROM prod_list)
GROUP BY prod_id)
order by prod_id;