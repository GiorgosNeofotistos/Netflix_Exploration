SELECT *
FROM `netflixproject-472211.NetflixProject.Netflix_data`
LIMIT 10;

#1 BASIC EXPLORATION QUERIES
#1.1 Total Number Shows
SELECT COUNT(*) AS total_shows
FROM `netflixproject-472211.NetflixProject.Netflix_data` ;

#1.2 Count per type (Movie/TV Show)
SELECT type, COUNT(*) AS count
FROM `netflixproject-472211.NetflixProject.Netflix_data`
GROUP BY type
ORDER BY count DESC;

#1.3 Top 10 Countries by Number of Shows
SELECT country, COUNT(*) AS num_shows
FROM `netflixproject-472211.NetflixProject.Netflix_data`
GROUP BY country
ORDER BY num_shows DESC
LIMIT 10;

#1.4 Shows per Release Year
SELECT release_year, COUNT(*) AS num_shows
FROM `netflixproject-472211.NetflixProject.Netflix_data`
GROUP BY release_year
ORDER BY release_year;

#1.4 Top 10 Genres by Number of Shows(combo genres)
SELECT listed_in AS genre_combo, COUNT(*) AS num_shows
FROM `netflixproject-472211.NetflixProject.Netflix_data`
GROUP BY listed_in
ORDER BY num_shows DESC
LIMIT 10;

#1.5 Top 10 Directors by Number of Shows
SELECT director, COUNT(*) AS num_shows
FROM `netflixproject-472211.NetflixProject.Netflix_data`
WHERE director IS NOT NULL
GROUP BY director
ORDER BY num_shows DESC
LIMIT 10;

#1.6 Top Ratings by Category
SELECT rating, COUNT(*) AS num_shows
FROM `netflixproject-472211.NetflixProject.Netflix_data`
WHERE rating IS NOT NULL
GROUP BY rating
ORDER BY num_shows DESC
LIMIT 10;

#1.7 Average Duration by Type
SELECT 
  type,
  AVG(CAST(REGEXP_EXTRACT(duration, r'\d+') AS INT64)) AS avg_duration
FROM `netflixproject-472211.NetflixProject.Netflix_data`
WHERE duration IS NOT NULL
GROUP BY type;

#1.8 Number of Shows per Country and Type
SELECT 
  country,
  type,
  COUNT(*) AS num_shows
FROM `netflixproject-472211.NetflixProject.Netflix_data`
WHERE country IS NOT NULL
GROUP BY country, type
ORDER BY num_shows DESC
LIMIT 20;

#1.9 Top 20 Most Frequent Words in Netflix Titles
WITH words AS (
  SELECT 
    LOWER(TRIM(word)) AS word
  FROM `netflixproject-472211.NetflixProject.Netflix_data`,
       UNNEST(SPLIT(title, ' ')) AS word
  WHERE title IS NOT NULL
)
SELECT 
  word,
  COUNT(*) AS frequency
FROM words
WHERE word != '' 
  AND word NOT IN ('the','and','of','in','a','an','to','with','on','for','at','by','from') -- common stopwords
GROUP BY word
ORDER BY frequency DESC
LIMIT 20;

#1.10 Top Genres by Country
SELECT
  country,
  genre,
  COUNT(*) AS num_shows
FROM `netflixproject-472211.NetflixProject.Netflix_data`,
UNNEST(SPLIT(listed_in, ',')) AS genre
WHERE country IS NOT NULL
GROUP BY country, genre
ORDER BY country, num_shows DESC;

#1.11 Number of Shows Added to Netflix per Year
SELECT
  EXTRACT(YEAR FROM PARSE_DATE('%B %d, %Y', date_added)) AS year_added,
  COUNT(*) AS num_shows
FROM `netflixproject-472211.NetflixProject.Netflix_data`
WHERE date_added IS NOT NULL
GROUP BY year_added
ORDER BY year_added;