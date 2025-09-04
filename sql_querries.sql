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
    date_added VARCHAR(55),
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
LIMIT 5;

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
  
 -- 6. Find content added in the last 5 years

SELECT *  FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'

SELECT * FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';

-- 8. List all TV shows with more than 5 seasons

SELECT * FROM netflix
WHERE type = 'TV Show' AND SPLIT_PART(duration, ' ', 1)::INT > 5;

-- 9. Count the number of content items in each genre

SELECT
	UNNEST(STRING_TO_ARRAY(listed_in, ', ')) as category, 
    COUNT(show_id) as total_content
FROM netflix
GROUP BY 1
ORDER BY 1;

-- 10.Find each year and the average numbers of content release in India on netflix.

SELECT 
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
	COUNT(*) as yearly_content,
	round(COUNT(*)::numeric / (SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric * 100, 2) as avg_content
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY 2 DESC;

-- 11. List all movies that are documentaries

SELECT * FROM netflix
WHERE listed_in ILIKE '%Documentaries%';

-- 12. Find all content without a director

SELECT * FROM netflix
WHERE director is NULL;

-- 13. Find how many movies actor 'Julie Tejwani' appeared in last 10 years

SELECT * FROM netflix
WHERE casts ILIKE '%Julie Tejwani%' AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India

SELECT 
	UNNEST(STRING_TO_ARRAY(casts, ', ')) as actors,
	COUNT(*) as total_content
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in  the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.