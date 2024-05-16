### Loading CSV files into a PostgreSQL Database and Querying the tables- Project
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
This repository contains two folders and three Python files: 

**Files(csv)** contains all the CSV files that have the data for corresponding tables. 

**SQL_queries** contains queries to extract information from the tables.  

The file **main.py** is used for loading the CSV files into the PgSQL DataBase.

Files **logger.py** is used for generating custom logs and **exception.py** is used for custom exception handling in main.

### List of tables I have primarily worked with:
1. **brands**: table to store information about different brand names of bikes.   
- **columns**:
  - brand_id--> unique id for each brand name.
  - brand_name--> name of the brand.
2. **categories**: table to store information about different categories of bikes.   
- **columns**:
  - category_id--> unique id for each category name.
  - category_name--> name of the category.
3. **customers**: table to store information about different customers.   
- **columns**:
  - customer_id--> unique id for each customer.
  - first_name--> first name of the customer.
  - last_name--> last name of the customer.
  - phone--> phone number of each customer.
  - email--> email id of each customer.
  - street--> address of each customer.
  - city--> city where each customer lives.
  - state--> state where each customer lives.
  - zip_code--> zip code of thew area where the customer lives.
4. **orders**: table to store information about different orders.   
- **columns**:
  - order_id--> unique id for each order.
  - customer_id--> customer ID of the customer who placed the order (referencing the 'customers' table).
  - order_status--> status of the order (ranges from 1 to 4, 4 being 'completed')
  - order_date--> date on which the order was placed.
  - required_date--> date when the order was required by the customer.
  - shipped_date--> date on which the order was shipped to the customer.
  - store_id--> store ID of the store where the customer placed the order (referencing the 'stores' table).
  - staff_id--> staff ID of the staff who facilitated the transaction with the customer (referencing the 'staffs' table).
5. **order_items**: table to store information about different items belonging to each order.   
- **columns**:
  - order_id--> unique ID for each order (referencing the 'orders' table).
  - item_id--> item ID of the item corresponding to each order.
  - product_id--> product ID of each product which is a part of the order(referencing to 'products' table).
  - quantity--> quantity of each product.
  - list_price--> list price of each product (referencing to 'products' table).
  - discount--> discount of each product.
6. **products**: table to store information about different products.   
- **columns**:
  - product_id--> unique ID for each product.
  - product_name--> name of each product.
  - brand_id--> brand ID of each product (referencing the 'brands' table).
  - category_id--> category ID of each product (referencing the 'categories' table).
  - model_year--> year of model of each product.
  - list_price--> list price of each product.
7. **staffs**: table to store information about different staff.   
- **columns**:
  - staff_id--> unique ID for each staff.
  - first_name--> first name of each staff.
  - last_name--> last name of each staff.
  - email--> email ID of each staff.
  - phone--> phone number of each staff
  - active--> active status of each staff; 0 means inactive, 1 means active.
  - store_id--> store ID of each staff (referencing the 'stores' table).
  - manager_id--> staff id of the manager of each staff; Null if there is no manager of a particular staff (referencing to 'staffs' table).
8. **stocks**: table to store information about different stocks of products at each store.   
- **columns**:
  - store_id--> unique ID for each brand name.
  - product_id--> product id of each product (referencing the 'products' table).
  - quantity--> quantity of each product available in a particular store.
9. **stores**: table to store information about different stores.   
- **columns**:
  - store_id--> unique ID for each brand name.
  - store_name--> name of the brand.
  - phone--> phone number of each store.
  - email-->email ID of each store.
  - street--> address of each store.
  - city--> city where each store is located.
  - state--> state where each store is located.
  - zip_code--> zip code of the area of each store.
10. **zip_lat_long**: table to store information about coordinates based on the zip code of a place.   
- **columns**:
  - zip_code--> unique zip code for each region.
  - lat--> latitude.
  - long--> longitude.
 

The **main.py** script contains the **csv_to_db_loader** class that has methods that:
  - Search for a folder that has 'CSV' in its name, in the working directory,
  - Get the list of all the CSV files in that folder,
  - Create separate dataframes for each CSV file using Pandas,
  - Create a PgSQL Database, whose name is passed as an instance variable of the class using Psycopg2,
  - Create tables in the database according to the list of the CSV files,
  - Load the dataframes into the tables in the PgSQL database.
  - -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
  ### ERD Diagram for visualization of the relation among various features of the tables.
  <img src="https://github.com/BeatrixKiddo5/Bike-Store-DB--PostgreSQL/assets/155089663/47ec73cf-bc44-4ddb-9beb-6f831fce6b88" width="850" height="600">


- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### Find the Sales dashboard using the above data, on Tableau Public
https://public.tableau.com/app/profile/milin.chakraborty/viz/GoodOldSalesDashboard/Dashboard1
<img src="https://github.com/BeatrixKiddo5/Bike-Store-DB--PostgreSQL/assets/155089663/07cc7786-c9ab-492c-89f9-91e92a241fbf" width="850" height="600">

