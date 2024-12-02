## answers to section A ##
-- 1. Select customer name together with each order the customer made
SELECT customer_name, order_id
FROM customer as c
JOIN  orders as o on c.customer_id = o.customer_id;

-- 2. Select order id together with name of employee who handled the order
SELECT order_id, concat(first_name," ",last_name) AS "Employee name"
FROM orders as o
JOIN employee as e on o.employee_id = e.employee_id;

-- 3. Select customers who did not placed any order yet
SELECT c.customer_id as "customers that haven't made an order"
FROM customer as c
LEFT JOIN orders as o on c.customer_id = o.customer_id
WHERE o.order_id is null;

-- 4. Select order id together with the name of products
SELECT order_id, product_name
FROM order_details as o
JOIN products as p on o.product_id = p.product_id;

-- 5. Select products that no one bought
SELECT p.product_id as "products no one bought"
FROM products as p
JOIN order_details as o on p.product_id = o.product_id
WHERE o.product_id is null;

-- 6. Select customer together with the products that he bought.
SELECT customer_name as "cutomers", OD.product_id as "products"
FROM customer as c
JOIN orders as o on c.customer_id = o.customer_id
JOIN order_details as OD on o.order_id = OD.order_id
JOIN products as p on OD.product_id = p.product_id;

-- 7. Select product names together with the name of corresponding category
SELECT product_name, category_name
FROM products as p
JOIN categories as c on p.category_id = c.category_id;

-- 8. Select orders together with the name of the shipping company
SELECT order_id, shipper_name
FROM orders as o
JOIN shippers as s on o.shipper_id = s.shipper_id;

-- 9. Select customers with id greater than 50 together with each order they made.
SELECT c.customer_id, order_id
FROM customer as c
JOIN orders as o on c.customer_id = o.customer_id
WHERE c.customer_id > 50;

-- 10. Select employees together with orders with order id greater than 10400
SELECT employee_id as "Employee", order_id as "orders"
FROM orders
WHERE order_id > 10400;

-- 11. Select the most expensive product
SELECT product_name as "most expensive product"
FROM products
ORDER BY price desc
LIMIT 1;

-- 12. Select the second most expensive product.
SELECT product_name as " second most expensive product"
FROM products
ORDER BY price desc
LIMIT 1,1;

-- 13. Select name and price of each product, sort the result by price in decreasing order
SELECT product_name, price
FROM products
ORDER BY price desc;

-- 14  Select 5 most expensive products
SELECT product_name as "5 most expensive product"
FROM products
ORDER BY price desc
LIMIT 5;

-- 15. Select 5 most expensive products without the most expensive (in final 4 products)
SELECT product_name as " 4 most expensive product"
FROM products
WHERE price < (SELECT max(price)FROM products)
ORDER BY price desc
LIMIT 4;

-- 16. Select name of the cheapest product (only name) without using LIMIT and OFFSET
SELECT product_name as "cheapest product"
FROM products
WHERE price = (SELECT min(price) FROM
products);

-- 17. Select name of the cheapest product (only name) using subquery
SELECT product_name as "cheapest product"
FROM products
WHERE price = (SELECT min(price) FROM
products);

-- 18. Select number of employees with LastName that starts with 'D'.
SELECT count(*)
FROM employee
WHERE trim(last_name) LIKE 'D%';

-- 19. Select customer name together with the number of orders made by the corresponding customer, sort the result by number of orders in decreasing order.
SELECT customer_name, count(order_id) as " Number of orders"
FROM customer as c
JOIN orders as o on c.customer_id = o.customer_id
GROUP BY customer_name
ORDER BY count(order_id) desc;

-- 20. Add up the price of all products.
SELECT sum(price) as "Price of all products"
FROM products;

-- 21. Select orderID together with the total price of that Order, order the result by total price of order in increasing order.
SELECT order_id, sum(price) as "Total price"
FROM order_details as o
JOIN products as p on o.product_id = p.product_id
GROUP BY order_id
ORDER BY sum(price) ASC;

-- 22 Select customer who spend the most money.
SELECT customer_name, sum(price * quantity) as " Total spent"
FROM products as p
JOIN order_details as OD on p.product_id = OD.product_id
JOIN customer as c on c.customer_id = OD.orderdetails_id
GROUP BY customer_name
ORDER BY sum(price * quantity) desc
limit 1;

-- 23. Select customer who spend the most money and lives in Canada
SELECT customer_name, sum(price * quantity) AS "Total spent"
FROM products as p
JOIN order_details as OD on p.product_id = OD.product_id
JOIN customer as c on c.customer_id = OD.orderdetails_id
WHERE trim(country) = 'Canada'
GROUP BY customer_name
ORDER BY sum(price * quantity) desc
LIMIT 1;

-- 24. Select customer who spend the second most money.
SELECT customer_name, sum(price * quantity) as " Total spent"
FROM products as p
JOIN order_details as OD on p.product_id = OD.product_id
JOIN customer as c on c.customer_id = OD.orderdetails_id
GROUP BY customer_name
ORDER BY sum(price * quantity) desc
limit 1, 1;

-- 25. Select shipper together with the total price of proceed orders
SELECT shipper_name, sum(price) AS "Total_processed_price"
FROM products as p
JOIN order_details as o on p.product_id = o.product_id
JOIN shippers as s on o.orderdetails_id = s.shipper_id
JOIN orders as d on s.shipper_id = d.shipper_id
WHERE order_date <= current_date()
GROUP BY shipper_name;