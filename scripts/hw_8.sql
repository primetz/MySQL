/*
    1. Пусть задан некоторый пользователь. Из всех пользователей соц. сети
       найдите человека, который больше всех общался с выбранным пользователем (написал ему сообщений).
*/
SET @to_user_id = 19;
SELECT
    users.*,
    COUNT(messages.from_user_id) AS count_of_messages
FROM users
JOIN messages ON users.id = messages.from_user_id
WHERE messages.to_user_id = @to_user_id
GROUP BY messages.from_user_id
ORDER BY count_of_messages DESC
LIMIT 1;



/*
    2. Подсчитать общее количество лайков, которые получили пользователи младше 10 лет..
*/
SET @age = 10;
SELECT
    COUNT(likes.media_id) AS total_likes
FROM likes
JOIN media ON media.id = likes.media_id
JOIN profiles ON profiles.user_id = media.user_id
WHERE TIMESTAMPDIFF(YEAR, profiles.birthday, NOW()) < @age;


/*
    3. Определить кто больше поставил лайков (всего): мужчины или женщины.
*/

SELECT
    CASE (profiles.gender)
        WHEN 'm' THEN 'male'
        WHEN 'f' THEN 'female'
        END AS gender,
    COUNT(*) AS put_likes
FROM likes
JOIN profiles ON profiles.user_id = likes.user_id
GROUP BY gender;