/*
    1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
*/
SELECT *
FROM users
JOIN orders on users.id = orders.user_id;


/*
    2. Выведите список товаров products и разделов catalogs, который соответствует товару.
*/
SELECT *
FROM products
JOIN catalogs on catalogs.id = products.catalog_id;


/*
    3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label,
       name). Поля from, to и label содержат английские названия городов, поле name — русское.
       Выведите список рейсов flights с русскими названиями городов.
*/
# Создание и заполнение таблиц flights и cities
DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
    id     SERIAL,
    `from` VARCHAR(50),
    `to`   VARCHAR(50)
);

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
    label VARCHAR(50),
    name  VARCHAR(50)
);

INSERT INTO flights
VALUES (DEFAULT, 'moscow', 'omsk'),
       (DEFAULT, 'novgorod', 'kazan'),
       (DEFAULT, 'irkutsk', 'moscow'),
       (DEFAULT, 'omsk', 'irkutsk'),
       (DEFAULT, 'moscow', 'kazan');

INSERT INTO cities
VALUES ('moscow', 'Москва'),
       ('irkutsk', 'Иркутск'),
       ('novgorod', 'Новгород'),
       ('kazan', 'Казань'),
       ('omsk', 'Омск');

# Решение
SELECT id,
    from_label.name AS 'from_RU',
    to_label.name   AS 'to_RU'
FROM flights
    JOIN cities from_label ON flights.`from` = from_label.label
    JOIN cities to_label ON flights.`to` = to_label.label
ORDER BY id;