--Actual rows = 8
SELECT movie_id, strftime('%m',datetime(timestamp,'unixepoch')) AS month, COUNT(*) AS n_ratings from ratings
GROUP BY month
ORDER BY month;