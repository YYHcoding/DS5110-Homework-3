# Step 0 – Describe the Raw Data

## 0(a) Raw Data Inspection

We used Python and pandas to inspect the three main raw files in the MovieLens 100K dataset before designing the SQLite database.

| Raw file | Rows | Columns | One row represents |
|---|---:|---:|---|
| `u.user` | 943 | 5 | One user and their demographic information |
| `u.item` | 1,682 | 24 | One movie and its metadata, including 19 genre indicators |
| `u.data` | 100,000 | 4 | One rating submitted by a user for a movie |

The `u.user` file contains user ID, age, gender, occupation, and ZIP code. The `u.item` file contains movie metadata, including title, release date, IMDb URL, and genre flags. The `u.data` file contains user ID, movie ID, rating, and timestamp.

The first few rows of each dataset are displayed in `Notebooks/01_exploration.ipynb`, which also contains our exploratory analysis.

## 0(b) Tidy Data Assessment

**`u.user`:** Each row represents one user, and each column represents one attribute of that user. The file follows tidy data principles because each user is represented by a single observation.

**`u.data`:** Each row represents one user–movie rating. The columns contain the user ID, movie ID, rating, and timestamp. This file is tidy because each rating is one observation and each variable has its own column.

**`u.item`:** Each row represents one movie. Most movie attributes are stored in separate columns, but genre membership is represented by 19 binary indicator columns. This is a wide representation of the movie–genre relationship rather than a normalized relational structure.

For our SQLite database, we convert these indicators into separate `genres` and `movie_genres` tables. This allows one movie to belong to multiple genres without storing a separate column for every possible genre.

## 0(c) File Formats and Data Quality

The three raw files use different formats and require different parsing settings.

| File | Delimiter | Encoding | Important considerations |
|---|---|---|---|
| `u.user` | Pipe (`\|`) | Not separately verified | ZIP codes must be treated as text |
| `u.item` | Pipe (`\|`) | Latin-1 | Contains 19 genre flags and missing movie metadata |
| `u.data` | Tab (`\t`) | Not separately verified | Ratings and timestamps should be parsed as integers |

**Delimiters and encoding:** The `u.user` and `u.item` files use pipe-separated values, while `u.data` is tab-separated. During database loading, UTF-8 decoding caused some movie records to be rejected. Using Latin-1 encoding allowed those movie titles to be read correctly.

**Column types:** User IDs, movie IDs, ratings, and timestamps are stored as integers. ZIP codes are stored as text because they are identifiers rather than quantities. Treating them as integers could remove leading zeros.

**Missing values:** Some movie metadata fields are blank, including release dates, video release dates, and IMDb URLs. These optional fields can be represented as SQL `NULL` values. Required fields remain subject to the schema's `NOT NULL` constraints.

**Data quality checks:** The database schema enforces valid rating ranges, primary keys, foreign keys, and required fields. Additional SQL queries are needed to verify dataset-level claims, such as the total number of ratings and the minimum number of ratings per user.

## 0(d) Exploratory Data Analysis

### Chart 1 – Distribution of Ratings

The first chart shows the distribution of all 100,000 ratings in the MovieLens 100K dataset. Rating 4 is the most frequent score, with 34,174 observations (34.17%), followed by rating 3 with 27,145 observations (27.15%). Ratings of 4 and 5 together account for 55.38% of all ratings.

This suggests that the observed ratings are concentrated toward higher scores. All observed ratings fall between 1 and 5, consistent with the documented rating scale.

**Follow-up check:** After loading the data into SQLite, we should verify that the database contains 100,000 ratings and that every rating satisfies the constraint `CHECK (rating BETWEEN 1 AND 5)`.

The chart and its generating code are available in `Notebooks/01_exploration.ipynb`.
### Chart 2 – Number of Ratings per User

The second chart shows the distribution of rating counts across 943 users. On average, each user contributed 106.04 ratings, while the median was 65. The minimum number of ratings was 20, and the maximum was 737.

The histogram is right-skewed: most users contributed relatively few ratings, while a small number of highly active users contributed hundreds of ratings. These highly active users raise the mean above the median.

**Follow-up check:** The observed minimum of 20 ratings per user is consistent with the MovieLens documentation. After loading the data into SQLite, we should verify this claim using a SQL query that counts ratings for every user.

The chart and its generating code are available in `Notebooks/01_exploration.ipynb`.

# Step 3 — Load the data and keep what is refused

## Predictions

The loader uses UTF-8 decoding, with date format of `DD-MMM-YYYY`, does not allow blank required fields, and retains blank optional movie
fields as `NULL`. Scanning the source data, some movie has invalid characters, and some ratings & genres will be dropped because of the rejection of those movies. Due to the amount of data, I can only estimate on how many rows will be rejected.

