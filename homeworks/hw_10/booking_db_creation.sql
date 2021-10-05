DROP DATABASE IF EXISTS booking;
CREATE DATABASE booking;
USE booking;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    firstname VARCHAR(100),
    lastname VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone BIGINT UNSIGNED UNIQUE,
    password_hash VARCHAR(100),
    created_at DATETIME NOT NULL DEFAULT NOW(),
    updated_at DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
    INDEX idx_users_firstname_lastname(firstname, lastname)
) COMMENT 'Пользователи';

DROP TABLE IF EXISTS placement;
CREATE TABLE placement (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    description TEXT,
    created_at DATETIME NOT NULL DEFAULT NOW(),
    updated_at DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW()
) COMMENT 'Компании предоставляющие услуги';

DROP TABLE IF EXISTS rooms;
CREATE TABLE rooms (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    type ENUM('hotel', 'apartments', 'resorts', 'villas', 'chalet'),
    placement_id INT UNSIGNED NOT NULL,
    room_capacity INT UNSIGNED NOT NULL,
    facilities TEXT,
    price DECIMAL (10,2),
    CONSTRAINT fk_room_placement FOREIGN KEY (placement_id) REFERENCES placement(id)
) COMMENT 'Размещения';

DROP TABLE IF EXISTS countries;
CREATE TABLE countries (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    country VARCHAR(100) UNIQUE NOT NULL,
    created_at DATETIME NOT NULL DEFAULT NOW(),
    updated_at DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
    INDEX idx_countries_country(country)
) COMMENT 'Страны';

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    country_id INT UNSIGNED NOT NULL,
    city VARCHAR(100) UNIQUE NOT NULL,
    created_at DATETIME NOT NULL DEFAULT NOW(),
    updated_at DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
    CONSTRAINT fk_city_country FOREIGN KEY (country_id) REFERENCES countries(id)
) COMMENT 'Города';

DROP TABLE IF EXISTS addresses;
CREATE TABLE addresses (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    room_id INT UNSIGNED NOT NULL,
    country_id INT UNSIGNED NOT NULL,
    city_id INT UNSIGNED NOT NULL,
    address VARCHAR(255) NOT NULL,
    phone BIGINT UNSIGNED UNIQUE,
    created_at DATETIME NOT NULL DEFAULT NOW(),
    updated_at DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
    CONSTRAINT fk_addresses_room_id_rooms_id FOREIGN KEY (room_id) REFERENCES rooms(id),
    CONSTRAINT fk_addresses_city_id_countries_id FOREIGN KEY (country_id) REFERENCES countries(id),
    CONSTRAINT fk_addresses_city_id_cities_id FOREIGN KEY (city_id) REFERENCES cities(id)
) COMMENT 'Адреса';

DROP TABLE IF EXISTS photo_albums;
CREATE TABLE photo_albums (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    room_id INT UNSIGNED NOT NULL,
    created_at DATETIME NOT NULL DEFAULT NOW(),
    updated_at DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
    CONSTRAINT fk_photo_albums_rooms FOREIGN KEY (room_id) REFERENCES rooms(id)
) COMMENT 'Фотографии конкретного размещения';

DROP TABLE IF EXISTS photos;
CREATE TABLE photos (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    album_id INT UNSIGNED NOT NULL,
    placement_id INT UNSIGNED NOT NULL,
    filename VARCHAR(255),
    metadata JSON,
    created_at DATETIME NOT NULL DEFAULT NOW(),
    updated_at DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
    CONSTRAINT fk_album_id_photo_albums_id FOREIGN KEY (album_id) REFERENCES photo_albums(id),
    CONSTRAINT fk_placement_id FOREIGN KEY (placement_id) REFERENCES placement(id)
) COMMENT 'Все фотографии';

DROP TABLE IF EXISTS booked;
CREATE TABLE booked (
    user_id BIGINT UNSIGNED NOT NULL,
    room_id INT UNSIGNED NOT NULL,
    arrival_date DATE NOT NULL,
    departure_date DATE NOT NULL,
    created_at DATETIME NOT NULL DEFAULT NOW(),
    updated_at DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
    CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_room_id FOREIGN KEY (room_id) REFERENCES rooms(id)
) COMMENT 'Забронированные размещения';

DROP TABLE IF EXISTS rating;
CREATE TABLE rating (
    room_id INT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    review TEXT,
    grade SMALLINT UNSIGNED,
    PRIMARY KEY (room_id, user_id),
    CONSTRAINT fk_rating_placement_id FOREIGN KEY (room_id) REFERENCES rooms(id),
    CONSTRAINT fk_rating_user_id FOREIGN KEY (user_id) REFERENCES users(id)
) COMMENT 'Оценки';