CREATE TABLE student
(
    student_id serial UNIQUE PRIMARY KEY,
	first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
	birthday date NOT NULL,
	phone varchar(50) NOT NULL
);

-- 2. Добавить в таблицу student колонку middle_name varchar
ALTER TABLE student ADD COLUMN middle_name varchar(50);

-- 3. Удалить колонку middle_name
ALTER TABLE student DROP COLUMN middle_name;

-- 4. Переименовать колонку birthday в birth_date
ALTER TABLE student RENAME COLUMN birthday TO birth_date;

-- 5. Изменить тип данных колонки phone на varchar(32)
ALTER TABLE student 
	ALTER COLUMN phone SET DATA TYPE varchar(32);


-- 6. Вставить три любых записи с автогенерацией идентификатора
INSERT INTO student (first_name, last_name, birth_date, phone) VALUES
    ('Иванов', 'Иван', '01.04.1989', '8-999-876-54-32');
INSERT INTO student (first_name, last_name, birth_date, phone) VALUES
    ('Петров', 'Петр', '11.05.1995', '8-988-876-54-31');
INSERT INTO student (first_name, last_name, birth_date, phone) VALUES
    ('Сидорова', 'Ксения', '21.05.1995', '8-987-876-54-31');

INSERT INTO student (first_name, last_name, birth_date, phone) VALUES
    ('Иванов', 'Петр', '01.04.1996', '8-999-876-54-32'),
    ('Петров', 'Иван', '11.05.1994', '8-988-876-54-31'),
    ('Сидорова', 'Евгения', '21.05.1994', '8-987-876-54-31');

INSERT INTO student (student_id, first_name, last_name, birth_date, phone) VALUES
	(DEFAULT, 'Жанна', 'Агузарова', '21.05.1980', '8-999-888-55-44');

DELETE FROM student WHERE student_id > 10;
ALTER SEQUENCE student_student_id_seq RESTART WITH 1;

SELECT SETVAL((pg_get_serial_sequence('student', 'student_id')), (SELECT MAX(student_id) FROM student) );

SELECT pg_get_serial_sequence('student', 'student_id');

ALTER TABLE student AUTO_INCREMENT = 1;

В отличии от MySQL где TRUNCATE TABLE автоматически сбрасывает авто инкремент, в PostgreSQL нужно добавить ключ RESTART IDENTITY
TRUNCATE TABLE tbl RESTART IDENTITY;

select * FROM student

Для сброса автоинкрементного счетчика в PostgreSQL воспользуйтесь следующей командой:

ALTER SEQUENCE student_student_id_seq RESTART WITH 1
	
Для синхронизации значений последовательности с максимальным существующим ID в таблице используйте следующую команду:

SQL
Скопировать код
SELECT SETVAL('sequence_name', (SELECT MAX(column_name) FROM table_name));


-- Подключиться к БД Northwind и сделать следующие изменения:
-- 1. Добавить ограничение на поле unit_price таблицы products (цена должна быть больше 0)
select * from products
-- Изменение типа данных в таблице courses для колонки created_at
-- и снятие ограничения NOT NULL в таблице courses для колонки name
ALTER TABLE products
    ALTER COLUMN unit_price SET NOT NULL;
-- 2. Добавить ограничение, что поле discontinued таблицы products может содержать только значения 0 или 1


-- 3. Создать новую таблицу, содержащую все продукты, снятые с продажи (discontinued = 1)


-- 4. Удалить из products товары, снятые с продажи (discontinued = 1)
-- Для 4-го пункта может потребоваться удаление ограничения, связанного с foreign_key. Подумайте, как это можно решить, чтобы связь с таблицей order_details все же осталась.



====================

DAY 2

CREATE TABLE student
(
    student_id serial UNIQUE PRIMARY KEY,
	first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
	birthday date NOT NULL,
	phone varchar(50) NOT NULL
);

--CREATE TABLE student2
--(
--    student_id serial,
--	first_name varchar(50) NOT NULL,
--    last_name varchar(50) NOT NULL,
--	birthday date NOT NULL,
--	phone varchar(50) NOT NULL,
	
--	CONSTRAINT pk_student2_student_id PRIMARY KEY (student_id)
--);

CREATE TABLE department
(
	department_id serial,
	department_name varchar,

	CONSTRAINT pk_department_department_id PRIMARY KEY (department_id)
);
CREATE TABLE employees
(
	employee_id serial,
	first_name varchar(50),
	department_id int,

	CONSTRAINT pk_employees_employee_id PRIMARY KEY (employee_id)
);
ALTER TABLE employees ADD CONSTRAINT fk_employees_department FOREIGN KEY(department_id) REFERENCES department(department_id);

ALTER TABLE employees DROP CONSTRAINT fk_employees_department;

CREATE TABLE products
(
	product_id serial,
	product_name varchar NOT NULL,
	discontinued int DEFAULT 0,
	unit_price decimal DEFAULT 0,

	CONSTRAINT pk_products_product_id PRIMARY KEY(product_id)
);

ALTER TABLE products ALTER COLUMN discontinued SET DEFAULT 0;

