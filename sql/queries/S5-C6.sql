--Actual rows = 50
SELECT movie_id, title FROM movies WHERE movie_id IN(
    SELECT movie_id FROM ratings r
    JOIN users u ON r.user_id = u.user_id
    WHERE occupation = 'student'

    EXCEPT

    SELECT movie_id FROM ratings r
    JOIN users u ON r.user_id = u.user_id
    WHERE occupation = 'programmer'
)
