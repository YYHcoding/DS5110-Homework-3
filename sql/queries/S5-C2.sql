--Predicted row  = 7
-- Actual Row = 7
SELECT u.occupation, AVG(r.rating) AS mean_ratings FROM ratings r
JOIN users u ON r.user_id = u.user_id
GROUP BY u.occupation
HAVING COUNT(DISTINCT r.user_id) >=50;