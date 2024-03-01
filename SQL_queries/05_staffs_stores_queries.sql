SELECT * FROM stores;
--There are three stores across three states in three cities.
SELECT * FROM staffs;
--‘staff_id’ 1, Fabiola Jackson has no manager_id, which implies that she is the head. 
--Everyone has ‘active_status’ as 1, so all the people currently work for the bike store chain.

--People working directly under Fabiola Jackson; they are store managers for three different stores:
SELECT * FROM staffs 
INNER JOIN stores AS s USING (store_id)
WHERE manager_id = 1;
--There are two people working under these three store managers.

--Total sales by each employee, ranked from highest to lowest:
SELECT ss.staff_id, s.first_name, s.last_name,s.store_id, ss.total_staff_sales, ss.sales_rank FROM	
	(SELECT DISTINCT (staff_id), 
		ROUND(SUM(quantity*selling_price)::NUMERIC,2) AS total_staff_sales,
		DENSE_RANK() OVER (ORDER BY ROUND(SUM(quantity*selling_price)::NUMERIC,2) DESC) AS sales_rank 
	FROM
		(SELECT * FROM 
			(SELECT * FROM completed_orders
			INNER JOIN order_items USING(order_id)) AS cooi
		INNER JOIN staffs USING(staff_id)) AS coois
	GROUP BY 1) AS ss
INNER JOIN staffs AS s ON ss.staff_id=s.staff_id
ORDER BY 6;--Employees of store_id 2 have the highest sales.
--Employees having staff_id 1, 4 and 5 have no sales, which implies that they are not associated with sales directly.

--Top three employees having highest sales for each year:
SELECT coois.year, coois.staff_id, s.first_name, s.last_name, 
coois.yearly_staff_sales, s.store_id, coois.sales_rank FROM 
	(SELECT staff_id, TO_CHAR(shipped_date::DATE,'YYYY') AS year, 
		ROUND(SUM(quantity*selling_price)::NUMERIC,2) AS yearly_staff_sales,
		DENSE_RANK() OVER (PARTITION BY TO_CHAR(shipped_date::DATE,'YYYY')
						   ORDER BY  ROUND(SUM(quantity*selling_price)::NUMERIC,2) DESC) AS sales_rank
	FROM
		(SELECT * FROM completed_orders
		INNER JOIN order_items USING (order_id)) AS cooi
	GROUP BY 1,2
	ORDER BY 2 DESC,3 DESC) AS coois
INNER JOIN staffs AS s USING(staff_id)
WHERE sales_rank <=3;--Years 2017 and 2018 have the same top three performing employees.

--Total sales for each store, ranked:
SELECT store_id, store_name, phone, email, state, ROUND(SUM(quantity*selling_price)::NUMERIC,2) store_total_sales FROM 
	(SELECT cooi.*, s.store_name, s.phone, s.email, s.state FROM 
		(SELECT co.order_id, co.store_id, oi.quantity, oi.selling_price
		FROM completed_orders AS co
		INNER JOIN order_items AS oi USING(order_id)) AS cooi
	INNER JOIN stores AS s USING (store_id)) AS coois
GROUP BY 1,2,3,4,5
ORDER BY 6 DESC;--Baldwin Bikes in New York has the highest sales.

--Best yearly sales for each store, ranked:
SELECT store_id, store_name, TO_CHAR(shipped_date::DATE,'yyyy') AS year,
	ROUND(SUM(quantity*selling_price)::NUMERIC, 2) AS store_total_sales,
	RANK()OVER(PARTITION BY store_name
			   ORDER BY ROUND(SUM(quantity*selling_price)::NUMERIC, 2) DESC) 
	FROM
	(SELECT cooi.*, s.store_name, s.phone, s.email, s.state FROM 
		(SELECT order_id,shipped_date, store_id, oi.quantity, oi.selling_price
		FROM completed_orders AS co
		INNER JOIN order_items AS oi USING (order_id)) AS cooi
	INNER JOIN stores AS s USING(store_id)) AS coois
GROUP BY 1, 2, 3;--All the stores had the best sales in 2017.

--Store wise best selling products and their corresponding brands and categories:
WITH tab1 AS (SELECT * FROM	
	(SELECT store_id, store_name, product_id, product_name, ROUND(SUM(quantity*selling_price)::NUMERIC, 2) AS store_product_total_sales,
	RANK () OVER(PARTITION BY store_id ORDER BY ROUND(SUM(quantity*selling_price)::NUMERIC, 2) DESC) store_pdt_sales_rank
	FROM completed_orders AS co
	INNER JOIN order_items AS oi USING(order_id)
	INNER JOIN products AS p USING(product_id)
	INNER JOIN stores AS s USING(store_id)
	GROUP BY 1,2,3,4) AS cooips
WHERE store_pdt_sales_rank <=5)
SELECT tab1.store_id, tab1.store_name, tab1.product_id, tab1.product_name, p.brand_id, b.brand_name, 
p.category_id, c.category_name, tab1.store_product_total_sales FROM tab1
INNER JOIN products AS p USING(product_id)
INNER JOIN brands AS b USING(brand_id)
INNER JOIN categories AS c USING(category_id)
INNER JOIN stores AS s USING(store_id);--product_id 7 has the highest sales across every store.

