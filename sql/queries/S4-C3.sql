SELECT
    u.user_id,
    COUNT(r.movie_id) AS rating_count
FROM users AS u
LEFT JOIN ratings AS r ON r.user_id = u.user_id
GROUP BY u.user_id
ORDER BY rating_count ASC, u.user_id ASC
LIMIT 10;