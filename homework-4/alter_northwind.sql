-- Подключиться к БД Northwind и сделать следующие изменения:
-- 1. Добавить ограничение на поле unit_price таблицы products (цена должна быть больше 0)
ALTER TABLE products ADD CONSTRAINT chk_products_unit_price CHECK (unit_price > 0);

-- 2. Добавить ограничение, что поле discontinued таблицы products может содержать только значения 0 или 1
ALTER TABLE products ADD CONSTRAINT chk_products_discontinued CHECK (discontinued IN (0, 1));

-- 3. Создать новую таблицу, содержащую все продукты, снятые с продажи (discontinued = 1)
SELECT * INTO products_discontinued FROM products WHERE discontinued = 1;

-- 4. Удалить из products товары, снятые с продажи (discontinued = 1)
-- Для 4-го пункта может потребоваться удаление ограничения, связанного с foreign_key. Подумайте, как это можно решить, чтобы связь с таблицей order_details все же осталась.

DELETE FROM products WHERE discontinued = 1; -- даст ошибку, т.к. ограничение, связанное с foreign_key

-- удаление ограничения, связанного с foreign_key

-- Если просто удалить ограничение внешнего ключа
-- ALTER TABLE order_details DROP CONSTRAINT fk_order_details_products;
-- то связь нарушится, и обратно после удаления строк из products сделать это ограничение не получится:
-- ALTER TABLE order_details ADD CONSTRAINT fk_order_details_products FOREIGN KEY(product_id) REFERENCES products (product_id); -- даст ошибку

-- ВАРИАНТ РЕШЕНИЯ - перенести в другую таблицу всё все неподходящие значения и потом удалить их из order_details
-- они выводятся по запросу
-- SELECT * FROM order_details JOIN products USING(product_id) WHERE products.discontinued = 1 ORDER BY product_id;

-- 1. перенос:
SELECT * INTO order_details_discontinued FROM order_details WHERE product_id IN(SELECT product_id FROM products WHERE discontinued = 1);
-- 2. определяем первичный ключ в products_discontinued
ALTER TABLE products_discontinued ADD CONSTRAINT pk_products_discontinued_product_id PRIMARY KEY(product_id);
-- 3. определяем внешние ключи в order_details_discontinued
ALTER TABLE order_details_discontinued ADD CONSTRAINT fk_order_details_discontinued_order_id FOREIGN KEY(order_id) REFERENCES orders(order_id);
ALTER TABLE order_details_discontinued ADD CONSTRAINT fk_order_details_discontinued_products_discontinued FOREIGN KEY(product_id) REFERENCES products_discontinued(product_id);
-- 4. что получилось:
-- SELECT * FROM order_details_discontinued JOIN products_discontinued USING(product_id);
-- 5. удаляем товары, снятые с продажи из order_details, они остаются в order_details_discontinued
DELETE FROM order_details WHERE product_id IN(SELECT product_id FROM products_discontinued WHERE discontinued = 1);
-- 6. Можно спокойно удалить из products товары, снятые с продажи (discontinued = 1)
DELETE FROM products WHERE discontinued = 1;