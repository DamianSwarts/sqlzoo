-- This tutorial introduces the notion of a join. The database consists of three tables movie , actor and casting .

-- 1.
-- List the films where the yr is 1962 [Show id, title]
SELECT id, title
FROM movie
WHERE yr = 1962

-- 2.
-- Give year of 'Citizen Kane'.
SELECT yr 
FROM movie 
WHERE title = 'Citizen Kane'

-- 3.
-- List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title).
-- Order results by year.
SELECT id, title, yr
FROM movie 
WHERE title LIKE '%Star Trek%'
ORDER BY yr

-- 4.
-- What id number does the actor 'Glenn Close' have?
SELECT id
FROM actor
WHERE name = 'Glenn Close'

-- 5.
-- What is the id of the film 'Casablanca'
SELECT id
FROM movie
WHERE title = 'Casablanca'

-- 6.
-- Obtain the cast list for 'Casablanca'.
SELECT name
FROM actor
JOIN casting ON actor.id = casting.actorid
WHERE movieid = 11768

-- 7.
-- Obtain the cast list for the film 'Alien'
SELECT name
FROM actor
JOIN casting ON actor.id = casting.actorid
WHERE movieid = (SELECT id
                 FROM movie
                 WHERE title = 'Alien')

-- 8.
-- List the films in which 'Harrison Ford' has appeared
SELECT title
FROM movie
JOIN casting ON movie.id = casting.movieid
WHERE actorid = (SELECT id 
                 FROM actor
                 WHERE name = 'Harrison Ford')

-- 9.
-- List the films where 'Harrison Ford' has appeared - but not in the starring role.
SELECT title
FROM movie
JOIN casting ON movie.id = casting.movieid
WHERE actorid = (SELECT id 
                 FROM actor
                 WHERE name = 'Harrison Ford')
AND ord != 1

-- 10.
-- List the films together with the leading star for all 1962 films.
SELECT title, actor.name
FROM movie
JOIN casting ON movie.id = casting.movieid
JOIN actor ON casting.actorid = actor.id
WHERE ord = 1 AND yr = 1962

-- Harder Questions

-- 11.
-- Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies.
SELECT yr, COUNT(title) 
FROM movie 
JOIN casting ON movie.id = casting.movieid
JOIN actor ON casting.actorid = actor.id
WHERE name = 'Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2

-- 12.
-- List the film title and the leading actor for all of the films 'Julie Andrews' played in.
SELECT title, name 
FROM casting
JOIN movie ON casting.movieid = movie.id
JOIN actor ON casting.actorid = actor.id
WHERE ord = 1
AND movie.id IN (SELECT id FROM movie
	             JOIN casting ON casting.movieid = movie.id
	             JOIN actor ON casting.actorid = actor.id
                 WHERE actor.name = 'Julie Andrews')

-- 13.
-- Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles.
SELECT DISTINCT name 
FROM casting
JOIN movie ON casting.movieid = movie.id
JOIN actor ON casting.actorid = actor.id
WHERE actorid IN (SELECT actorid FROM casting
	              WHERE ord = 1
	              GROUP BY actorid
	              HAVING COUNT(actorid) >= 15)
ORDER BY name

-- 14.
-- List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
SELECT title, COUNT(actorid) 
FROM casting
JOIN movie ON movie.id = casting.movieid
WHERE yr = 1978
GROUP BY movieid, title
ORDER BY COUNT(actorid) DESC, title

-- 15.
-- List all the people who have worked with 'Art Garfunkel'.
SELECT DISTINCT name 
FROM casting
JOIN actor ON actor.id = casting.actorid
WHERE name != 'Art Garfunkel'
AND movieid IN (SELECT movieid
		        FROM movie
		        JOIN casting ON movieid = movie.id
		        JOIN actor ON actorid = actor.id
		        WHERE actor.name = 'Art Garfunkel')