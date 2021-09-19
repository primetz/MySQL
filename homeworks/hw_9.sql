/*########## Транзакции, переменные, представления ##########*/
/*
    1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных.
       Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.
*/
START TRANSACTION;
    INSERT INTO sample.users
    SELECT * FROM shop.users
    WHERE id = 1;

    DELETE FROM shop.users
    WHERE id = 1;
COMMIT;

/*
    2. Создайте представление, которое выводит название name товарной позиции из таблицы products
       и соответствующее название каталога name из таблицы catalogs.
*/
CREATE OR REPLACE VIEW prod_cat AS
SELECT
    products.name AS product_name,
    c.name AS catalog_name
FROM products
LEFT JOIN catalogs c on c.id = products.catalog_id;

SELECT * FROM prod_cat;

/*
    3. (по желанию) Пусть имеется таблица с календарным полем created_at. В ней размещены
       разряженные календарные записи за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и
       2018-08-17. Составьте запрос, который выводит полный список дат за август, выставляя в
       соседнем поле значение 1, если дата присутствует в исходном таблице и 0, если она отсутствует.
*/
# Создание и заполнение таблицы с датами
DROP TABLE IF EXISTS dates;
CREATE TABLE dates (
    created_at DATE
);

INSERT INTO dates
VALUES ('2018-08-01'),
       ('2018-08-04'),
       ('2018-08-16'),
       ('2018-08-17');

# Решение
SELECT @first_number := DATE_FORMAT(created_at, '%Y-%m-01') FROM dates LIMIT 1;
WITH RECURSIVE month (aug) AS (
    SELECT @first_number
    UNION ALL
    SELECT DATE_ADD(aug, INTERVAL 1 DAY)
    FROM month
    WHERE aug < LAST_DAY(@first_number)
)
SELECT
    aug,
    (SELECT EXISTS(SELECT created_at FROM dates WHERE created_at = month.aug)) AS coincidences
FROM month;

/*
    4. (по желанию) Пусть имеется любая таблица с календарным полем created_at. Создайте
       запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.
*/
# Добавление новых записей в таблицу dates
INSERT INTO dates
VALUES ('2018-08-02'),
       ('2018-08-03'),
       ('2018-08-05'),
       ('2018-08-07'),
       ('2018-08-09'),
       ('2018-08-11'),
       ('2018-08-13'),
       ('2018-08-22');

# Решение
CREATE OR REPLACE VIEW recent_entries
AS SELECT created_at FROM dates ORDER BY created_at DESC LIMIT 5;

DELETE FROM dates WHERE created_at NOT IN (SELECT * FROM recent_entries);

SELECT * FROM dates;


/*########## Администрирование MySQL ##########*/
/*
    1. Создайте двух пользователей которые имеют доступ к базе данных shop. Первому
       пользователю shop_read должны быть доступны только запросы на чтение данных, второму
       пользователю shop — любые операции в пределах базы данных shop.
*/
DROP USER IF EXISTS 'shop_read'@'localhost';
CREATE USER 'shop_read'@'localhost' IDENTIFIED WITH sha256_password BY '12345';
GRANT SELECT ON shop.* TO 'shop_read'@'localhost';

DROP USER IF EXISTS 'shop'@'localhost';
CREATE USER 'shop'@'localhost' IDENTIFIED WITH sha256_password BY '54321';
GRANT ALL ON shop.* TO 'shop'@'localhost';

SELECT Host, User FROM mysql.user;

/*
    2. (по желанию) Пусть имеется таблица accounts содержащая три столбца id, name, password,
       содержащие первичный ключ, имя пользователя и его пароль. Создайте представление
       username таблицы accounts, предоставляющий доступ к столбца id и name. Создайте
       пользователя user_read, который бы не имел доступа к таблице accounts, однако, мог бы
       извлекать записи из представления username.
*/
CREATE OR REPLACE VIEW username AS
SELECT
    id,
    name
FROM accounts;

DROP USER IF EXISTS user_read;
CREATE USER user_read IDENTIFIED WITH sha256_password BY '12345';
GRANT SELECT ON shop.username TO user_read;


/*########## Хранимые процедуры и функции, триггеры ##########*/
/*
    1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от
       текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с
       12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер",
       с 00:00 до 6:00 — "Доброй ночи".
*/
DROP FUNCTION IF EXISTS hello;
CREATE FUNCTION hello ()
    RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
    DECLARE str VARCHAR(255);
    CASE
        WHEN CURRENT_TIME BETWEEN '06:00:00' AND '11:59:59'
            THEN SET str = 'Доброе утро';
        WHEN CURRENT_TIME BETWEEN '12:00:00' AND '17:59:59'
            THEN SET str = 'Добрый день';
        WHEN CURRENT_TIME BETWEEN '18:00:00' AND '23:59:59'
            THEN SET str = 'Добрый вечер';
        WHEN CURRENT_TIME BETWEEN '00:00:00' AND '05:59:59'
            THEN SET str = 'Доброй ночи';
        ELSE SET str = 'Привет';
        END CASE;
    RETURN str;
END;

SELECT hello();

/*
    2. В таблице products есть два текстовых поля: name с названием товара и description с его
       описанием. Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля
       принимают неопределенное значение NULL неприемлема. Используя триггеры, добейтесь
       того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям
       NULL-значение необходимо отменить операцию.
*/
DROP TRIGGER IF EXISTS insert_to_products;
CREATE TRIGGER insert_to_products BEFORE INSERT ON products
    FOR EACH ROW
BEGIN
    IF ISNULL(NEW.name) OR ISNULL(NEW.description) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Поля name и description не должны оставаться пустыми';
    END IF;
END;

INSERT INTO products
VALUES (DEFAULT, NULL, 'Desc', 52.52, 11, DEFAULT, NULL);

/*
    3. (по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи.
       Числами Фибоначчи называется последовательность в которой число равно сумме двух
       предыдущих чисел. Вызов функции FIBONACCI(10) должен возвращать число 55.
*/
DROP FUNCTION IF EXISTS FIBONACCI;
CREATE FUNCTION FIBONACCI(n INT)
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE fib, tmp INT DEFAULT 0;
    DECLARE next_fib INT DEFAULT 1;

    IF n <= 1 THEN
        RETURN n;
    ELSE
        WHILE n > 1 DO
            SET tmp = next_fib;
            SET next_fib = fib + next_fib;
            SET fib = tmp;
            SET n = n - 1;
        END WHILE;
    END IF;

    RETURN next_fib;
END;

SELECT FIBONACCI(10);