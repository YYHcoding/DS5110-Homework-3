--Query per table

--USERS TABLE
SELECT
    SUM(occupation IS NULL) as occupation_NULL
FROM users;


--MOVIE TABLE
SELECT
    SUM(movie_id IS NULL) as movie_id_NULL,
    SUM(title IS NULL) as title_NULL,
    SUM(release_date IS NULL) as release_date_NULL,
    SUM(video_release_date IS NULL) as video_release_date_NULL,
    SUM(imdb_url IS NULL) as imdb_url_NULL
FROM movies;
