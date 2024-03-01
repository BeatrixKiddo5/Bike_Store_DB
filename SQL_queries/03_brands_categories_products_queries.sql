SELECT * FROM brands;
SELECT * FROM categories;
SELECT * FROM products;
--products table has brand and category ids for each product, along with model year and list price.
--However, for aggregations we consider selling_price instead of list_price for each product.
--There are 321 products belonging to 9 brands and 7 categories. 

--Number of products fro each brand:
SELECT brand_id, brand_name, COUNT(*) AS num_products FROM products
INNER JOIN brands USING(brand_id)
GROUP BY 1,2
ORDER BY 3 DESC;-- brand_id 9 has the largest number of products.

--Product wise total (completed) sales with corresponding brand and category, ranked from highest to lowest:
SELECT oi.product_id, p.product_name, p.brand_id, b.brand_name, p.category_id, c.category_name,
ROUND(SUM(oi.quantity*oi.selling_price)::NUMERIC,2) AS pdt_total_sales,
DENSE_RANK() OVER(ORDER BY ROUND(SUM(oi.quantity*oi.selling_price)::NUMERIC,2) DESC) AS pdt_sales_rank
FROM completed_orders AS co
INNER JOIN order_items AS oi USING (order_id)
INNER JOIN products AS p USING(product_id)
INNER JOIN brands AS b USING(brand_id)
INNER JOIN categories AS c USING(category_id)
GROUP BY 1,2,3,4,5,6;--product_id 7 has the highest total sales.

--Category wise (completed) sales, ranked from highest to lowest:
SELECT p.category_id, c.category_name, ROUND(SUM(oi.quantity*oi.selling_price)::NUMERIC,2) AS category_total_sales,
DENSE_RANK()OVER(ORDER BY ROUND(SUM(oi.quantity*oi.selling_price)::NUMERIC,2) DESC) ctgy_total_sales_rank
FROM completed_orders AS co
INNER JOIN order_items AS oi USING(order_id)
INNER JOIN products AS p USING(product_id)
INNER JOIN categories AS c USING(category_id)
GROUP BY 1,2;--category_id 6 has the highest sales.

--Brand wise (completed) sales, ranked from highest to lowest:
SELECT pbooi.brand_id, b.brand_name,
ROUND(SUM(pbooi.quantity*pbooi.selling_price)::NUMERIC,2) AS brand_total_sales,
DENSE_RANK()OVER(ORDER BY ROUND(SUM(pbooi.quantity*pbooi.selling_price)::NUMERIC,2) DESC) AS brand_sales_rank
FROM
	(SELECT ps.*, p.brand_id, p.category_id, p.product_name FROM 	
		(SELECT * FROM order_items
		INNER JOIN completed_orders USING (order_id)) AS ps
	INNER JOIN products AS p USING (product_id)) AS pbooi	
INNER JOIN brands AS b USING (brand_id)
GROUP BY 1,2;--brand_id 9 has the highest sales.

--Best selling products for each category, in decreasing order or category total sales (based on completed orders only):
WITH tab1 AS
(SELECT p.category_id, c.category_name, ROUND(SUM(oi.quantity*oi.selling_price)::NUMERIC,2) AS category_total_sales,
DENSE_RANK()OVER(ORDER BY ROUND(SUM(oi.quantity*oi.selling_price)::NUMERIC,2) DESC) ctgy_total_sales_rank
FROM completed_orders AS co
INNER JOIN order_items AS oi USING(order_id)
INNER JOIN products AS p USING(product_id)
INNER JOIN categories AS c USING(category_id)
GROUP BY 1,2)
, tab2 AS
(SELECT * FROM	
	(SELECT oi.product_id, p.product_name, p.category_id, c.category_name,
	ROUND(SUM(oi.quantity*oi.selling_price)::NUMERIC,2) AS pdt_total_sales,
	DENSE_RANK() OVER(PARTITION BY category_id ORDER BY ROUND(SUM(oi.quantity*oi.selling_price)::NUMERIC,2) DESC) AS pdt_sales_rank
	FROM completed_orders AS co
	INNER JOIN order_items AS oi USING (order_id)
	INNER JOIN products AS p USING(product_id)
	INNER JOIN categories AS c USING(category_id)
	GROUP BY 1,2,3,4) AS cooipc
WHERE pdt_sales_rank=1)
SELECT category_id, category_name, category_total_sales,
product_id AS highest_selling_product_id, product_name AS highest_selling_product_name, 
pdt_total_sales AS highest_selling_pdt_total_sales FROM tab2
INNER JOIN tab1 USING(category_id, category_name)
ORDER BY 3 DESC;--product_id 7 of category_id 6 has the highest sales.

--Best selling products for each brand, in decreasing order of brand total sales (based on completed orders only):
WITH tab1 AS (SELECT brand_id, product_id, product_name AS max_selling_product_name, 
			  product_total_sales AS max_selling_product_sales FROM 
	(SELECT  p .brand_id, cooi.product_id, p.product_name, cooi.product_total_sales,
			RANK() OVER (PARTITION BY p .brand_id
						 ORDER BY cooi.product_total_sales DESC) FROM 
		(SELECT oi.product_id, ROUND(SUM(oi .quantity*oi.selling_price)::NUMERIC, 2) AS product_total_sales
		FROM completed_orders AS co
		INNER JOIN order_items AS oi USING (order_id)
		GROUP BY 1) AS cooi
	INNER JOIN products AS p USING (product_id)
	ORDER BY 1) AS cooip 
WHERE rank = 1),
tab2 AS
(SELECT b.*, ROUND(SUM(cooip.total_sales)::NUMERIC, 2) AS brand_total_sales FROM	
	(SELECT cooi.*, p.brand_id FROM 	
		(SELECT oi.product_id, ROUND(SUM(oi.quantity*oi.selling_price)::NUMERIC, 2) AS total_sales
		FROM completed_orders AS co
		INNER JOIN order_items AS oi USING (order_id)
		GROUP BY 1) AS cooi
	INNER JOIN products AS p USING (product_id)) AS cooip
INNER JOIN brands AS b USING (brand_id)
GROUP BY 1)
SELECT * FROM tab2
INNER JOIN tab1 USING (brand_id)
ORDER BY 3 DESC;--product_id 7 of brand_id 9 has the highest sales. 

