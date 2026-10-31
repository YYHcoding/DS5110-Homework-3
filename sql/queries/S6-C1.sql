---Step 1: Calculating avg rating of each movie
--Step 2: movies with 30+ ratings
--Step 3: mean rating per game
--Step 4: eligible movie vs its genre
--Step 5: at least 0.5 above genre mean
WITH movie_stats AS(
    SELECT movie_id, COUNT(*) AS n_ratings, AVG(rating) AS movie_mean FROM ratings
    GROUP BY movie_id
),
eligible AS(SELECT * FROM movie_stats WHERE n_ratings>=30), 

genre_stats AS(   
    SELECT mg.genre_id, AVG(r.rating) AS genre_mean FROM ratings r
    JOIN movie_genres mg on r.movie_id=mg.movie_id
    GROUP BY mg.genre_id
),
compared AS(
    SELECT e.movie_id, mg.genre_id, e.n_ratings, e.movie_mean, gs.genre_mean FROM eligible e
    JOIN movie_genres mg ON mg.movie_id = e.movie_id
    JOIN genre_stats gs ON gs.genre_id = mg.genre_id 
),
winners AS(SELECT * FROM compared WHERE movie_mean >= genre_mean +0.5)
SELECT m.title, g.name AS genre, w.n_ratings, ROUND(w.movie_mean,2) AS movie_mean, ROUND(w.genre_mean,2) AS genre_mean
FROM winners w
JOIN movies m ON m.movie_id = w.movie_id
JOIN genres g ON g.genre_id = w.genre_id   
ORDER BY g.name, w.movie_mean DESC;