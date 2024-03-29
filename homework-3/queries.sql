-- Напишите запросы, которые выводят следующую информацию:
-- 1. Название компании заказчика (company_name из табл. customers) и ФИО сотрудника, работающего над заказом этой компании (см таблицу employees),
-- когда и заказчик и сотрудник зарегистрированы в городе London, а доставку заказа ведет компания United Package (company_name в табл shippers)
SELECT customers.company_name, CONCAT(first_name, ' ', last_name) FROM customers, employees, orders, shippers
	WHERE customers.customer_id = orders.customer_id AND  employees.employee_id = orders.employee_id
	AND shippers.shipper_id = ship_via AND shippers.company_name = 'United Package'
	AND customers.city = 'London' AND employees.city = 'London';

-- 2. Наименование продукта, количество товара (product_name и units_in_stock в табл products),
-- имя поставщика и его телефон (contact_name и phone в табл suppliers) для таких продуктов,
-- которые не сняты с продажи (поле discontinued) и которых меньше 25 и которые в категориях Dairy Products и Condiments.
-- Отсортировать результат по возрастанию количества оставшегося товара.
SELECT products.product_name, products.units_in_stock, suppliers.contact_name, suppliers.phone FROM products, suppliers, categories
	WHERE products.supplier_id = suppliers.supplier_id
	AND  products.discontinued <> 1 AND products.units_in_stock < 25
	AND products.category_id = categories.category_id
	AND category_name IN ('Dairy Products','Condiments')
	ORDER BY products.units_in_stock;

-- 3. Список компаний заказчиков (company_name из табл customers), не сделавших ни одного заказа
SELECT customers.company_name FROM customers
EXCEPT
SELECT customers.company_name FROM customers, orders
WHERE customers.customer_id = orders.customer_id;

-- 4. уникальные названия продуктов, которых заказано ровно 10 единиц (количество заказанных единиц см в колонке quantity табл order_details)
-- Этот запрос написать именно с использованием подзапроса.

-- Способов может быть много, имена продуктов выводят те же, но в в разном порядке)--
-- Раз --
SELECT DISTINCT product_name FROM products, orders, (SELECT * FROM order_details WHERE quantity = 10) AS details
	WHERE products.product_id = details.product_id
	AND orders.order_id = details.order_id;
-- Два --
SELECT DISTINCT product_name FROM products,
	(SELECT * FROM orders, order_details WHERE orders.order_id = order_details.order_id AND order_details.quantity = 10) AS order_guantity_10
	WHERE products.product_id = order_guantity_10.product_id;
-- Три --
SELECT order_deatails_products.product_name FROM
(SELECT DISTINCT products.product_name, order_details.quantity FROM order_details, orders, products
	WHERE products.product_id = order_details.product_id
	AND orders.order_id = order_details.order_id) AS order_deatails_products
	WHERE order_deatails_products.quantity = 10;
-- Четыре --
SELECT DISTINCT product_name FROM products,
	(SELECT * FROM orders, order_details WHERE orders.order_id = order_details.order_id AND order_details.quantity = 10) AS order_guantity_10
	WHERE products.product_id = order_guantity_10.product_id;
-- Пять --
SELECT DISTINCT product_name FROM orders,
(SELECT * FROM products, order_details WHERE order_details.product_id = products.product_id AND order_details.quantity = 10) AS order_products_10
WHERE orders.order_id = order_products_10.order_id;
