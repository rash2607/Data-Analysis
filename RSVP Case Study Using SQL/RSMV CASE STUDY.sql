USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT Count(*) AS number_of_rows
FROM   director_mapping;

-- THE NUMBER OF ROWS IN DIRECTOR MAPPING : 3867 
SELECT Count(*) AS number_of_rows
FROM   genre;

-- THE NUMBER OF ROWS IN genre : 14662 
SELECT Count(*) AS number_of_rows
FROM   movie;

-- THE NUMBER OF ROWS IN movie : 7997 
SELECT Count(*) AS number_of_rows
FROM   names;

-- THE NUMBER OF ROWS IN names : 25735 
SELECT Count(*) AS number_of_rows
FROM   ratings;

-- THE NUMBER OF ROWS IN ratings : 7997 
SELECT Count(*) AS number_of_rows
FROM   role_mapping;
-- THE NUMBER OF ROWS IN role_mapping : 15615


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT id
FROM   movie
WHERE  id IS NULL;

SELECT title
FROM   movie
WHERE  title IS NULL;

SELECT year
FROM   movie
WHERE  year IS NULL;

SELECT date_published
FROM   movie
WHERE  date_published IS NULL;

SELECT duration
FROM   movie
WHERE  duration IS NULL;

SELECT country
FROM   movie
WHERE  country IS NULL;

SELECT worlwide_gross_income
FROM   movie
WHERE  worlwide_gross_income IS NULL;

SELECT languages
FROM   movie
WHERE  languages IS NULL;

SELECT production_company
FROM   movie
WHERE  production_company IS NULL; 

-- CONCLUSION 
-- COLUMNS HAVING NULL VALUES:
		-- COUNTRY
		-- WORLWIDE_GROSS_INCOME
        -- LANGUAGES
        -- PRODUCTION_COMPANY


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT year,
                Count(id) AS number_of_movies
FROM   movie
GROUP  BY year; 

-- CONCLUSION  
 -- MOST NUMBER OF MOVIES ARE RELEASED IN YEAR 2017 AROUND 3052
--  LEAST NUMBER OF MOVIES ARE RELEASED IN YEAR 2019 AROUND 2001

  SELECT Month (date_published) AS month_num,
       Count(id)              AS number_of_movie
FROM   movie
GROUP  BY month_num
ORDER  BY month_num; 
-- CONCLUSION  
-- MARCH HAS THE HIGHEST NUMBER OF MOVIES  FOLLOWED BY SEPTEMBER AND  JANNUARY 
    
/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT Count(*),
       year
FROM   movie
WHERE  year = 2019
       AND ( country LIKE '%USA%'
              OR country LIKE '%India%' );
              
-- CONCLUSION 
-- SINCE, AS PER THE QUESTION IT SAYS USA OR INDIA THEREFORE WE HAVE TO TAKE LIKE CONDITION, 
-- 1059 MOVIES IS THE EXACT NUMBER WERE PRODUCED IN THE USA OR INDIA IN THE YEAR 2019 
            
/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:


SELECT DISTINCT genre
FROM   genre; 

-- CONCLUSION 
-- MOVIES BELONG TO 13 GENRES ARE MENTIONED IN THE DATASET.

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */


-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre,
       Count(movie_id) AS number_of_movie
FROM   genre
GROUP  BY genre
ORDER  BY number_of_movie DESC
LIMIT  1; 

-- CONCLUSION 
	-- DRAMA HAS THE HIGHEST NUMBER OF MOVIES FOLLOWED BY COMEDY AND TRILLER

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/


-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH count_movies_genre
     AS (SELECT movie_id
         FROM   genre
         GROUP  BY movie_id
         HAVING Count(DISTINCT genre) = 1)
SELECT Count(*) AS movies_one_genre
FROM   count_movies_genre;

-- CONCLUSION 
	-- 3289 IS THE EXACT NUMBER OF MOVIES HAS ONLY ONE GENRE

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/


-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT genre,
       Round(Avg(duration), 2) AS avg_duration
FROM   movie AS m
       INNER JOIN genre AS g
               ON m.id = g.movie_id
