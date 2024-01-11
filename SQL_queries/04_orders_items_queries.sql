--Creating a new row ‘selling price’ and setting it as list_price – discount for order_items table:
ALTER TABLE order_items
ADD selling_price REAL;
UPDATE order_items
SET selling_price= list_price - discount;

--‘order_id’ is a foreign key that is a primary key in the orders table.  
--The order_items table holds purchase records for all products for each order.
--There is one-to-many relationship between orders and order_items.
--The ‘item_id’ is increases serially with the number of items purchased for each order. 
--‘product_id’ is again a foreign key that is the primary key in the products table.

--Number of entries for each type of order_status:
SELECT COUNT(*), order_status FROM orders
GROUP BY 2
ORDER BY 1 DESC;--Maximum entries have status 4, which means a completed order.
--Only entries having order_status 4 have a valid shipped_date.

--Cretaing view completed_orders for orders having order_status 4:
CREATE VIEW completed_orders AS
SELECT * FROM orders
WHERE order_status=4;
SELECT * FROM completed_orders;

--Creating view order_sales; order_id and qty*selling price for each:  
CREATE VIEW order_sales AS
SELECT order_id, 
	ROUND(SUM(quantity*selling_price)::NUMERIC, 2)
	AS total_order_price 
	FROM order_items
GROUP BY 1;
SELECT * FROM order_sales
ORDER BY 1;

--Creating view order_customer_sales for customer wise and order_id wise total sales for each order_id_order_customer_sales:
CREATE VIEW order_customer_sales AS
SELECT completed_orders.order_id,
	completed_orders.customer_id,
	order_sales.total_order_price
	FROM completed_orders
INNER JOIN order_sales ON 
	completed_orders.order_id= order_sales.order_id;
SELECT * FROM order_customer_sales;

--Considering the orders are paid for before shipment, daily total sales:
SELECT order_date, ROUND(SUM(quantity*selling_price):: NUMERIC, 2) AS daily_sales
FROM 
	(
		SELECT * FROM completed_orders
		INNER JOIN order_items USING(order_id)
	) AS cooi
GROUP BY 1
ORDER BY 2 DESC;--15/01/2018 has the highest sales.

--Average sales for each day of the week, out of completed orders (using order_date):
SELECT TO_CHAR(TO_DATE(co.order_date, 'YYYY-MM-DD'), 'DAY') AS day, 
	 ROUND(AVG(ocs.total_order_price)::NUMERIC, 2) AS avg_daily_sales 
FROM completed_orders AS co
INNER JOIN order_customer_sales AS ocs USING (customer_id)
GROUP BY 1
ORDER BY 2 DESC;--Monday has the highest sales.

--Best monthly sales ranked by total monthly sales (completed) 
SELECT  TO_CHAR(order_date::DATE,'yyyy-MM') AS year_month,
	ROUND(SUM(quantity*selling_price)::NUMERIC,2) AS monthly_sales,
	DENSE_RANK() OVER(ORDER BY ROUND(SUM(quantity*selling_price)::NUMERIC,2) DESC) 
	AS monthly_sale_rank
FROM
	(SELECT * FROM completed_orders 
	INNER JOIN order_items USING(order_id))
AS cooi
GROUP BY 1;--The month 2018/01 has the best sales.

--Yearly sales ranked (for completed orders only):
SELECT  TO_CHAR(order_date::DATE,'yyyy') AS year,
	ROUND(SUM(quantity*selling_price)::NUMERIC,2) AS yearly_sales,
	DENSE_RANK() OVER(ORDER BY ROUND(SUM(quantity*selling_price)::NUMERIC,2) DESC) 
	AS yearly_sale_rank
FROM
	(SELECT * FROM completed_orders 
	INNER JOIN order_items USING(order_id))
AS cooi
GROUP BY 1;--The year 2017 has the highest total sales.

--Highest state total sales for a year:
SELECT DISTINCT ON(state)
	state, year, MAX(state_total_sales) max_sales FROM
	(SELECT state, TO_CHAR(order_date::DATE,'yyyy') AS year,
		ROUND(SUM(quantity*selling_price)::NUMERIC, 2) AS state_total_sales
	FROM
		(SELECT * FROM completed_orders
		INNER JOIN order_items USING (order_id)) AS cooi
	INNER JOIN customers USING(customer_id)
	GROUP BY 1,2
	ORDER BY 1,3 DESC) AS cooic
GROUP BY 1,2;--New York has the highest sales in the year 2018.

--Five highest transactions and the corresponding customers, ranked by sales:
SELECT * FROM(
	SELECT ocs.customer_id,c.first_name, c.last_name,
		c.email, c.city, c.state, ocs.total_order_price,
		DENSE_RANK() OVER(ORDER BY ocs.total_order_price DESC) AS customer_rank
		FROM order_customer_sales AS ocs
	INNER JOIN customers AS c USING(customer_id) 
		) AS c_ranks
WHERE customer_rank<=5;--customer_id 73 has the highest (completed) sales.




