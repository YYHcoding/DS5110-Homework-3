
-- Step 5, Question 1: Top 10 movies by number of ratings, including ties.
-- RANK() assigns the same rank to movies with equal rating counts.

WITH movie_counts AS (
    SELECT
        movie_id,
        COUNT(*) AS n_ratings
    FROM ratings
    GROUP BY movie_id
),
ranked_movies AS (
    SELECT
        movie_id,
        n_ratings,
        RANK() OVER (ORDER BY n_ratings DESC) AS rating_rank
    FROM movie_counts
)
SELECT
    m.movie_id,
    m.title,
    r.n_ratings,
    r.rating_rank
FROM ranked_movies r
JOIN movies m ON m.movie_id = r.movie_id
WHERE r.rating_rank <= 10
ORDER BY r.rating_rank, m.movie_id;