CREATE TABLE products
(
	product_id serial,
	product_name varchar NOT NULL,
	discontinued int DEFAULT 0,
	unit_price decimal,

	CONSTRAINT pk_products_product_id PRIMARY KEY(product_id),
	CONSTRAINT chk_products_discontinued CHECK (discontinued IN (0, 1)),
	CONSTRAINT chk_products_unit_price CHECK (unit_price >= 0)
);
--Оператор SELECT INTO  позволяет выбрать данные из одной таблицы и записать их в новую таблицу.
SELECT * INTO top_products FROM products WHERE unit_price > 10;
--Оператор INSERT INTO SELECT позволяет выбрать данные из одной таблицы и вставить их в другую таблицу.
INSERT INTO top_products SELECT * FROM products WHERE unit_price <= 10;




-- 2. Добавить в таблицу student колонку middle_name varchar
ALTER TABLE student ADD COLUMN middle_name varchar(50);

-- 3. Удалить колонку middle_name
ALTER TABLE student DROP COLUMN middle_name;

-- 4. Переименовать колонку birthday в birth_date
ALTER TABLE student RENAME COLUMN birthday TO birth_date;

-- 5. Изменить тип данных колонки phone на varchar(32)
ALTER TABLE student 
	ALTER COLUMN phone SET DATA TYPE varchar(32);


-- 6. Вставить три любых записи с автогенерацией идентификатора
INSERT INTO student (first_name, last_name, birth_date, phone) VALUES
    ('Иванов', 'Иван', '01.04.1989', '8-999-876-54-32');
INSERT INTO student (first_name, last_name, birth_date, phone) VALUES
    ('Петров', 'Петр', '11.05.1995', '8-988-876-54-31');
INSERT INTO student (first_name, last_name, birth_date, phone) VALUES
    ('Сидорова', 'Ксения', '21.05.1995', '8-987-876-54-31');

INSERT INTO student (first_name, last_name, birth_date, phone) VALUES
    ('Иванов', 'Петр', '01.04.1996', '8-999-876-54-32'),
    ('Петров', 'Иван', '11.05.1994', '8-988-876-54-31'),
    ('Сидорова', 'Евгения', '21.05.1994', '8-987-876-54-31');

INSERT INTO student (student_id, first_name, last_name, birth_date, phone) VALUES
	(DEFAULT, 'Жанна', 'Агузарова', '21.05.1980', '8-999-888-55-44');

DELETE FROM student WHERE student_id > 10;
--Для сброса автоинкрементного счетчика в PostgreSQL воспользуйтесь следующей командой:
ALTER SEQUENCE student_student_id_seq RESTART WITH 1;

--В отличии от MySQL где TRUNCATE TABLE автоматически сбрасывает авто инкремент, в PostgreSQL нужно добавить ключ RESTART IDENTITY
TRUNCATE TABLE student RESTART IDENTITY;



select * FROM student;
select * from products;



-- Подключиться к БД Northwind и сделать следующие изменения:
-- 1. Добавить ограничение на поле unit_price таблицы products (цена должна быть больше 0)
ALTER TABLE products ADD CONSTRAINT chk_products_unit_price CHECK (unit_price > 0);

-- 2. Добавить ограничение, что поле discontinued таблицы products может содержать только значения 0 или 1
ALTER TABLE products ADD CONSTRAINT chk_products_discontinued CHECK (discontinued IN (0, 1));

-- 3. Создать новую таблицу, содержащую все продукты, снятые с продажи (discontinued = 1)
--Оператор SELECT INTO  позволяет выбрать данные из одной таблицы и записать их в новую таблицу.
SELECT * INTO products_discontinued FROM products WHERE discontinued = 1;

-- 4. Удалить из products товары, снятые с продажи (discontinued = 1)
-- Для 4-го пункта может потребоваться удаление ограничения, связанного с foreign_key. Подумайте, как это можно решить, чтобы связь с таблицей order_details все же осталась.

-- Ребус, блин. Как это можно решить?

-- ВАРИАНТ 1 - перенести в другую таблицу всё все неподходящие значения
-- они выводятся по запросу
-- SELECT * FROM order_details JOIN products USING(product_id) WHERE products.discontinued = 1 ORDER BY product_id;
-- перенос: 
-- SELECT * INTO order_details_discontinued FROM order_details WHERE product_id IN(SELECT product_id FROM products WHERE discontinued = 1);

select * from order_details_discontinued
select DISTINCT order_id from orders
-- и их 310 штук связать их c product_id c products_discontinued.products_id
ALTER TABLE order_details_discontinued DROP CONSTRAINT fk_order_details_products;

ALTER TABLE order_details_discontinued ADD CONSTRAINT fk_order_details_products_discontinued 
	FOREIGN KEY(product_id) REFERENCES products_discontinued(product_id);


products_discontinued
-- 2 - воткнуть еще один столбец в order_details или содать еще одну промежуточную таблицу (как-то мудрено это слишком)
-- ВАРИАНТ ОТВЕРГНУТ - реализовать теоретически можно, но как потом этой базой пользоваться? 


-- 3 - вряд ли, но мб поддерживается связь одного внешнего ключа с двумя таблицами?

SELECT * FROM products_discontinued
SELECT * FROM order_details JOIN products USING(product_id) WHERE products.discontinued = 1 ORDER BY product_id;
