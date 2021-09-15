/* Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение” */

/*
    1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их
       текущими датой и временем.
*/
UPDATE users
SET created_at = NOW(),
    updated_at = NOW()
WHERE created_at IS NULL
  AND updated_at IS NULL;


/*
    2. Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы
       типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10".
       Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.
*/
UPDATE users
SET created_at = CONCAT(SUBSTR(created_at, 7, 4), '-', SUBSTR(created_at, 4, 2), '-', SUBSTR(created_at, 1, 2),
                        SUBSTR(created_at, 11), ':00'),
    updated_at = CONCAT(SUBSTR(updated_at, 7, 4), '-', SUBSTR(updated_at, 4, 2), '-', SUBSTR(updated_at, 1, 2),
                        SUBSTR(updated_at, 11), ':00');

ALTER TABLE users MODIFY COLUMN created_at DATETIME;
ALTER TABLE users MODIFY COLUMN updated_at DATETIME;


/*
    3. В таблице складских запасов storehouses_products в поле value могут встречаться самые
       разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы.
       Необходимо отсортировать записи таким образом, чтобы они выводились в порядке
       увеличения значения value. Однако, нулевые запасы должны выводиться в конце, после всех
       записей.
*/
SELECT value FROM storehouses_products ORDER BY value = 0, value;


/*
    4. (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе
       и мае. Месяцы заданы в виде списка английских названий ('may', 'august')
*/
SELECT * FROM users WHERE birthday_at IN ('may', 'august');


/*
    5. (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса.
       SELECT * FROM catalogs WHERE id IN (5, 1, 2);
       Отсортируйте записи в порядке, заданном в списке IN.
*/
SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY FIELD(id, 5, 1, 2);


/* Практическое задание теме “Агрегация данных” */

/*
    1. Подсчитайте средний возраст пользователей в таблице users
*/

SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW()))) AS averageage_of_users FROM users;

/*
    2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.
       Следует учесть, что необходимы дни недели текущего года, а не года рождения.
*/
SELECT
    DAYNAME(CONCAT(YEAR(NOW()), SUBSTR(birthday_at, 5))) AS days_of_the_week,
    count(birthday_at) AS count_of_birthdays,
    GROUP_CONCAT(name) AS names
FROM users
GROUP BY days_of_the_week;