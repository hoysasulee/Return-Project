
/* Q1 Determine the top 3 products in Dec 2014 in terms of total sales. */

SELECT  product_name, sales as total_sales, rank() over(order by sales desc) as rank 
FROM (
  SELECT f.product_id, dp.product_name, sum(f.sales) sales
  FROM fact_sales f, dimension_product dp, dimension_time dt
  WHERE dp.product_id = f.product_id
    AND dt.t_date = f.t_date
    AND dt.t_month = '12'
    AND dt.t_year = '2014'
  GROUP BY f.product_id, dp.product_name
  ORDER BY sales DESC
) TAB
WHERE rownum <=3
;

/* Q2 Determine which store produced highest sales in the whole year? */

SELECT  store_name, sales as total_sales,rank() over(order by sales desc) as rank 
FROM (
  SELECT f.store_id, ds.store_name, sum(f.sales) sales
  FROM fact_sales f, dimension_store ds, dimension_time dt
  WHERE ds.store_id = f.store_id
    AND dt.t_date = f.t_date
    AND dt.t_year = '2014'
  GROUP BY f.store_id, ds.store_name
  ORDER BY sales DESC
) TAB
WHERE rownum =1
;
  
/* Q3 How many sales transactions were there for the product that generated maximum sales revenue
in 2014? Also identify:
a) product quantity sold, and
b) supplier name */

SELECT f.product_id as produc, dsu.supplier_name, count(*) num_trans, sum (f.quantity) quantity_sold 
FROM fact_sales f, dimension_product dp, dimension_supplier dsu, (
  SELECT rank() over(order by sales desc) as rank, product_id, supplier_id, sales 
  FROM (
    SELECT f.product_id, f.supplier_id, sum(f.sales) sales
    FROM fact_sales f
    GROUP BY f.product_id, f.supplier_id
    ORDER BY sales DESC
  ) TAB
  WHERE rownum <2
) d
WHERE f.product_id = dp.product_id
  AND dp.product_id = d.product_id
  AND f.supplier_id = dsu.supplier_id
  AND dsu.supplier_id = d.supplier_id
  AND d.rank = '1'
GROUP BY f.product_id, dp.product_name, f.supplier_id, dsu.supplier_name
;

/* Q4 Present the quarterly sales analysis for all stores using drill down query concepts, resulting in a
report that looks like:
STORE_NAME Q1_2014 Q2_2014 Q3_2014 Q4_2014 */

select distinct ds.store_name, 
  (select sum(sales) total_sales 
    from fact_sales f, dimension_time dt
    where f.t_date = dt.t_date and f.store_id = f.store_id and dt.t_quarter = 1
  ) Q1_2014, 
  (select sum(sales) total_sales 
    from fact_sales f, dimension_time dt
    where f.t_date = dt.t_date and f.store_id = f.store_id and dt.t_quarter = 2
  ) Q2_2014, 
  (select sum(sales) total_sales 
    from fact_sales f, dimension_time dt
    where f.t_date = dt.t_date and f.store_id = f.store_id and dt.t_quarter = 3
  ) Q3_2014, 
  (select sum(sales) total_sales 
    from fact_sales f, dimension_time dt
    where f.t_date = dt.t_date and f.store_id = f.store_id and dt.t_quarter = 4
  ) Q4_2014
from fact_sales f, dimension_store ds
where f.store_id = ds.store_id
order by store_name
;

/* Q5 Determine the top 3 products for a particular month (say Dec 2014), and for each of the 2 months
before that, in terms of total sales. */

SELECT  product_name, sales as total_sales, rank() over(order by sales desc) as rank 
FROM (
  SELECT f.product_id, dp.product_name, sum(f.sales) sales
  FROM fact_sales f, dimension_product dp, dimension_time dt
  WHERE dp.product_id = f.product_id
    AND dt.t_date = f.t_date
    AND dt.t_month = '12'
    AND dt.t_year = '2014'
  GROUP BY f.product_id, dp.product_name
  ORDER BY sales DESC
) TAB
WHERE rownum <=3
;

