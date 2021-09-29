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
    updated_at DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW()
);

DROP TABLE IF EXISTS countries;
CREATE TABLE countries (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    country VARCHAR(100) UNIQUE NOT NULL,
    created_at DATETIME NOT NULL DEFAULT NOW(),
    updated_at DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW()
);

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    city VARCHAR(100) UNIQUE NOT NULL,
    country_id INT UNSIGNED NOT NULL,
    created_at DATETIME NOT NULL DEFAULT NOW(),
    updated_at DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
    KEY idx_fk_country_id (country_id),
    CONSTRAINT fk_city_country FOREIGN KEY (country_id) REFERENCES countries(id)
);

DROP TABLE IF EXISTS addresses;
CREATE TABLE addresses (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    city_id INT UNSIGNED NOT NULL,
    address VARCHAR(255) NOT NULL,
    phone BIGINT UNSIGNED UNIQUE,
    created_at DATETIME NOT NULL DEFAULT NOW(),
    updated_at DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
    CONSTRAINT fk_address_city FOREIGN KEY (city_id) REFERENCES cities(id)
);

DROP TABLE IF EXISTS placement;
CREATE TABLE placement (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    addresses_id INT UNSIGNED NOT NULL,
    type ENUM('hotel', 'apartments', 'resorts', 'villas', 'chalet'),
    name VARCHAR(255),
    description TEXT,
    created_at DATETIME NOT NULL DEFAULT NOW(),
    updated_at DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
    CONSTRAINT fk_placement_address FOREIGN KEY (addresses_id) REFERENCES addresses(id)
);

DROP TABLE IF EXISTS rooms;
CREATE TABLE rooms (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    placement_id INT UNSIGNED NOT NULL,
    room_capacity INT UNSIGNED NOT NULL,
    facilities TEXT,
    price DECIMAL (11,2),
    CONSTRAINT fk_room_placement FOREIGN KEY (placement_id) REFERENCES placement(id)
);

DROP TABLE IF EXISTS photo_albums;
CREATE TABLE photo_albums (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    room_id INT UNSIGNED NOT NULL,
    created_at DATETIME NOT NULL DEFAULT NOW(),
    updated_at DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
    CONSTRAINT fk_photo_albums_rooms FOREIGN KEY (room_id) REFERENCES rooms(id)
);

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
);

DROP TABLE IF EXISTS booked;
CREATE TABLE booked (
    user_id BIGINT UNSIGNED NOT NULL,
    room_id INT UNSIGNED NOT NULL,
    arrival_date DATETIME NOT NULL,
    departure_date DATETIME NOT NULL,
    created_at DATETIME NOT NULL DEFAULT NOW(),
    updated_at DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
    CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_room_id FOREIGN KEY (room_id) REFERENCES rooms(id)
);

DROP TABLE IF EXISTS reviews;
CREATE TABLE reviews (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    placement_id INT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME NOT NULL DEFAULT NOW(),
    updated_at DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
    CONSTRAINT fk_reviews_user_id_users_id FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_reviews_placement_id_placement_id FOREIGN KEY (placement_id) REFERENCES placement(id)
);

DROP TABLE IF EXISTS rating;
CREATE TABLE rating (
    placement_id INT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    grade FLOAT UNSIGNED,
    CONSTRAINT fk_rating_placement_id FOREIGN KEY (placement_id) REFERENCES placement(id),
    CONSTRAINT fk_rating_user_id FOREIGN KEY (user_id) REFERENCES users(id)
);