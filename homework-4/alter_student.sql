-- 1. Создать таблицу student с полями student_id serial, first_name varchar, last_name varchar, birthday date, phone varchar
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
--вариант 1--
INSERT INTO student (first_name, last_name, birth_date, phone) VALUES
    ('Иванов', 'Иван', '01.04.1989', '8-999-876-54-32');
INSERT INTO student (first_name, last_name, birth_date, phone) VALUES
    ('Сидорова', 'Ксения', '21.05.1995', '8-987-876-54-31');
INSERT INTO student (student_id, first_name, last_name, birth_date, phone) VALUES
	(DEFAULT, 'Жанна', 'Агузарова', '21.05.1980', '8-999-888-55-44');

--вариант 2--
INSERT INTO student (first_name, last_name, birth_date, phone) VALUES
    ('Иванов', 'Петр', '01.04.1996', '8-999-876-54-32'),
    ('Петров', 'Иван', '11.05.1994', '8-988-876-54-31'),
    ('Сидорова', 'Евгения', '21.05.1994', '8-987-876-54-31');

-- 7. Удалить все данные из таблицы со сбросом идентификатор в исходное состояние
TRUNCATE TABLE student RESTART IDENTITY;