
-- Step 5, Question 5
-- Count ratings by calendar month (YYYY-MM).

SELECT
    strftime(
        '%Y-%m',
        datetime(timestamp, 'unixepoch')
    ) AS calendar_month,
    COUNT(*) AS rating_count
FROM ratings
GROUP BY calendar_month
ORDER BY calendar_month;
