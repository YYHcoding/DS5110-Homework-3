--Predicted Row count = 10
--Actual Row count =10
WITH counts AS(
    SELECT movie_id, COUNT(*) as N_RATINGS FROM ratings
    GROUP BY movie_id
)
SELECT movies.movie_id, movies.title, counts.N_RATINGS FROM counts
JOIN movies ON counts.movie_id = movies.movie_id
ORDER BY counts.N_RATINGS DESC
LIMIT 10;