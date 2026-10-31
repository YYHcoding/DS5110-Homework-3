--There's a NULL in release_date

SELECT movie_id, title FROM movies
WHERE release_date NOT IN (SELECT release_date from movies);

SELECT m.movie_id,m.title FROM movies m
WHERE NOT EXISTS (SELECT 1 FROM movies m1 where m.release_date=m1.release_date);