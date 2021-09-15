/*########## Транзакции ##########*/
START TRANSACTION; # Начало транзакции

SELECT total
FROM accounts
WHERE user_id = 4;

UPDATE accounts
SET total = total - 2000
WHERE user_id = 4;

UPDATE accounts
SET total = total + 2000
WHERE user_id IS NULL;

COMMIT; # Завершение транзакции и сохранение результатов в БД

ROLLBACK; # Завершение транзакции и откат к начальному состоянию (до начала транзакции)


/*========== Точки сохранения ==========*/
START TRANSACTION;

SELECT total
FROM accounts
WHERE user_id = 4;

SAVEPOINT accounts_4; # Точка сохранения

UPDATE accounts
SET total = total - 2000
WHERE user_id = 4;

ROLLBACK TO SAVEPOINT accounts_4; # Завершение транзакции и откат к точке сохранения (accounts_4)


/*========== Выключение и выключение режима автозавершения транзакций ==========*/
SET AUTOCOMMIT = 0; # Выключить режим автозавершения транзакций (в этом случае любая последовательность команд будет рассматриваться как транзакция)

SELECT total
FROM accounts
WHERE user_id = 4;

UPDATE accounts
SET total = total - 2000
WHERE user_id = 4;

UPDATE accounts
SET total = total + 2000
WHERE user_id IS NULL;

ROLLBACK; # Чтобы сохранить изменения, нужно выполнить команду COMMIT или отменить команды при помощи ROLLBACK

SET AUTOCOMMIT = 1; # Выключить режим автоматического завершения транзакций


/*========== Журнал транзакций ==========*/
SHOW VARIABLES LIKE 'innodb_log_%'; # Запросить параметры журнала транзакций

SHOW VARIABLES LIKE 'datadir'; # Получить путь к каталогу данных (файлы журнала транзакций - ib_logfile0 и ib_logfile1)



/*########## Переменные ##########*/
SELECT @total := COUNT(*) FROM products; # Сохранение данных в переменную
SELECT @total;                           # Переменная будет доступна только в текущей сессии

SELECT @price := MAX(price) FROM products;   # Переменные можно использовать не только в SELECT-списке,
SELECT * FROM products WHERE price = @price; # но и в WHERE-условии

SELECT @id := id FROM products; # Если в качестве значения переменной передается имя столбца, содержащего множество значений,
SELECT @id;                     # то переменная получит последнее значение

SELECT @id := 5, @ID := 3; # Имена переменных
SELECT @id, @ID;           # нечувствительны к регистру

SET @last = NOW() - INTERVAL 7 DAY; # Переменные также могут объявляться при помощи оператора SET
SELECT CURDATE(), @last;            # Команда SET, в отличие от оператора SELECT, не возвращает результирующую таблицу


/*
    Переменные можно использовать для нумерации записей в таблице.
    Допустим, есть таблица tbl с единственным столбцом value, без первичного ключа.
    И пусть требуется при выводе содержимого таблицы tbl пронумеровать строки.
*/
DROP TABLE IF EXISTS tbl;
CREATE TABLE tbl (
    value VARCHAR(255)
);

INSERT INTO tbl
VALUES ('first'),
       ('second'),
       ('third'),
       ('fourth'),
       ('fifth');

SET @start := 0;                                   # Мы можем завести переменную @start
SELECT @start := @start + 1 AS id, value FROM tbl; # И увеличивать значение на единицу по мере вывода записей

SHOW VARIABLES;                         # Показать полный список системных переменных
SHOW VARIABLES LIKE 'read_buffer_size'; # Показать определенную системную переменную

SET GLOBAL read_buffer_size = 2097152;   # Изменение значения глобальной переменной
SET @@global.read_buffer_size = 2097152; # Вместо ключевого слова GLOBAL можно перед названием переменной указывать два символа алеф, после которых указывает префикс global

SET SESSION read_buffer_size = 2097152;   # Изменение значения сеансовой переменной
SET @@session.read_buffer_size = 2097152; # Вместо ключевого слова GLOBAL можно перед названием переменной указывать два символа алеф, после которых указывает префикс session

SET read_buffer_size = DEFAULT; # Чтобы установить локальной переменной значение глобальной, достаточно присвоить локальной переменной ключевое слово DEFAULT.



