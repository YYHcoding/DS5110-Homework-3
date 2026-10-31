--Actual Rows = 19
SELECT g.name AS genre_name, COUNT(r.rating) AS N_RATINGS, AVG(r.rating) AS mean_ratings FROM ratings r
JOIN movie_genres mg on r.movie_id = mg.movie_id
JOIN genres g on mg.genre_id = g.genre_id
GROUP BY g.name;

--Actual row = 1
WITH counts AS(
    SELECT g.name AS genre_name, COUNT(r.rating) AS N_RATINGS, AVG(r.rating) AS mean_ratings FROM ratings r
    JOIN movie_genres mg on r.movie_id = mg.movie_id
    JOIN genres g on mg.genre_id = g.genre_id
    GROUP BY g.name
)
SELECT SUM(N_RATINGS) AS total FROM counts;

--Actual rows = 1

--case3
WITH counts AS(
    SELECT g.name AS genre_name, COUNT(r.rating) AS N_RATINGS, AVG(r.rating) AS mean_ratings FROM ratings r
    JOIN movie_genres mg on r.movie_id = mg.movie_id
    JOIN genres g on mg.genre_id = g.genre_id
    GROUP BY g.name
)
SELECT SUM(N_RATINGS) AS total, SUM(N_RATINGS) = 100000 AS equal_to_100000 FROM counts;

--CHECK
SELECT COUNT(*) AS movies_without_genres FROM movies
WHERE NOT EXISTS ( SELECT 1 FROM movie_genres mg WHERE mg.movie_id = movies.movie_id);

SELECT COUNT(*) AS rating_without_genres FROM ratings
WHERE NOT EXISTS ( SELECT 1 FROM movie_genres mg WHERE mg.movie_id = ratings.movie_id);
