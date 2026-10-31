--Nested Subqueries
SELECT m.title, g.name AS genre, w.n_ratings, w.movie_mean, w.genre_mean AS genre_mean
FROM(
    SELECT *
    FROM(
        SELECT e.movie_id,mg.genre_id,e.n_ratings,e.movie_mean,gs.genre_mean
        FROM(
            SELECT *
            FROM (
                SELECT 
                    movie_id,
                    COUNT(*) AS n_ratings,AVG(rating) AS movie_mean 
                FROM ratings
                GROUP BY movie_id) AS movie_stats
            WHERE n_ratings>=30
            ) AS e
            JOIN movie_genres mg
                ON mg.movie_id = e.movie_id
            JOIN(
                SELECT
                    mg.genre_id,
                    AVG(r.rating) AS genre_mean
                FROM ratings r
                JOIN movie_genres mg
                    ON r.movie_id = mg.movie_id
                GROUP BY mg.genre_id
            ) AS gs 
                ON gs.genre_id = mg.genre_id
    ) AS compared
    WHERE movie_mean >= genre_mean + 0.5
) AS w
JOIN movies m
    ON m.movie_id = w.movie_id
JOIN genres g
    ON g.genre_id = w.genre_id
ORDER BY g.name, w.movie_mean DESC;
        

                
