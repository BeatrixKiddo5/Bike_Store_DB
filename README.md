### Bike Store Database- PostgreSQL Project
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
This repository contains two folders: **Files(csv)** and **SQL_queries**. **Files(csv)** contains all the csv files containing data for corresponding tables. **SQL_queries** contains queries to extract information from the tables.
###List of tables:
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
  - customer_id--> customer id of the customer who placed the order (referencing to 'customers' table).
  - order_status--> status of the order (ranges from 1 to 4, 4 being 'completed')
  - order_date--> date on which the order was placed.
  - required_date--> date when the order was required by the customer.
  - shipped_date--> date on which the order was shipped to the customer.
  - store_id--> store id of the store where the customer placed the order (referencing to 'stores' table).
  - staff_id--> staff if of the staff who facilitated the transaction with the customer (referencing to 'staffs' table).
5. **order_items**: table to store information about different items belonging to each order.   
- **columns**:
  - order_id--> unique id for each order (referencing to 'orders' table).
  - item_id--> item id of the item corresponding to each order.
  - product_id--> product id of each product which is a part of the order(referencing to 'products' table).
  - quantity--> quantity of each product.
  - list_price--> list price of each product (referencing to 'products' table).
  - discount--> discount of each product.
6. **products**: table to store information about different products.   
- **columns**:
  - product_id--> unique id for each product.
  - product_name--> name of each product.
  - brand_id--> brand id of each product (referencing to 'brands' table).
  - category_id--> category id of each product (referencing to 'categories' table).
  - model_year--> year of model of each product.
  - list_price--> list price of each product.
7. **staffs**: table to store information about different staffs.   
- **columns**:
  - staff_id--> unique id for each staff.
  - first_name--> first name of each staff.
  - last_name--> last name of each staff.
  - email--> email id of each staff.
  - phone--> phone number of each staff
  - active--> active status of each staff; 0 means inactive, 1 means active.
  - store_id--> store id of each staff (referencing to 'stores' table).
  - manager_id--> staff id of the manager of each staff; Null if there is no manager of a particular staff (referencing to 'staffs' table).
8. **stocks**: table to store information about different stocks of products at each store.   
- **columns**:
  - store_id--> unique id for each brand name.
  - product_id--> product id of each product (referencing to 'products' table).
  - quantity--> quantity of each product available in a particular store.
9. **stores**: table to store information about different stores.   
- **columns**:
  - store_id--> unique id for each brand name.
  - store_name--> name of the brand.
  - phone--> phone number of each store.
  - email-->email id of each store.
  - street--> address of each store.
  - city--> city where each store is located.
  - state--> state where each store is located.
  - zip_code--> zip code of the area of each store.
  - -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
  ### Visualization of the relation among various features of the tables.
  <img src="https://github.com/BeatrixKiddo5/Bike-Store-DB--PostgreSQL/assets/155089663/47ec73cf-bc44-4ddb-9beb-6f831fce6b88" width="850" height="600">



