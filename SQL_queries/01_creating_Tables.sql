--Creating tables for each csv file in the public schema. 

--Creating table 'brands'
CREATE TABLE public.brands
(
	brand_id INTEGER,
	brand_name VARCHAR(20)
);

--Creating table 'categories'
CREATE TABLE public.categories
(
	category_id INTEGER,
	category_name VARCHAR(30)
);

--Creating table 'customers'
CREATE TABLE public.customers
(
	customer_id INTEGER,
	first_name VARCHAR(30),
	last_name VARCHAR(30),
	phone VARCHAR(15),
	email VARCHAR(100),
	street VARCHAR(70),
	city VARCHAR(20),
	state VARCHAR(5),
	zip_code INTEGER
);

--Creating table 'order_items'
CREATE TABLE public.order_items
(
	order_id INTEGER,
	item_id INTEGER,
	product_id INTEGER,
	quantity INTEGER,
	list_price INTEGER,
	discount REAL
);

--Creating table 'orders'
CREATE TABLE public.orders
(
	order_id INTEGER,
	customer_id INTEGER,
	order_status INTEGER,
	order_date DATE,
	required_date DATE,
	shipped_date DATE,
	store_id INTEGER,
	staff_id INTEGER
);

--Creating table 'products'
CREATE TABLE public.products
(
	product_id INTEGER,
	product_name VARCHAR(20),
	brand_id INTEGER,
	category_id INTEGER,
	model_year INTEGER,
	list_price REAL	
);

--Creating table 'staffs'
CREATE TABLE public.staffs
(
	staff_id INTEGER,
	first_name VARCHAR(20),
	last_name VARCHAR(30),	
	email VARCHAR(100),
	phone VARCHAR(20),
	active INTEGER,
	store_id INTEGER,
	manager_id INTEGER
);

--Creating table 'stocks'
CREATE TABLE public.stocks
(
	store_id INTEGER,
	product_id INTEGER,
	quantity INTEGER
);

--Creating table 'stores'
CREATE TABLE public.stores
(
	store_id INTEGER,
	store_name VARCHAR(100),
	phone VARCHAR(50),
	email VARCHAR(200),
	street VARCHAR(200),
	city VARCHAR(70),
	state VARCHAR(50),
	zip_code INTEGER	
);

--The corresponding csv files are imported into each table according to the necessary options.

--Setting Primary Keys for tables.

--Setting 'brand_id' as primary key for table 'brands'
ALTER TABLE brands 
ADD PRIMARY KEY (brand_id);
SELECT * FROM brands;

--Setting 'category_id' as primary key for table 'categories'
ALTER TABLE categories 
ADD PRIMARY KEY (category_id);
SELECT * FROM categories;

--Setting 'customer_id' as primary key for table 'customers'
ALTER TABLE customers 
ADD PRIMARY KEY (customer_id);
SELECT * FROM customers;

--Setting 'order_id' as primary key for table 'orders'
ALTER TABLE orders 
ADD PRIMARY KEY (order_id);
SELECT * FROM orders;

--Setting 'product_id' as primary key for table 'products'
ALTER TABLE products 
ADD PRIMARY KEY (product_id);
SELECT * FROM products;

--Setting 'staff_id' as primary key for table 'staffs'
ALTER TABLE staffs 
ADD PRIMARY KEY (staff_id);
SELECT * FROM staffs;

--Setting 'store_id' as primary key for table 'stores'
ALTER TABLE stores 
ADD PRIMARY KEY (store_id);
SELECT * FROM stores;

