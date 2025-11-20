--Phase 1: Foundation & Inspection
--1.List all unique pizza categories (DISTINCT).
SELECT DISTINCT category FROM pizza_types;

--2.Display pizza_type_id, name, and ingredients, replacing NULL ingredients with "Missing Data". Show first 5 rows.
SELECT pizza_type_id, name,COALESCE(ingredients,'Missing Data') AS ingredients FROM pizza_types LIMIT 5;

--3.Check for pizzas missing a price (IS NULL).
SELECT * FROM pizzas WHERE price IS NULL;

--Phase 2: Filtering & Exploration
--1.Orders placed on '2015-01-01' (SELECT + WHERE).
SELECT * FROM orders WHERE date='2015-01-01';

--2.List pizzas with price descending.
SELECT * from pizzas ORDER BY price DESC;

--3.Pizzas sold in sizes 'L' or 'XL'.
SELECT p.* FROM pizzas p JOIN order_details od ON p.pizza_id = od.pizza_id WHERE p.size IN ('L', 'XL');

--4.Pizzas priced between $15.00 and $17.00.
SELECT * FROM pizzas WHERE price BETWEEN 15.00 AND 17.00 ORDER BY price;

--5.Pizzas with "Chicken" in the name.
SELECT * FROM pizza_types WHERE name LIKE '%Chicken%';

--6.Orders on '2015-02-15' or placed after 8 PM.
SELECT * from orders WHERE "date" = '2015-02-15' OR EXTRACT(HOUR FROM time) >20 ORDER BY time;

--Phase 3: Sales Performance
--1.Total quantity of pizzas sold (SUM).
SELECT SUM(quantity) AS total_sold FROM order_details;

--2.Average pizza price (AVG).
SELECT ROUND(AVG(price),3) AS avg_price FROM pizzas;

--3.Total order value per order (JOIN, SUM, GROUP BY).
SELECT od.order_id, od.pizza_id, od.quantity, SUM(od.quantity * COALESCE(p.price, 0))
FROM order_details od JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY od.order_id, od.pizza_id, od.quantity
ORDER BY order_id;

--4.Total quantity sold per pizza category (JOIN, GROUP BY).
SELECT pt.category, SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_quantity;

--5.Categories with more than 5,000 pizzas sold (HAVING).
SELECT pt.category, SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category HAVING SUM(od.quantity) > 5000
ORDER BY total_quantity;

--6.Pizzas never ordered (LEFT/RIGHT JOIN).
SELECT p.* FROM pizzas p LEFT JOIN order_details od ON p.pizza_id = od.pizza_id WHERE od.pizza_id IS NULL;

--7.Price differences between different sizes of the same pizza (SELF JOIN).
SELECT p1.pizza_type_id, pt.name, p1.size AS size1, p1.price AS pricel,
p2.size AS size2, p2.price AS price2, ABS (p1.price-p2.price) AS price_difference
FROM pizzas p1 JOIN pizzas p2 ON p1.pizza_type_id = p2.pizza_type_id AND p1.size != p2.size
JOIN pizza_types pt ON p1.pizza_type_id = pt.pizza_type_id
WHERE p1.size < p2.size
ORDER BY price_difference;