/*########## Временная таблица ##########*/
CREATE TEMPORARY TABLE temp (id INT, name VARCHAR(255)); # Создание временной таблицы
SHOW TABLES;                                             # В списке всех таблиц нет временной таблицы
DESCRIBE temp;                                           # Так как она создается в оперативной памяти



/*########## Динамические запросы ##########*/
PREPARE ver FROM 'SELECT VERSION()'; # Объявление динамического запроса
EXECUTE ver;                         # Выполнение динамического запроса

PREPARE prd FROM 'SELECT id, name, price FROM products WHERE catalog_id = ?'; # Объявление динамического запроса принимающего параметры
SET @catalog_id = 1;
EXECUTE prd USING @catalog_id; # Передача параметров при вызове динамического запроса (если параметров больше чем 1, то они перечисляются через запятую)

DROP PREPARE prd; # Удаление динамического запроса



/*########## Представления ##########*/
CREATE VIEW cat AS SELECT * FROM catalogs ORDER BY name; # Создание представления
SELECT * FROM cat;                                       # К представлению можно обращаться как к обычной таблице

SHOW TABLES; # Представление рассматривается MySQL как полноценная таблица

CREATE VIEW cat_reverse (catalog, catalog_id) # Можно изменить название столбцов
AS SELECT name, id FROM catalogs;             # и порядок их следования
SELECT * FROM cat_reverse;

CREATE OR REPLACE VIEW namecat (id, name, total) # Создать или изменить существующее представление
AS SELECT id, name, LENGTH(name) FROM catalogs;  # В качестве столбцов представления могут выступать вычисляемые столбцы
SELECT * FROM namecat ORDER BY total DESC;

/*
    Ключевое слово ALGORITHM определяет способ формирования конечного запроса
    с участием представления и может принимать три значения:

        MERGE — при использовании данного алгоритма запрос объединяется с представлением таким образом,
        что представление заменяет собой соответствующие части в запросе;

        TEMPTABLE — результирующая таблица представления помещается во временную,
        которая затем используется в конечном запросе;

        UNDEFINED — в данном случае СУБД MySQL самостоятельно пытается выбрать алгоритм,
        предпочитая использовать подход MERGE и прибегая к алгоритму TEMPTABLE (создание временной таблицы)
        только в случае необходимости, т. к. метод MERGE более эффективен.

    Если ни одно из значений ALGORITHM не указано, по умолчанию назначается UNDEFINED.
*/
CREATE ALGORITHM = TEMPTABLE VIEW cat2 AS SELECT * FROM catalogs;

/*
    Следует отметить, что представления способны скрывать ряд столбцов за счёт того,
    что SELECT-запросы могут извлекать не все столбцы таблицы.
    Такие представления называются вертикальными представлениями.
*/
CREATE OR REPLACE VIEW prod
AS SELECT id, name, price, catalog_id
FROM products
ORDER BY catalog_id, name;
SELECT * FROM prod;

SELECT * FROM prod ORDER BY name DESC; # Запросы к представлениям сами могут содержать условия WHERE и собственные сортировки.

/*
    Наряду с вертикальными используются горизонтальные представления,
    которые ограничивают доступ пользователей к строкам таблиц, делая видимыми только те строки,
    с которыми они работают
*/
CREATE OR REPLACE VIEW processors
AS SELECT id, name, price, catalog_id
FROM products
WHERE catalog_id = 1;
SELECT * FROM processors;

/*
    Чтобы в представление можно было вставлять новые записи при помощи команды INSERT и обновлять существующие записи
    при помощи команды UPDATE, необходимо при создании представления использовать конструкцию WITH CHECK OPTION.

    Во время вставки происходит проверка, чтобы вставляемые данные удовлетворяли WHERE-условию SELECT-запроса,
    лежащего в основе представления.
*/
CREATE VIEW v1
AS SELECT * FROM tbl
WHERE value < 'fst5'
WITH CHECK OPTION;

INSERT INTO v1 VALUES ('fst4'); # Значение успешно вставится
INSERT INTO v1 VALUES ('fst5'); # Срабатывает ограничение WHERE-условия

ALTER VIEW v1           # Редактирование представления или можно CREATE OR REPLACE VIEW
AS SELECT * FROM tbl
WHERE value > 'fst4'
WITH CHECK OPTION;

DROP VIEW cat, cat_reverse, namecat, prod, processors, v1; # Удаление представлений
DROP VIEW IF EXISTS cat, cat_reverse, namecat, prod, processors, v1; # Чтоб не возникало ошибок при попытке удаления несуществующих представлений
