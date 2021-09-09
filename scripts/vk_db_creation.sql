# DDL = Data Definition Language (язык определения данных) команды CREATE ALTER DROP

DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;
USE vk;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    # id SERIAL, # BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
    firstname VARCHAR(100),
    lastname VARCHAR(100) COMMENT 'Фамилия', # COMMENT - На случай если имя столбца не очевидное
    email VARCHAR(100) UNIQUE,
    phone BIGINT UNSIGNED UNIQUE, # +7 (900) 123-45-67 => 79 001 234 567 номер телефона храним в виде числа
    password_hash VARCHAR(100), # 123456 => vzx;clvgkajrpo9udfxvsldkrn24l5456345t

    INDEX idx_users_firstname_lastname(firstname, lastname)
) COMMENT 'Пользователи'; # COMMENT - Комментарий ко всей таблице

# Связь один к одному
DROP TABLE IF EXISTS `profiles`; # Если имя таблицы совпадает с зарезервированным словом то его следует обернуть в обратные кавычки
CREATE TABLE `profiles` (
    user_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
    gender CHAR(1),
    birthday DATE,
    photo_id BIGINT UNSIGNED NOT NULL,
    hometown VARCHAR(200),
    created_at DATETIME DEFAULT NOW() # При создании записи автоматически установить дату и время
);

ALTER TABLE `profiles`
    ADD CONSTRAINT fk_profiles_user_id
    FOREIGN KEY (user_id) REFERENCES users(id); # Добавление внешнего ключа в существующую таблицу. Таблица profiles ссылается полем user_id на поле id в таблице users (таким образом реализуется связь один к одному)

# ALTER TABLE `profiles` ADD COLUMN birthday DATETIME;            # Добавление колонки в существующую таблицу
# ALTER TABLE `profiles` MODIFY COLUMN birthday DATE;             # Изменение колонки в существующей таблице
# ALTER TABLE `profiles` RENAME COLUMN birthday TO date_of_birth; # Переименование колонки в существующей таблице
# ALTER TABLE `profiles` DROP COLUMN birthday;                    # Удаление колонки из существующей таблицы

# Связь один ко многим
DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
    id SERIAL,
    from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(),

    FOREIGN KEY (from_user_id) REFERENCES users(id), # Добавление внешнего ключа при создании таблицы.
    FOREIGN KEY (to_user_id) REFERENCES users(id)    # Таблица messages ссылается полями from_user_id и to_user_id на поле id в таблице users (таким образом реализуется связь один ко многим)
);

DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests (
    initiator_user_id BIGINT UNSIGNED NOT NULL,
    target_user_id BIGINT UNSIGNED NOT NULL,
    status ENUM('requested', 'approved', 'declined', 'unfriended'),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE NOW(), # При обновлении записи автоматически установить дату и время

    PRIMARY KEY (initiator_user_id, target_user_id), # Составной первичный ключ (для того чтоб в таблице не оказалось двух строк с информацией о дружбе между одними и теми же людьми)
    FOREIGN KEY (initiator_user_id) REFERENCES users(id),
    FOREIGN KEY (target_user_id) REFERENCES users(id),
    CHECK ( initiator_user_id != target_user_id ) # Проверка для того чтоб пользователь не мог отправлять заявку в друзья самому себе
);

# ALTER TABLE friend_requests ADD CHECK ( initiator_user_id <> target_user_id ); # Добавление проверки в существующую таблицу

DROP TABLE IF EXISTS communities;
CREATE TABLE communities (
    id SERIAL,
    name VARCHAR(200),
    admin_user_id BIGINT UNSIGNED NOT NULL,

    INDEX idx_communities_name(name),
    FOREIGN KEY (admin_user_id) REFERENCES users(id)
);

# Связь многие ко многим осуществляется отдельной таблицей в которой внешние ключи ссылаются на первичные ключи таблиц между которыми нужно реализовать связь
DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities (
    user_id BIGINT UNSIGNED NOT NULL,
    community_id BIGINT UNSIGNED NOT NULL,

    PRIMARY KEY (user_id, community_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (community_id) REFERENCES communities(id)
);

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types (
    id SERIAL,
    name VARCHAR(255) # 'text', 'video', 'music', 'image' - храним в этой таблице всего 4 строки и ссылаемся на них из таблицы media полем media_type_id
);

DROP TABLE IF EXISTS media;
CREATE TABLE media (
    id SERIAL,
    user_id BIGINT UNSIGNED NOT NULL,
    # media_type ENUM('text', 'video', 'music', 'image'),
    media_type_id BIGINT UNSIGNED NOT NULL,
    # body TEXT, # Если хотим чтоб пост был длинным
    body VARCHAR(255),
    # file BLOB, # Если хотим хранить файлы в этой базе данных
    filename VARCHAR(255), # Храним только имя файла, а сам файл храним в другой БД (возможно даже на другом сервере)
    metadata JSON,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE NOW(),

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
);

ALTER TABLE `profiles`
    ADD CONSTRAINT fk_profiles_photo_id
    FOREIGN KEY (photo_id) REFERENCES media(id);

DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
    id SERIAL,
    user_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);

DROP TABLE IF EXISTS photo_albums;
CREATE TABLE photo_albums (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) DEFAULT NULL,
    user_id BIGINT UNSIGNED NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS photos;
CREATE TABLE photos (
    id SERIAL,
    album_id BIGINT UNSIGNED NULL,
    media_id BIGINT UNSIGNED NOT NULL,

    FOREIGN KEY (album_id) REFERENCES photo_albums(id),
    FOREIGN KEY (media_id) REFERENCES  media(id)
);

DROP TABLE IF EXISTS video_albums;
CREATE TABLE video_albums (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) DEFAULT NULL,
    user_id BIGINT UNSIGNED NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS videos;
CREATE TABLE videos (
    id SERIAL,
    album_id BIGINT UNSIGNED NULL,
    media_id BIGINT UNSIGNED NOT NULL,

    FOREIGN KEY (album_id) REFERENCES video_albums(id),
    FOREIGN KEY (media_id) REFERENCES  media(id)
);

DROP TABLE IF EXISTS music_albums;
CREATE TABLE music_albums (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) DEFAULT NULL,
    user_id BIGINT UNSIGNED NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS music;
CREATE TABLE music (
    id SERIAL,
    album_id BIGINT UNSIGNED NULL,
    media_id BIGINT UNSIGNED NOT NULL,

    FOREIGN KEY (album_id) REFERENCES music_albums(id),
    FOREIGN KEY (media_id) REFERENCES  media(id)
);