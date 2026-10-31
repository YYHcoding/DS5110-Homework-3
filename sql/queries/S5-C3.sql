--Prediction - 10+ rows
--Actual - 17
SELECT user_id, zip from USERS WHERE SUBSTR(zip,1,1) NOT BETWEEN '0' AND '9';