--Top three selling products and their corresponding brands and categories, for each year(based on completed orders):
SELECT * FROM 	
	(SELECT TO_CHAR(order_date:: DATE, 'yyyy') AS year, product_id, product_name, brand_id, brand_name, 
	 category_id, category_name, ROUND(SUM(quantity*selling_price)::NUMERIC, 2) AS pdt_total_yearly_sales,
	RANK() OVER(PARTITION BY TO_CHAR(order_date:: DATE, 'yyyy')
				ORDER BY ROUND(SUM(quantity*selling_price)::NUMERIC, 2) DESC) AS pdt_sales_rank
	FROM completed_orders AS co
	INNER JOIN order_items AS oi USING(order_id)
	INNER JOIN products AS p USING(product_id)
	INNER JOIN brands AS b USING(brand_id)
	INNER JOIN categories AS c USING(category_id)
	GROUP BY 2,3,4,5,6,7,1) AS cooipbc
WHERE pdt_sales_rank<=3
ORDER BY 1 DESC, 9;--All the products belong to brand_id 9. The category for top selling product for each year is different.

--Total number of bikes launched every year by a brand, using pivot tables:
SELECT brand_id, brand_name,
COALESCE(SUM(CASE WHEN model_year = '2016' THEN count END), 0) AS n_pdt_2016,
COALESCE(SUM(CASE WHEN model_year = '2017'THEN count END), 0) AS n_pdt_2017,
COALESCE(SUM(CASE WHEN model_year = '2018'THEN count END), 0) AS n_pdt_2018 
FROM
	(SELECT p.brand_id, b.brand_name, model_year, COUNT(*)FROM products AS p
	INNER JOIN brands AS b USING(brand_id)
	GROUP BY 1, 2, 3) AS pb
GROUP BY 1, 2
ORDER BY 1;

--Finding yearly revenue for each brand using pivot tables:
SELECT brand_id, brand_name, 
COALESCE(SUM(CASE WHEN year = '2016' THEN revenue END),0) AS revenue_2016,
COALESCE(SUM(CASE WHEN year = '2017' THEN revenue END),0) AS revenue_2017,
COALESCE(SUM(CASE WHEN year = '2018' THEN revenue END),0) AS revenue_2018
FROM 
	(SELECT b.brand_id, b.brand_name, TO_CHAR(co.order_date::DATE,'yyyy') AS year, 
		ROUND(SUM(oi.selling_price*oi.quantity)::NUMERIC, 2) AS revenue FROM completed_orders AS co
	INNER JOIN order_items AS oi USING(order_id)
	INNER JOIN products AS p USING(product_id)
	INNER JOIN brands AS b USING(brand_id)
	GROUP BY 1, 2, 3) AS cooipb
GROUP BY 1, 2
ORDER BY 1;

--Finding yearly revenue for each product using pivot tables:
SELECT product_id, product_name, brand_name,
COALESCE(SUM(CASE WHEN year = '2016' THEN revenue END), 0) AS revenue_2016,
COALESCE(SUM(CASE WHEN year = '2017' THEN revenue END),0) AS revenue_2017,
COALESCE(SUM(CASE WHEN year = '2018' THEN revenue END),0) AS revenue_2018
FROM
	(SELECT oi.product_id, p.product_name, b.brand_name, TO_CHAR(co.order_date::DATE,'yyyy') AS year,
		ROUND(SUM(oi.selling_price*oi.quantity)::NUMERIC, 2) AS revenue FROM completed_orders AS co
	INNER JOIN order_items AS oi USING(order_id)
	INNER JOIN products AS p USING(product_id)
	INNER JOIN brands AS b USING(brand_id)
	GROUP BY 1, 2, 3, 4) AS cooipb
GROUP BY 1, 2, 3
ORDER BY 1;

--Finding yearly revenue for each category using pivot tables:
SELECT category_id, category_name,
COALESCE(SUM(CASE WHEN year = '2016' THEN revenue END),0) AS revenue_2016,
COALESCE(SUM(CASE WHEN year = '2017' THEN revenue END), 0) AS revenue_2017,
COALESCE(SUM(CASE WHEN year = '2018' THEN revenue END), 0) AS revenue_2018
FROM
	(SELECT p.category_id, c.category_name, TO_CHAR(co.order_date::DATE,'yyyy') AS year,
		ROUND(SUM(oi.quantity*oi.selling_price)::NUMERIC, 2) AS revenue FROM completed_orders AS co
	INNER JOIN order_items AS oi USING(order_id)
	INNER JOIN products AS p USING(product_id)
	INNER JOIN categories AS c USING(category_id)
	GROUP BY 1, 2, 3) AS cooipc
GROUP BY 1, 2
ORDER BY 1;
