/*
    1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users,
       catalogs и products в таблицу logs помещается время и дата создания записи, название
       таблицы, идентификатор первичного ключа и содержимое поля name.
*/
USE shop;

DROP TABLE IF EXISTS `logs`;
CREATE TABLE `logs` (
    created_at DATETIME NOT NULL DEFAULT NOW(),
    table_name VARCHAR(255) NOT NULL,
    primary_key BIGINT UNSIGNED NOT NULL,
    name VARCHAR(255)
) ENGINE=Archive;

DELIMITER //

DROP TRIGGER IF EXISTS logs_users//
CREATE TRIGGER logs_users AFTER INSERT ON users
FOR EACH ROW
    BEGIN
        INSERT INTO `logs`
        VALUES (DEFAULT, 'users', NEW.id, NEW.name);
    END //

DROP TRIGGER IF EXISTS logs_catalogs//
CREATE TRIGGER logs_catalogs AFTER INSERT ON catalogs
FOR EACH ROW
    BEGIN
        INSERT INTO `logs`
        VALUES (DEFAULT, 'catalogs', NEW.id, NEW.name);
    END //

DROP TRIGGER IF EXISTS logs_products//
CREATE TRIGGER logs_products AFTER INSERT ON products
FOR EACH ROW
    BEGIN
        INSERT INTO `logs`
        VALUES (DEFAULT, 'products', NEW.id, NEW.name);
    END //

DELIMITER ;

INSERT INTO users
VALUES (DEFAULT, 'Test', '1985-11-22', NOW(), NOW());

INSERT INTO catalogs
VALUES (DEFAULT, 'Test');

INSERT INTO products
VALUES (DEFAULT, 'Test product', 'Test description2.', 42.42, 1, DEFAULT, DEFAULT);