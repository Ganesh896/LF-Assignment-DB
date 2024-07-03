CREATE table Products(product_id int primary key, product_name varchar(50), category varchar(50), price int);

CREATE table Orders(order_id int primary key, customer_name varchar(50), product_id int, quantity int, order_date date);

INSERT INTO Products (product_id, product_name, category, price)
VALUES 
(1, 'Laptop', 'Electronics', 1000),
(2, 'Smartphone', 'Electronics', 500),
(3, 'Table', 'Furniture', 150),
(4, 'Chair', 'Furniture', 75),
(5, 'Book', 'Books', 20);

update products
	set product_name='Mobile'
	where product_id=2;

delete from products
	where product_name='Chair';

select * from products;

INSERT INTO Orders (order_id, customer_name, product_id, quantity, order_date)
VALUES 
(1, 'John Doe', 1, 2, '2024-07-01'),
(2, 'Jane Smith', 3, 1, '2024-07-01'),
(3, 'Alice Johnson', 2, 3, '2024-07-02'),
(4, 'Bob Brown', 5, 5, '2024-07-02'),
(5, 'Charlie Black', 4, 4, '2024-07-03');

update orders
	set customer_name = 'Ganesh Saud'
	where order_id=5;

delete from orders
	where product_id=4;

select * from orders;

--Calculate the total quantity ordered for each product category in the orders table.
select category, sum(quantity) as quantity
from products p join orders o on p.product_id=o.product_id
group by category;

--Find categories where the total number of products ordered is greater than 5.
select category from (
select category, sum(quantity) as quantity
from products p join orders o on p.product_id=o.product_id
group by category)
	where quantity>5;

SELECT category
FROM Orders o JOIN Products p ON o.product_id = p.product_id
GROUP BY category
HAVING SUM(quantity) > 4;

	