/* Q6 Create a materialised view called “STOREANALYSIS” that presents the product‐wise sales
analysis for each stordt. The results should be ordered by StoreID and then ProductID. */

DROP MATERIALIZED VIEW STOREANALYSIS;
CREATE MATERIALIZED VIEW STOREANALYSIS
(store_id, store_name, product_id, product_name, supplier_id, 
 supplier_name, price, quantity, sales, t_date, date_code, 
 t_week, t_month, quarter, t_year, t_day)
BUILD IMMEDIATE
REFRESH COMPLETE
ENABLE QUERY REWRITE  
  AS Select
      f.store_id, ds.store_name, f.product_id, dp.product_name, f.supplier_id, 
      dsu.supplier_name, dp.price, f.quantity, f.sales, f.t_date, dt.t_date_year,
      dt.t_week, dt.t_month, dt.t_quarter, dt.t_year, dt.t_day  
    FROM fact_sales f, dimension_store ds, dimension_product dp, dimension_supplier dsu, dimension_time dt
    WHERE f.store_id = ds.store_id
      AND f.product_id = dp.product_id
      AND f.supplier_id = dsu.supplier_id
      AND f.t_date = dt.t_date;

SELECT store_name as stor, product_name as produc, sales as store_total
FROM STOREANALYSIS
ORDER BY store_id, product_id;

/* Q7 Think about what information can be retrieved from the materialised view created in Q6 using
ROLLUP or CUBE concepts and provide some useful information of your choice for management. */	  

--ROLLUP
DROP MATERIALIZED VIEW STOREANALYSIS;
CREATE MATERIALIZED VIEW STOREANALYSIS
(store_id, store_name, product_id, product_name, supplier_id, 
 supplier_name, price, quantity, sales, t_date, date_code, 
 t_week, t_month, quarter, t_year, t_day)
BUILD IMMEDIATE
REFRESH COMPLETE
ENABLE QUERY REWRITE   
  AS Select
      f.store_id, ds.store_name, f.product_id, dp.product_name, f.supplier_id, 
      dsu.supplier_name, dp.price, f.quantity, f.sales, f.t_date, dt.t_date_year,
      dt.t_week, dt.t_month, dt.t_quarter, dt.t_year, dt.t_day  
    FROM fact_sales f, dimension_store ds, dimension_product dp, dimension_supplier dsu, dimension_time dt
    WHERE f.store_id = ds.store_id
      AND f.product_id = dp.product_id
      AND f.supplier_id = dsu.supplier_id
      AND f.t_date = dt.t_date;

SELECT DISTINCT store_name, product_name, sum(sales) as store_total
FROM STOREANALYSIS
WHERE t_week = 6
	AND product_id IN ('P-1002', 'P-1003', 'P-1005')
GROUP BY ROLLUP (store_name, product_name)
;

--CUBE
DROP MATERIALIZED VIEW STOREANALYSIS;
CREATE MATERIALIZED VIEW STOREANALYSIS
(store_id, store_name, product_id, product_name, supplier_id, 
 supplier_name, price, quantity, sales, t_date, date_code, 
 t_week, t_month, quarter, t_year, t_day)
BUILD IMMEDIATE
REFRESH COMPLETE
ENABLE QUERY REWRITE    
  AS Select
      f.store_id, ds.store_name, f.product_id, dp.product_name, f.supplier_id, 
      dsu.supplier_name, dp.price, f.quantity, f.sales, f.t_date, dt.t_date_year,
      dt.t_week, dt.t_month, dt.t_quarter, dt.t_year, dt.t_day  
    FROM fact_sales f, dimension_store ds, dimension_product dp, dimension_supplier dsu, dimension_time dt
    WHERE f.store_id = ds.store_id
      AND f.product_id = dp.product_id
      AND f.supplier_id = dsu.supplier_id
      AND f.t_date = dt.t_date;

SELECT DISTINCT store_name, product_name, sum(sales) as store_total
FROM STOREANALYSIS
WHERE t_week = 6
	AND product_id IN ('P-1002', 'P-1003', 'P-1005')
GROUP BY CUBE (store_name, product_name)
ORDER BY 1
;
