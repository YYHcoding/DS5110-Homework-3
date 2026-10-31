
-- Step 7, Case 1: NULL audit for every database column.
-- Each result reports the number of NULL values in one column.

SELECT 'occupations' AS table_name, 'occupation' AS column_name,
       COUNT(*) - COUNT(occupation) AS null_count
FROM occupations

UNION ALL
SELECT 'users', 'user_id', COUNT(*) - COUNT(user_id) FROM users
UNION ALL
SELECT 'users', 'age', COUNT(*) - COUNT(age) FROM users
UNION ALL
SELECT 'users', 'gender', COUNT(*) - COUNT(gender) FROM users
UNION ALL
SELECT 'users', 'occupation', COUNT(*) - COUNT(occupation) FROM users
UNION ALL
SELECT 'users', 'zip', COUNT(*) - COUNT(zip) FROM users

UNION ALL
SELECT 'movies', 'movie_id', COUNT(*) - COUNT(movie_id) FROM movies
UNION ALL
SELECT 'movies', 'title', COUNT(*) - COUNT(title) FROM movies
UNION ALL
SELECT 'movies', 'release_date', COUNT(*) - COUNT(release_date) FROM movies
UNION ALL
SELECT 'movies', 'video_release_date', COUNT(*) - COUNT(video_release_date) FROM movies
UNION ALL
SELECT 'movies', 'imdb_url', COUNT(*) - COUNT(imdb_url) FROM movies

UNION ALL
SELECT 'genres', 'genre_id', COUNT(*) - COUNT(genre_id) FROM genres
UNION ALL
SELECT 'genres', 'name', COUNT(*) - COUNT(name) FROM genres

UNION ALL
SELECT 'movie_genres', 'movie_id', COUNT(*) - COUNT(movie_id) FROM movie_genres
UNION ALL
SELECT 'movie_genres', 'genre_id', COUNT(*) - COUNT(genre_id) FROM movie_genres

UNION ALL
SELECT 'ratings', 'user_id', COUNT(*) - COUNT(user_id) FROM ratings
UNION ALL
SELECT 'ratings', 'movie_id', COUNT(*) - COUNT(movie_id) FROM ratings
UNION ALL
SELECT 'ratings', 'rating', COUNT(*) - COUNT(rating) FROM ratings
UNION ALL
SELECT 'ratings', 'timestamp', COUNT(*) - COUNT(timestamp) FROM ratings

ORDER BY table_name, column_name;