| Table | Predicted rows | Basis |
|---|---:|---|
| `occupations` | 21 | One row per line in `u.occupation` |
| `users` | 943 | One row per record in `u.user` |
| `movies` | 1,680 | 1,682 source rows in `u.item`, some rows have illegal char |
| `genres` | 19 | The 19 named genre IDs in `u.genre` |
| `movie_genres` | 2,000 | Most movies have 1-3 genres, 2000 is a good estimate on a tidy form of genres with movies|
| `ratings` | 99,950| 100,000 source rows, some ratings are associated with refused movies |
| Rejected records | 52 | 2 movie rows plus 50 ratings with missing movie references |


## Results 1

| Table | Predicted rows | Actual rows | Difference | Reason|
|---|---:|---:|---:|---:|
| `occupations` | 21 | 21 | 0 |  |
| `users` | 943 | 943 | 0 |  |
| `movies` | 1,680 | 1,672 | 8| More movies have illegal characters |
| `genres` | 19 | 19 | 0 |  |
| `movie_genres` | 2,000| 2,878 | 0 | The initial estimate was not accurate. More genres than we thought |
| `ratings` | 99,950| 99,926 | 0 | Expected less rating being dropped. Actuallly more |
| Rejected records | 52| 84 | 0 |  |

The rejections were fixable. We can change the decode format to allow the non-utf8 characters. Also, there was a line rejected for bad date foramt: `u.item,1373,movies,"[""1373"", ""Good Morning (1971)"", ""4-Feb-1971"", """", ""http://us.imdb.com/M/title-exact?Good%20Morning%20(1971)"", ""1"", ""0"", ""0"", ""0"", ""0"", ""0"", ""0"", ""0"", ""0"", ""0"", ""0"", ""0"", ""0"", ""0"", ""0"", ""0"", ""0""]",invalid release date '4-Feb-1971'; expected DD-MMM-YYYY`. This should be accepted because the cell itself has valid data. The dropped ratings should also be included after changing decoding method.

## Follow-up: reload all source rows

The Makefile now runs `src/load.py` first, then `src/reload.py`. The second script clears and rebuilds
`data/movielens.db` from all raw files; it decodes the text as Latin-1 and keeps release dates as source text. Empty optional movie fields (release date, video-release date, and IMDb URL) are stored as SQL `NULL`, matching the nullable columns in the schema; they do not cause the movie row to be rejected. Required fields remain subject to the schema's `NOT NULL` constraints. The reload script does not write or replace the rejection CSV, so that file remains the record of what the first load rejected.

## Results 2

| Table / report | After `load.py` | After `reload.py` | Restored by reload |
|---|---:|---:|---:|
| `occupations` | 21 | 21 | 0 |
| `users` | 943 | 943 | 0 |
| `movies` | 1,672 | 1,682 | 10 |
| `genres` | 19 | 19 | 0 |
| `movie_genres` | 2,878 | 2,893 | 15 |
| `ratings` | 99,926 | 100,000 | 74 |
| Rejected rows | 84 | 0|  |

# Step 4

## Claim 1
"There are 100,000 ratings by 943 users on 1,682 movies"
This is supported by sql/queries/S4-C1.sql. This query shows the number of ratings, movies, and users.
Result:
```
sqlite> .read sql/queries/S4-C1.sql
╭───────────┬──────────┬─────────╮
│ N_RATINGS │ N_MOVIES │ N_USERS │
╞═══════════╪══════════╪═════════╡
│    100000 │     1682 │     943 │
╰───────────┴──────────┴─────────╯
```

## Claim 2

"Users and movies are numbered consecutively from 1"
 This is supported by sql/queries/S4-C2.sql. This query shows the min and max user IDs and movie IDs. The total is the total of unique IDs. If the max equals unique total, and table schema enforce all IDs to be integers, the IDs must be continuous.
Result:
```
sqlite> .read sql/queries/S4-C2.sql
╭────────┬────────┬──────────────╮
│ min_id │ max_id │ unique_total │
╞════════╪════════╪══════════════╡
│      1 │    943 │          943 │
╰────────┴────────┴──────────────╯
╭────────┬────────┬──────────────╮
│ min_id │ max_id │ unique_total │
╞════════╪════════╪══════════════╡
│      1 │   1682 │         1682 │
╰────────┴────────┴──────────────╯
```


## Claim 3

"Every user has rated at least 20 movies."
This is supported by sql/queries/S4-C3.sql. This query shows the 10 users with least ratings in the dataset.
Result:
```
sqlite> .read sql/queries/S4-C3.sql
╭─────────┬──────────────╮
│ user_id │ rating_count │
╞═════════╪══════════════╡
│      19 │           20 │
│      34 │           20 │
│      36 │           20 │
│      93 │           20 │
│     143 │           20 │
│     147 │           20 │
│     166 │           20 │
│     202 │           20 │
│     242 │           20 │
│     300 │           20 │
╰─────────┴──────────────╯
```


