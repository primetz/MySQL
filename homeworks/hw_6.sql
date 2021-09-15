/*
    1. Пусть задан некоторый пользователь. Из всех пользователей соц. сети
       найдите человека, который больше всех общался с выбранным пользователем (написал ему сообщений).
*/
SET @to_user_id = 19;
SELECT
    *
FROM users
WHERE id = (
    SELECT from_user_id
    FROM messages
    WHERE to_user_id = @to_user_id
    GROUP BY from_user_id
    ORDER BY COUNT(from_user_id) DESC
    LIMIT 1
);


/*
    2. Подсчитать общее количество лайков, которые получили пользователи младше 10 лет..
*/
SET @age = 10;
SELECT
    COUNT(media_id) AS total_likes
FROM likes
WHERE media_id IN (
    SELECT id FROM media WHERE user_id IN (
        SELECT user_id FROM profiles WHERE TIMESTAMPDIFF(YEAR, birthday, NOW()) < @age
    )
);


/*
    3. Определить кто больше поставил лайков (всего): мужчины или женщины.
*/
SELECT
    CASE (SELECT gender FROM profiles WHERE user_id = likes.user_id)
        WHEN 'm' THEN 'male'
        WHEN 'f' THEN 'female'
    END AS gender,
    COUNT(*) AS put_likes
FROM likes
GROUP BY gender;