GROUP  BY genre
ORDER  BY avg_duration DESC; 

/* CONCLUSION:-
ACTION HAS THE  AVERAGE_DURATION OF 112.88 MINS FOLLOWED.*/

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/


-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH genre_rank
     AS (SELECT genre,
                Count(movie_id)                     AS movie_count,
                Rank ()
                  over (
                    ORDER BY Count(movie_id) DESC ) AS genre_rank
         FROM   genre
         GROUP  BY genre)
SELECT *
FROM   genre_rank
WHERE  genre = 'thriller'; 

/*
CONCLUSION:- 
 Thriller has the movie count of 1484 with 3  rank .*/

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/


-- Segment 2:



-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT Min(avg_rating)    AS min_avg_rating,
       Max(avg_rating)    AS max_avg_rating,
       Min(total_votes)   AS min_total_votes,
       Max(total_votes)   AS max_total_votes,
       Min(median_rating) AS median_rating,
       Max(median_rating) AS max_median_rating
FROM   ratings;

-- CONCLUSION 
-- minimum value for avgerage rating is 1 and maximum is 10
-- for total votes minimum value is 100 and maximum is 725138
-- minimum value for median rating is 1 and maximum is 10


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/



-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH avg_movie_rank
     AS (SELECT title,
                avg_rating,
                Dense_rank()
                  OVER (
                    ORDER BY avg_rating DESC) AS movie_rank
         FROM   movie AS M
                INNER JOIN ratings AS R
                        ON M.id = R.movie_id
         ORDER  BY avg_rating DESC)
SELECT *
FROM   avg_movie_rank
WHERE  movie_rank <= 10;

