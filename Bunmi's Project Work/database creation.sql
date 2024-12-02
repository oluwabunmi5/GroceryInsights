#creating database
CREATE SCHEMA E_commerce;
#selecting database
USE E_commerce;

## Creating Tables ##
## DATA FOR CUSTOMER TABLE WAS IMPORTED ##
-- Creating Customer Table
CREATE TABLE customer(
    customer_id int primary key auto_increment,
    customer_name varchar(150) not null,
    contact_name varchar(255),
    address varchar(255),
    city varchar(255),
    postal_code varchar(255),
    country varchar(255)
);

## DATA FOR EMPLOYEE TABLE WAS IMPORTED ##
-- Creating employee Table
CREATE TABLE employee(
     employee_id int primary key auto_increment,
     first_name varchar(255) not null,
     last_name varchar(255) not null,
     birthdate date,
     photo varchar(255),
     notes text
);

## DATA FOR SUPPLIERS TABLE WAS IMPORTED ##
-- Creating Suppliers Table
CREATE TABLE suppliers(
     supplier_id int primary key auto_increment,
     supplier_name varchar(255) not null,
     contact_name varchar(255),
     address varchar(255),
     city varchar(255),
     postal_code varchar(255),
     country varchar(255),
     phone varchar(255)
);

## DATA FOR SHIPPERS TABLE WAS IMPORTED ##
-- Creating Shippers table
CREATE TABLE shippers(
	 shipper_id int primary key auto_increment,
     shipper_name varchar(255) not null,
     phone varchar(255)
);

## DATA FOR ORDERS TABLE WAS IMPORTED ##
-- Creating Orders Table
CREATE TABLE orders(
     order_id int primary key auto_increment,
     customer_id int,
     employee_id int,
     order_date date,
     shipper_id int,
     
     constraint customer_fk foreign key (customer_id) references customer(customer_id),
     constraint employee_fk foreign key (employee_id) references employee(employee_id),
     constraint shipper_fk foreign key (shipper_id) references shippers(shipper_id)
);

## DATA FOR CATEGORIES TABLE WAS IMPOERTED ##
-- Creating Categories Table
CREATE TABLE categories(
     category_id int primary key auto_increment,
     category_name varchar(255),
     description varchar(255)
);

## DATA FOR PRODUCTS TABLE WAS IMPORTED ##
-- Creating Products Table
CREATE TABLE products(
     product_id int primary key auto_increment,
     product_name varchar(255) not null,
     supplier_id int,
     category_id int,
     unit varchar(255),
     price double,
     
     constraint supplier_fk foreign key (supplier_id) references suppliers(supplier_id),
     constraint category_fk foreign key (category_id) references categories(category_id)
);

## DATA FOR ORDER DETAILS TABLE WAS IMPORTED ##
-- Creating Order details Table
CREATE TABLE order_details(
     orderdetails_id int primary key auto_increment,
     order_id int,
     product_id int,
     quantity int,
     
     constraint order_fk foreign key (order_id) references orders(order_id),
     constraint product_fk foreign key (product_id) references products(product_id)
);

## SOLUTION TO THE KPI QUESTIONS ##
-- 1 Returning the total number of products sold so far
SELECT count(product_id)  AS "Total number of products sold"
FROM order_details;

-- 2 Returning total revenue
SELECT sum(quantity * price) AS "Total revenue"
FROM products as p
JOIN order_details as o on o.product_id = p.product_id;

-- 4 Returning the total number of purchase transactions from customers
SELECT count(distinct(order_id)) AS "Total purchase transactions "
FROM orders;

-- 10 Returning the best selling product category
SELECT category_name AS "Best Selling Product", sum(price * quantity) as "Total_sales"
FROM products as p
JOIN order_details AS o on o.product_id = p.product_id
JOIN categories as c on c.category_id = o.orderdetails_id
GROUP BY category_name
ORDER BY sum(price * quantity) desc
LIMIT 1;

-- 11 Returning buyers who have transacted more than two times 
SELECT c.customer_name, c.customer_id, count(o.customer_id)
FROM customer as c
JOIN orders as o on o.customer_id = c.customer_id
GROUP BY c.customer_id
HAVING count(o.customer_id) > 2
ORDER BY count(o.customer_id)desc;

-- 12 Returning most successful employee
SELECT concat(first_name, last_name) AS "Most successful employee", sum(price * quantity) as "Total_sales"
FROM employee as e
JOIN order_details as o on e.employee_id = o.orderdetails_id
JOIN products as p on o.product_id = p.product_id
GROUP BY employee_id
ORDER BY sum(price * quantity) desc
LIMIT 1;

-- 13 Returning most used shipper
SELECT shipper_name as "Most used shipper"
FROM shippers as s
JOIN orders as o on o.shipper_id = s. shipper_id
GROUP BY o.shipper_id, shipper_name
ORDER BY count(order_id) desc
LIMIT 1;

-- 14 Returning the most used supplier
SELECT supplier_name as " Most used Supplier"
FROM suppliers as s
JOIN products as p on p.supplier_id = s.supplier_id
GROUP BY p.supplier_id, supplier_name
ORDER BY count(p.product_id) desc
LIMIT 1;

## SOLUTION TO ANALYSIS QUESTIONS ##
-- 3 Total Unique Products sold based on category
SELECT count(distinct(p.category_id)) AS "Total unique products sold"
FROM products as p
JOIN categories as c ON c.category_id = p.category_id;

-- 5 Compare Orders made between 2022 – 2023
SELECT order_id as "orders", year(order_date) AS "year"
from orders
where year(order_date) between 2022 and 2023;

-- 6 What is total number of customers? Compare those that have made transaction and those that haven’t at all
SELECT count(customer_id) as "total no of customers"
FROM customer;

SELECT count(distinct(customer_id)) as "customers that made transaction"
FROM orders;

SELECT count(c.customer_id) as "customers that haven't made an order"
FROM customer as c
LEFT JOIN orders as o on c.customer_id = o.customer_id
WHERE o.order_id is null;

-- 7 Who are the Top 5 customers with the highest purchase value?
SELECT customer_name as "Top 5 customers", (price * quantity) as "purchase value"
From products as p
Join order_details as O on o.product_id = p.product_id
JOIN customer as c on c.customer_id = o.orderdetails_id
ORDER BY (price * quantity) desc
LIMIT 5;

-- 8 Top 5 best-selling products.
SELECT p.product_name as "Top 5 best selling product", OD.product_id, sum(quantity) as "Total quantity"
FROM products as p
JOIN order_details as OD on p.product_id = OD.product_id
GROUP BY OD.product_id
ORDER BY sum(quantity) desc
LIMIT 5;

-- 9 What is the Transaction value per month?
SELECT count(order_id) AS "transaction value", monthname(order_date) AS "Month"
FROM orders
GROUP BY Month
ORDER BY Month;