--Staff wise best selling products and their corresponding brands and categories:
SELECT staff_id, ss.first_name, ss.last_name, ss.store_id, s.store_name, product_id, p.product_name, brand_id, 
brand_name, category_id, category_name, staff_product_total_sales, staff_pdt_sales_rank FROM 	
	(SELECT staff_id, first_name, product_id, product_name, ROUND(SUM(quantity*selling_price)::NUMERIC, 2) AS staff_product_total_sales,
	RANK () OVER(PARTITION BY staff_id ORDER BY ROUND(SUM(quantity*selling_price)::NUMERIC, 2) DESC) staff_pdt_sales_rank
	FROM completed_orders AS co
	INNER JOIN order_items AS oi USING(order_id)
	INNER JOIN products AS p USING(product_id)
	INNER JOIN staffs AS ss USING(staff_id)
	GROUP BY 1,2,3,4) AS cooipss
INNER JOIN products AS p USING(product_id)
INNER JOIN brands AS b USING(brand_id)
INNER JOIN categories AS c USING(category_id)
INNER JOIN staffs AS SS USING(staff_id)
INNER JOIN stores AS s USING(store_id)
WHERE staff_pdt_sales_rank<=3;--brand_id 9 has the best sales by all the sales employees.

--Highest transaction with customers by each staff for each year (based on completed orders):
SELECT cooi.year, cooi.staff_id, ss.first_name, ss.last_name, ss.store_id, s.store_name, s.state,
cooi.customer_id, c.first_name, c.last_name, c.city, c.state, cooi.staff_customer_sales, cooi.staff_sales_rank FROM 	
	(SELECT TO_CHAR(co.order_date::DATE,'yyyy') AS year, co.staff_id, co.customer_id,
	ROUND(SUM(oi.quantity*oi.selling_price)::NUMERIC,2) AS staff_customer_sales,
	RANK() OVER(PARTITION BY TO_CHAR(co.order_date::DATE,'yyyy') ORDER BY ROUND(SUM(oi.quantity*oi.selling_price)::NUMERIC,2) DESC) AS staff_sales_rank
	FROM completed_orders AS co
	INNER JOIN order_items AS oi USING(order_id)
	GROUP BY 1,2,3) AS cooi
INNER JOIN staffs AS ss USING(staff_id)
INNER JOIN customers AS c USING(customer_id)
INNER JOIN stores AS s USING(store_id)
WHERE staff_sales_rank<=5
ORDER BY 1 DESC, 14;--All top transactions are for the NY store, with customers from NY as well.

--Finding yearly revenue for each store, using pivot tables:
SELECT store_id, store_name,
SUM(CASE WHEN year = '2016' THEN revenue END) AS revenue_2016,
SUM(CASE WHEN year = '2017' THEN revenue END) AS revenue_2017,
SUM(CASE WHEN year = '2018' THEN revenue END) AS revenue_2018
FROM 
	(SELECT co.store_id, s.store_name, TO_CHAR(co.order_date::DATE,'yyyy') AS year, 
	 ROUND(SUM(oi.selling_price)::NUMERIC) AS revenue
	FROM completed_orders AS co
	INNER JOIN order_items AS oi USING(order_id)
	INNER JOIN stores As s USING(store_id)
	GROUP BY 1, 2, 3) AS coois
GROUP BY 1,2
ORDER BY 1;

--Finding yearly revenue by each salesperson using pivot tables:
SELECT staff_id, first_name, last_name,  
SUM(CASE WHEN year = '2016' THEN revenue END) AS revenue_2016,
SUM(CASE WHEN year = '2017' THEN revenue END) AS revenue_2017,
SUM(CASE WHEN year = '2018' THEN revenue END) AS revenue_2018
FROM 
	(SELECT co.staff_id, s.first_name,  s.last_name, 
	 TO_CHAR(co.order_date::DATE,'yyyy') AS year, ROUND(SUM(oi.selling_price)::NUMERIC) AS revenue
	FROM completed_orders AS co
	INNER JOIN order_items AS oi USING(order_id)
	INNER JOIN staffs As s USING(staff_id)
	GROUP BY 1, 2, 3, 4) AS coois
GROUP BY 1, 2, 3
ORDER BY 1;