/* CONCLUSION:- 
	KIRKET AND LOVE IN KILNERRY HAVE THE HIGHEST RATING OF 10 ARE AT 1ST RANK FOLLWED BY Gini Helida Kathe AND Runam with second and Thrird rank*
    and yes we found the movie FAN with top avg_rating 9.6*/


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating,
       Count(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY movie_count DESC;

-- CONCLUSION  
-- MOVIE OF MEDIAN RATING 7 IS THE HIGHEST WITH MOVIE COUNT OF 2257.


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH most_number_of_hit_movies AS 
(
SELECT 
	production_company,
	COUNT(id) as movie_count,
    DENSE_RANK() over (order by count(id) desc) as  prod_company_rank
FROM 
	movie as m 
    inner join 
    ratings as r 
    on m.id = r.movie_id
WHERE 
avg_rating > 8 
and 
production_company is not null
GROUP BY 
production_company
)
SELECT *
FROM 
	most_number_of_hit_movies
WHERE 
	prod_company_rank = 1;
    
/* CONCLUSION
 'DREAM WARRIOR PICTURES' AND NATIONAL THEATRE AS PRODUCED THE MOST NUMBER OF HIT MOVIES WITH AVERAGE RATING GREATER THAN 8 .*/

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre,
	count(m.id) as movie_count
FROM genre g 
	inner join movie m 
	on g.movie_id = m.id
    INNER join ratings r 
    ON m.id = r.movie_id
WHERE 
	m.country like '%USA%'
    AND 
    YEAR = 2017 and month(m.date_published)=3
    AND
    r.total_votes > 1000
GROUP BY 
	g.genre
ORDER BY 
	movie_count desc;

 /* CONSLUSION  
-- WE ARE USING COUNTRY LIKE '%USA%' BECAUSE AS THE QUESTION  SAYS "IN", IF IT HAD SAID ONLY IN USA THE CONDITION WOULD HAVE CHANGED.
SO WE PER THE QUESTION DRAMA HAS THE HIGHEST MOVIE_COUNT IN 2017 AND IN THE MONTH OF MARCH AND WITH MORE THAN 1000 VOTES 

-- Lets try to analyse with a unique problem statement.

-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT title, avg_rating, genre
FROM movie AS m
INNER JOIN ratings AS r
ON m.id = r.movie_id
INNER JOIN genre AS g
ON r.movie_id = g.movie_id
WHERE title LIKE 'The%' AND avg_rating>8
ORDER BY avg_rating DESC;
/*-- CONCLUSION 
	DRAMA GENRE HAS THE HIGHEST AVG_RATING OF 9.5 WHICH STARTS WITH THE LETTER  "THE"*/

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT median_rating, count(id) AS `count`
FROM movie AS m
INNER JOIN ratings AS r
ON m.id = r.movie_id
WHERE date_published BETWEEN '2018-04-01' AND '2019-04-01'
AND median_rating=8;

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT country, SUM(total_votes) AS total_votes
 FROM movie AS m 
 INNER JOIN ratings AS r
 ON m.id = r.movie_id
 WHERE country in ('Germany','Italy')
 GROUP BY country;
 /*CONCLUSION
--  --SINCE WE HAVE CHECKED USING BOTH COUNTRY  IN THIS  CASES WE CAN  CONCLUDE THAT GERMANY HAS MORE VOTES THAN ITALY.*/

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT Sum(CASE
             WHEN NAME IS NULL THEN 1
             ELSE 0
           END) AS name_nulls,
       Sum(CASE
             WHEN height IS NULL THEN 1
             ELSE 0
           END) AS height_nulls,
       Sum(CASE
             WHEN date_of_birth IS NULL THEN 1
             ELSE 0
           END) AS date_of_birth_nulls,
       Sum(CASE
             WHEN known_for_movies IS NULL THEN 1
             ELSE 0
           END) AS known_for_movies_nulls
FROM names;
/* CONCLUSION 
	- TOTAL NUMBER OF NULLS IN NAME COLUMN IS 0
    - TOTAL NUMBER OF NULLS IN HEIGHT COLUMN IS 17335 
    - TOTAL NUMBER OF NULLS IN DATE_OF_BIRTH COLUMN IS 13431
    - TOTAL NUMBER OF NULLS IN KNOWN_FOR_MOVIES COLUMN IS 15226
*/		

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH genre_movie_count
AS
  (
             SELECT     genre,
                        count(movie_id) AS movie_count
             FROM       genre           AS g
             INNER JOIN ratings         AS r
             USING      (movie_id)
             WHERE      avg_rating > 8
             GROUP BY   genre
             ORDER BY   count(movie_id) DESC
             LIMIT      3 ), directors_name_rank
AS
  (
             SELECT     n.name,
                        count(dm.movie_id)                            AS movie_count,
                        rank() over(ORDER BY count(dm.movie_id) DESC)    dict_rank
             FROM       names n
             INNER JOIN director_mapping dm
             ON         n.id = dm.name_id
             INNER JOIN ratings r
             ON         r.movie_id = dm.movie_id
             INNER JOIN genre g
             ON         g.movie_id = dm.movie_id
             WHERE      r.avg_rating > 8
             AND        genre IN
                        (
                               SELECT genre
                               FROM   genre_movie_count)
             GROUP BY   name
             ORDER BY   movie_count DESC )
  SELECT name AS director_name,
         movie_count
  FROM   directors_name_rank
  WHERE  dict_rank <= 3;
  
  -- CONCLUSION 
-- 	- JAMES MANGOLD HAS THE MOST NUMBER OF MOVIE COUNT WITH AVERAGE MOVIE RATING OF ABOVE 8 
--  - FOLLOWED BY ANTHONY RUSSO 3 AND JOE RUSSO 3  

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH top_two_actors
     AS (SELECT n.NAME                              AS actor_name,
                Count(r.movie_id)                   AS movie_count,
                Rank()
                  OVER(
                    ORDER BY Count(r.movie_id)DESC) AS movie_rank
         FROM   names AS n
                INNER JOIN role_mapping AS rm
                        ON n.id = rm.name_id
                INNER JOIN ratings AS r
                        ON r.movie_id = rm.movie_id
         WHERE  category = 'actor'
                AND r.median_rating >= 8
         GROUP  BY actor_name)
SELECT actor_name,
       movie_count
FROM   top_two_actors
WHERE  movie_rank <= 2; 

/* CONCLUSION 
	- MAMMOOTTY IS AMONG THE TOP ACTOR WITH MOVIE COUNT OF 8 AND MEDIAN RATING >= 8
    - FOLLOWED BY MOHANLAL WITH MOVIE_COUNT 5
*/


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT DISTINCT production_company, sum(total_votes) total_votes,
RANK() OVER(ORDER BY  sum(total_votes) DESC) AS prod_comp_rank
FROM movie AS m
INNER JOIN ratings AS r
ON m.id = r.movie_id
GROUP BY production_company 
LIMIT 3;

/* CONCLUSION
	- MARVEL STUDIOS AMONG THE TOP PRODUCTION COMPANY WITH TOTAL VOTE COUNT OF 2656967 
	- FOLLOWED BY TWENTIETH CENTURY FOX 2411163 AND WARNER BROS. 2396057
    - SINCE NULL VALUES WERE FOUND SO REMOVED IT.
*/

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT NAME
       AS
       actor_name,
       Sum(total_votes)
       AS total_votes,
       Count(DISTINCT movie_id)
       AS movie_count,
       Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2)
       AS actor_avg_rating,
       Dense_rank()
         OVER (
           ORDER BY Round(Sum(avg_rating*total_votes)/Sum(total_votes), 2) DESC)
       AS
       actor_rank
