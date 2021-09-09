# ii. Написать скрипт, возвращающий список имен (только firstname) пользователей без повторений в алфавитном порядке
SELECT DISTINCT firstname
FROM users
ORDER BY firstname;

# iii. Написать скрипт, отмечающий несовершеннолетних пользователей как неактивных (поле is_active = false). Предварительно добавить такое поле в таблицу profiles со значением по умолчанию = true (или 1)
ALTER TABLE profiles
    ADD COLUMN is_active BIT DEFAULT 1;

UPDATE profiles
SET is_active = 0
WHERE DATE_SUB(NOW(), INTERVAL 18 YEAR) < birthday;

# iv. Написать скрипт, удаляющий сообщения «из будущего» (дата больше сегодняшней)
DELETE
FROM messages
WHERE created_at > NOW();