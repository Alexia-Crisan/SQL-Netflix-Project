-- Netflix Project

DROP TABLE IF EXISTS netflix;

CREATE TABLE netflix 
(
    show_id VARCHAR(6) PRIMARY KEY,
    type VARCHAR(10),
    title VARCHAR(150),
    director VARCHAR(210),
    casts VARCHAR(1000),
    country VARCHAR(150),
    date_added DATE,
    release_year INT,
    rating VARCHAR(10),
    duration VARCHAR(15),
    listed_in VARCHAR(100),
    description VARCHAR(500)
);

SELECT * FROM netflix;

SELECT COUNT(*) as all_content
FROM netflix;

SELECT DISTINCT type
FROM netflix;

-- 15 Bussines Problems

-- 1. Count the number of Movies vs TV Shows

SELECT type, COUNT(*) as no_movies
FROM netflix
GROUP BY type;

-- 2. Find the most common rating for movies and TV shows

SELECT type, rating
FROM
(
	SELECT type, rating, COUNT(*),
	RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
	FROM netflix
	GROUP BY 1, 2
) as t
WHERE ranking = 1;

-- 3. List all movies released in a specific year (e.g., 2020)

SELECT * FROM netflix
WHERE type = 'Movie' AND release_year = 2020;

-- 4. Find the top 5 countries with the most content on Netflix

SELECT 
	UNNEST(STRING_TO_ARRAY(country, ',')) as new_country, 
    COUNT(show_id) as total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- 5. Identify the longest movie

SELECT *
FROM netflix
WHERE type = 'Movie'
  AND SPLIT_PART(duration, ' ', 1)::INT = 
  (
      SELECT MAX(SPLIT_PART(duration, ' ', 1)::INT)
      FROM netflix
      WHERE type = 'Movie'
  );