FROM   names n
       JOIN role_mapping rm
         ON n.id = rm.name_id
       JOIN ratings r using(movie_id)
       JOIN movie m
         ON m.id = r.movie_id
WHERE  rm.category = "actor"
       AND m.country = "india"
GROUP  BY actor_name
HAVING movie_count >= 5
ORDER  BY actor_rank; 

/* CONCLUSION
	- Vijay Sethupathi is among top actor in India with actor average rating of 8.42 and total votes of 23115
    - Naseeruddin shah and Anandraj have same average rating of 6.54 but Naseeruddin shah is above him because total votes are more than anandraj.
    - Same goes for Siddique , Aju Varghese,Biju Menon,Mahesh Achanta,
*/

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT
	name actress_name, SUM(total_votes) total_votes, COUNT(m.id) movie_count, 
    ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2)  actress_avg_rating,  
    RANK() OVER(ORDER BY ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) DESC) actress_rank
FROM
	movie m
INNER JOIN
	ratings r
ON
	m.id=r.movie_id
INNER JOIN 
	role_mapping rm
ON 
	m.id=rm.movie_id
INNER JOIN
	names n
ON 
	rm.name_id=n.id
WHERE
	UPPER(category) = 'ACTRESS' AND UPPER(country) = 'INDIA' AND UPPER(languages) LIKE '%HINDI%'
GROUP BY
	name
HAVING COUNT(m.id)>=3
LIMIT 5;

/* CONCLUSION 
	- TAPSEE PANNU IS AMONG TOP ACTRESS IN INDIA  WITH HINDI LANGUAGE AND ACTRESS AVERAGE RATING OF 7.74 AND TOTAL VOTES OF 18061
*/

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT m.title, genre, avg_rating,
CASE 
WHEN avg_rating > 8 THEN 'Superhit Movie'
WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit Movie'
WHEN avg_rating BETWEEN 5 AND 7  THEN 'One-time-watch Movie'
WHEN avg_rating < 5 THEN 'Flop Movie'
END
AS Movie_Category
FROM movie AS m
INNER JOIN ratings AS r
ON m.id = r.movie_id
INNER JOIN genre AS g
ON m.id = g.movie_id
WHERE genre = 'Thriller';

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

