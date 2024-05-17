--The corresponding csv files are loaded into each table using the 'main.py' script.

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

