CREATE DATABASE north;
-- SQL-команды для создания таблиц

CREATE TABLE customers_data
(
    customer_id varchar(5) UNIQUE PRIMARY KEY,
    company_name varchar(50) NOT NULL,
    contact_name varchar(50) NOT NULL
);

CREATE TABLE employees_data
(
    employee_id int UNIQUE PRIMARY KEY,
	first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
	title varchar(50) NOT NULL,
	birth_date date NOT NULL,
	notes text NOT NULL
);

CREATE TABLE orders_data
(
	order_id int UNIQUE PRIMARY KEY,
	customer_id varchar(5) REFERENCES customers_data(customer_id),
	employee_id int REFERENCES employees_data(employee_id),
	order_date date NOT NULL,
	ship_city varchar(50) NOT NULL
);