WITH genre_info AS (
SELECT genre, ROUND(AVG(duration), 2) AS avg_duration 
FROM genre AS g 
LEFT JOIN movie AS m 
ON g.movie_id = m.id 
GROUP BY genre 
)
SELECT *, SUM(avg_duration) OVER (ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration, AVG(avg_duration) OVER (ORDER BY genre ROWS UNBOUNDED PRECEDING) AS moving_avg_duration 
FROM genre_info;

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top_3_genre_count
AS
  (
           SELECT   genre,
                    count(id) AS movie_count
           FROM     movie m
           JOIN     genre g
           ON       m.id = g.movie_id
           GROUP BY genre
           ORDER BY movie_count DESC
           LIMIT    3 ), top_5_gross_movies
AS
  (
           SELECT   genre,
                    year,
                    title                                                                       AS movie_name,
                    worlwide_gross_income                                                       AS worldwide_gross_income,
                    row_number () over (partition BY year ORDER BY worlwide_gross_income DESC ) AS movie_rank
           FROM     movie m
           JOIN     genre g
           ON       m.id = g.movie_id
           WHERE    genre IN
                    (
                           SELECT genre
                           FROM   top_3_genre_count ))
  SELECT *
  FROM   top_5_gross_movies
  WHERE  movie_rank <=5;

/*
CONCLUSION   
WE HAVE USED ROW_NUMBER BECASUE AS PER THE QUESTION HIGHEST-GROSSING MOVIES OF "EACH YEAR"  THEREFORE ROW NUMBER WILL BE BETTER THAN RANK OR 
DENSE RANK
*/

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH prod_comp_summary
     AS (SELECT production_company,
                Count(id)                    AS movie_count,
                Row_number ()
                  over (
                    ORDER BY Count(id) DESC) AS prod_comp_rank
         FROM   movie m
                join ratings r
                  ON m.id = r.movie_id
         WHERE  median_rating >= 8
                AND Position(',' IN languages) > 0
                AND production_company IS NOT NULL
         GROUP  BY production_company)
SELECT *
FROM   prod_comp_summary
WHERE  prod_comp_rank <= 2; 

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH top_3_actress
AS
  (
           SELECT   n.name                     AS actress_name,
                    sum(r.total_votes)         AS total_votes,
                    count(DISTINCT r.movie_id) AS movie_count,
                    round(avg(avg_rating), 2)  AS actress_avg_rating,
                    dense_rank () over (ORDER BY count(DISTINCT
                    CASE
                             WHEN avg_rating > 8 THEN rm.movie_id
                    end) DESC) AS actress_rank
           FROM     names n
           JOIN     role_mapping rm
           ON       n.id = rm.name_id
           JOIN     ratings r
           ON       r.movie_id = rm.movie_id
           JOIN     genre g
           ON       g.movie_id = r.movie_id
           WHERE    avg_rating > 8
           AND      category = 'actress'
           AND      genre = 'drama'
           GROUP BY actress_name
           ORDER BY actress_avg_rating DESC )
  SELECT *
  FROM   top_3_actress
  WHERE  actress_rank = 1
  LIMIT  3 ;

/* -- CONCLUSION :-
			TOP 3 ACTRESSES BASED ON NUMBER OF SUPER HIT MOVIES AMANDA LAWRENCE,DENISE GOUGH,SUSAN BROWN */	
            
/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH summary_moives_date
AS
  (
           SELECT   d.name_id,
                    n.name,
                    d.movie_id,
                    duration,
                    r.avg_rating,
                    r.total_votes,
                    m.date_published,
                    lead(date_published, 1) over (partition BY d.name_id ORDER BY m.date_published, d.name_id DESC ) AS next_movie_date
           FROM     director_mapping d
           JOIN     names n
           ON       d.name_id = n.id
           JOIN     movie m
           ON       m.id = d.movie_id
           JOIN     ratings r
           ON       r.movie_id = m.id ), days_diff_table
AS
  (
         SELECT *,
                datediff(next_movie_date, date_published ) AS days_diff -- adding the column for date difference
         FROM   summary_moives_date )
  SELECT   name_id                  AS director_id,
           name                     AS director_name,
           count(movie_id)          AS number_of_movies,
           round(avg(days_diff), 0) AS avg_inter_movie_days,
           round(avg(avg_rating),2) AS avg_rating,
           sum(total_votes)         AS total_votes ,
           min(avg_rating)          AS min_rating ,
           max(avg_rating)          AS max_rating ,
           sum(duration)            AS total_duration
  FROM     days_diff_table
  GROUP BY director_id
  ORDER BY number_of_movies DESC ,
           total_duration DESC
  LIMIT    9 ;
  
  /* CONCLUSION 
	A.L VIJAY ABD ANDREW JONES ARE THE DIRECTORS WHICH  HAVE THE HIGHEST NUMBER FOR MOVIES. 
                                                                                            */





