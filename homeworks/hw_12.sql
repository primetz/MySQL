/* Представление - топ размещений */
CREATE OR REPLACE VIEW top_rooms AS
SELECT
    *
FROM rooms
         JOIN rating r ON rooms.id = r.room_id
GROUP BY r.room_id, r.user_id
HAVING AVG(r.grade) >= 9;

SELECT * FROM top_rooms;

/* Представление для поиска свободных размещений */
CREATE OR REPLACE VIEW rooms_booked
AS
SELECT
    rooms.id AS room_id,
    rooms.type AS type,
    rooms.facilities AS facilities,
    rooms.price AS price,
    a.address AS address,
    a.phone AS phone,
    c.country AS country,
    b.arrival_date AS arrival_date,
    b.departure_date AS departure_date
FROM rooms
    JOIN addresses a ON rooms.id = a.room_id
    JOIN countries c ON c.id = a.country_id
    LEFT JOIN booked b ON rooms.id = b.room_id;

SELECT * FROM rooms_booked;

/* Процедура для поиска свободных размещений по заданным параметрам */
DELIMITER //
DROP PROCEDURE IF EXISTS search_rooms//
CREATE PROCEDURE search_rooms(room_country VARCHAR(100), room_type VARCHAR(255), arrivalDate DATE, departureDate DATE)
BEGIN
    SELECT *
    FROM rooms_booked
    WHERE (departure_date < arrivalDate OR arrival_date > departureDate OR arrival_date IS NULL)
      AND (type = room_type)
      AND (country = room_country);
END //
DELIMITER ;

/* Поиск свободных размещений по заданным параметрам */
CALL search_rooms('Greenland','resorts','2021-11-15', '2021-11-25');

/* Триггер на запрет бронирования дат в прошлом */
DELIMITER //
CREATE TRIGGER insert_booked BEFORE INSERT ON booked
    FOR EACH ROW
BEGIN
    IF NEW.arrival_date < NOW() OR NEW.departure_date < NOW()
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Past check-in or check-out dates cannot be booked';
    END IF;
END//
DELIMITER ;

INSERT INTO booked
VALUES (10, 8, '2021-08-25', '2021-09-25', DEFAULT, DEFAULT);

INSERT INTO booked
VALUES (10, 8, '2021-10-25', '2021-11-25', DEFAULT, DEFAULT);

/* Поиск всех фотографий размещения */
SELECT
    filename
FROM photos
         JOIN photo_albums pa ON pa.id = photos.album_id
         JOIN rooms r ON r.id = pa.room_id
WHERE r.id = 7;

/* Рейтинг размещения */
SELECT
    AVG(grade) AS rating
FROM rating
         JOIN rooms r on r.id = rating.room_id
WHERE r.id = 7;

/* Отзывы */
SELECT
    u.firstname,
    review
FROM rating
         JOIN users u on rating.user_id = u.id
         JOIN rooms r on r.id = rating.room_id
WHERE r.id = 7;