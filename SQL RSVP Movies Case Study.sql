USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
select table_name, table_rows
from information_schema.tables
where table_schema ='imdb';


-- Observation

-- Table_name       | Table_rows
----------------------------------------
-- director_mapping | 3867  
-- genre            | 14662  
-- movie            | 7502  
-- names            | 27035  
-- ratings          | 7927  
-- role_mapping     | 15558  


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

select 
	sum(case when id is null then 1 else 0 end) as id,
    sum(case when title is null then 1 else 0 end) as title,
    sum(case when year is null then 1 else 0 end) as year,
    sum(case when date_published is null then 1 else 0 end) as date_published,
    sum(case when duration is null then 1 else 0 end) as duration,
    sum(case when country is null then 1 else 0 end) as country,
    sum(case when worlwide_gross_income is null then 1 else 0 end) as worlwide_gross_income,
    sum(case when languages is null then 1 else 0 end) as languages,
    sum(case when production_company is null then 1 else 0 end) as production_company
from movie;

/* observation
 
column_name	          |  null_count
-----------------------------------
country	              |    20
worlwide_gross_income |    3724
languages	          |    194
production_company	  |    528
*/

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

-- Type your code below:

select year, count(id) as number_of_movies from movie
group by year
order by year;

select month(date_published) as month_num, count(id) as number_of_movies from movie
group by month_num
order by month_num;


/* Output for the first part of the question:

Year		|	number_of_movies 
--------------------------------
2017		|	3052			 
2018		|	2944	 	 
2019		|	2001	 	 
 
Output for the second part of the question:

month_num	|	number_of_movies
--------------------------------
1			|	 804			
2			|	 640			
3			|	 824			
4			|	 680
5			|	 625			
6			|	 580
7			|	 493	
8			|	 678
9			|	 809		
10			|	 801
11			|	 625		
12			|	 438 					.			
 */


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT  COUNT(id) AS number_of_movies
FROM movie
WHERE (country like '%usa%' OR country like '%india%') 
AND year = 2019;

-- 1059 movies were produced in India and USA in the year 2019

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

select distinct genre from genre;

/* OBSERVATIONS
-- Drama, Fantasy, Thriller, Comedy, Horror, Family, Romance, Adventure, Action, Sci-fi, Crime, Mystery, Others.
-- There are 13 unique genre in the dataset.
*/


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

select g.genre, count(m.id) as num_movies 
from genre g
left join movie m
on g.movie_id=m.id
group by g.genre limit 1;

-- Drama genre the highest number of movies produced i,e, 4285






/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

select count(*) as one_genre_movie  from 
(	select movie_id from genre
	group by movie_id
	having count(*)=1) as t;

-- 3289 movies belong to only one genre

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)
SELECT 
    G.genre, 
    ROUND(AVG(M.duration),2) AS avg_duration
FROM genre G
Inner JOIN movie M
    ON G.movie_id = M.id
GROUP BY G.genre;

/*
genre	  | avg_duration
---------------------
Drama	  |    106.77
Fantasy	  |    105.14
Thriller  |    101.58
Comedy	  |    102.62
Horror	  |    92.72
Family	  |    100.97
Romance	  |    109.53
Adventure |    101.87
Action	  |    112.88
Sci-Fi	  |    97.94
Crime	  |    107.05
Mystery	  |    101.80
Others	  |    100.16

*/

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)

-- Type your code below:

select *, rank() over (order by movie_count desc) as genre_rank
from(  
select genre, count(movie_id) as movie_count
from genre
group by genre) as t;


/* Observation: Thriller genre movies is ranked 3 among all genres in terms of number of movies produced.

genre	 | movie_count|	genre_rank
---------------------------------
Drama	 |   4285	  | 1
Comedy	 |   2412     | 2
Thriller |   1484	  | 3
Action	 |   1289	  | 4
Horror	 |   1208	  | 5
Romance	 |   906	  | 6
Crime	 |   813	  | 7
Adventure|	 591	  | 8
Mystery  |	 555	  | 9
Sci-Fi	 |   375	  | 10
Fantasy	 |   342	  | 11
Family	 |   302	  | 12
Others	 |   100	  | 13
*/


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/


-- Segment 2:


-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?

-- Type your code below:
select 
	min(avg_rating) as min_avg_rating ,
	max(avg_rating) as max_avg_rating,
	min(total_votes) as min_total_votes  ,
	max(total_votes) as max_total_votes ,
	min(median_rating) as min_median_rating ,
	max(median_rating) as max_median_rating
from ratings;


/* observation:
 
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes  |min_median_rating | max_median_rating|
-------------------------------------------------------------------------------------------------------------------------
|		1.0		|		10.0		|	       100		  |	   725138	     |		1	        |	10			   |*/


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?

-- Type your code below:
-- Keep in mind that multiple movies can be at the same rank. You only have to find out the top 10 movies (if there are more than one movies at the 10th place, consider them all.)


SELECT m.title, r.avg_rating, RANK() OVER (ORDER BY r.avg_rating DESC) AS movie_rank
FROM movie AS m
INNER JOIN ratings AS r
ON r.movie_id = m.id
LIMIT 10;

/* observation:

title	                           | avg_rating	     | movie_rank
--------------------------------------------------------------------
Kirket	                           | 10	             | 1
Love in Kilnerry	               | 10	             | 1
Gini Helida Kathe	               | 9.8	         | 3
Runam	                           | 9.7	         | 4
Fan	                               | 9.6	         | 5
Android Kunjappan Version 5.25     | 9.6	         | 5
Yeh Suhaagraat Impossible	       | 9.5	         | 7
Safe	                           | 9.5	         | 7
The Brighton Miracle	           | 9.5	         | 7
Shibu	                           | 9.4             | 10
*/


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
-- Type your code below:
-- Order by is good to have

select 
	median_rating, 
    count(movie_id) as movie_count	
from ratings 
group by median_rating 
order by median_rating;

/* observation:

median_rating	 | movie_count
--------------------------------
    1	         |	94
    2	         |	119
    3	         |	283
	4	         |	479
	5	         |	985
	6	         |	1975
	7	         |	2257
	8	         |	1030
	9	         |	429
	10	         |	346
*/


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
-- Type your code below:

SELECT 
    m.production_company,
    COUNT(m.id) AS movie_count,
    RANK() OVER (ORDER BY COUNT(m.id) DESC) AS prod_company_rank
FROM movie m
INNER JOIN ratings r 
    ON m.id = r.movie_id
WHERE r.avg_rating > 8 AND production_company IS NOT NULL
GROUP BY m.production_company LIMIT 3;


/* Observation - Dream Warrior Pictures and  National Theatre Live both produced the same number of hit movies.

production_company             |  movie_count   |	prod_company_rank
------------------------------------------------------------------------
Dream Warrior Pictures	       |	3		   |			1	  
National Theatre Live          |    3          |            1
Lietuvos Kinostudija           |    2          |            3

*/


-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?

select 
	g.genre, count(m.id) as movie_count 
from movie m
inner join ratings r
	on m.id = r.movie_id
inner join genre g
	on m.id = g.movie_id
where m.year = 2017 and month(m.date_published)=3 and m.country like '%USA%' and r.total_votes>1000
group by g.genre
order by count(m.id) desc;



/* Output format:
genre		| movie_count
---------------------------
Drama		|	24
Comedy		|	9
Action		|	8
Thriller	|	8
Sci-Fi		|	7
Crime		|	6
Horror		|	6
Mystery		|	4
Romance		|	4
Fantasy	    |	3
Adventure	|	3	
Family	    |	1
 */

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?

SELECT title, avg_rating, genre
FROM genre AS g
INNER JOIN ratings AS r
    ON r.movie_id = g.movie_id
INNER JOIN movie AS m
    ON m.id = g.movie_id
WHERE title LIKE 'The%' AND avg_rating > 8
ORDER BY avg_rating DESC;

 /*Observation:
 
 title									|avg_rating	|genre
------------------------------------------------------------------
The Brighton Miracle					|9.5		|	Drama
The Colour of Darkness					|9.1		|	Drama
The Blue Elephant 2						|8.8		|	Drama
The Blue Elephant 2						|8.8		|	Horror
The Blue Elephant 2						|8.8		|	Mystery
The Irishman							|8.7		|	Crime
The Irishman							|8.7		|	Drama
The Mystery of Godliness: The Sequel	|8.5		|	Drama
The Gambinos							|8.4		|	Crime
The Gambinos							|8.4		|	Drama
Theeran Adhigaaram Ondru				|8.3		|	Action
Theeran Adhigaaram Ondru				|8.3		|	Crime
Theeran Adhigaaram Ondru				|8.3		|	Thriller
The King and I							|8.2		|	Drama
The King and I							|8.2		|	Romance
*/

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT median_rating, count(movie_id) AS movie_count
FROM movie AS m
INNER JOIN ratings AS r
ON m.id = r.movie_id
WHERE median_rating = 8 AND date_published BETWEEN '2018-04-1' AND '2019-04-1'
ORDER BY avg_rating DESC;

-- Observation : 361 movies were given 8 median rating


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT country, sum(total_votes) AS total_votes
FROM movie AS mv
INNER JOIN ratings AS ra
ON mv.id = ra.movie_id
WHERE UPPER(country) LIKE 'GERMANY' OR country LIKE 'ITALY' 
GROUP BY country;

/*country | total_votes
--------------------------
-- Germany | 106710 
-- Italy   | 77965
*/

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/


-- Segment 3:



-- Q18. Which columns in the names table have null values??

-- Type your code below:
SELECT
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;

/* Observation
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|		17335		|	       13431		  |	   15226	     |
+---------------+-------------------+---------------------+----------------------+*/


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)

-- Type your code below:

with top_three_genres as (
select g.genre, count(g.movie_id) as total_movie from genre as g
inner join ratings r on g.movie_id=r.movie_id
where r.avg_rating>8
group by g.genre
order by total_movie desc limit 3)

SELECT na.name AS director_name, COUNT(dir.movie_id) AS movie_count FROM director_mapping AS dir 
INNER JOIN genre AS gen USING (movie_id) 
INNER JOIN names AS na ON na.id = dir.name_id 
INNER JOIN ratings AS ra USING (movie_id) 
INNER JOIN top_three_genres USING (genre) 
WHERE avg_rating > 8 
GROUP BY na.name 
ORDER BY movie_count DESC LIMIT 3;


/* Output:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|Anthony Russo  |		3			|
|Soubin Shahir  |		3			|
+---------------+-------------------+ */


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
select distinct name as actor_name,count(rm.movie_id) as movie_count from names n
inner join role_mapping rm on rm.name_id=n.id
inner join ratings r using (movie_id) 
where median_rating>=8 and category='actor' 
group by actor_name 
order by movie_count desc limit 2;

/* Output:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Mammootty	    |		8			|
|Mohanlal		|		5			|
+---------------+-------------------+ */



/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?

select 
	production_company, 
    sum(total_votes) AS vote_count, 
    rank() over(order by sum(total_votes) desc) as prod_comp_rank
from movie m
inner join ratings r on m.id=r.movie_id
group by production_company limit 3;


/* Output:
+------------------+--------------------+-----------------------------+
|production_company     |		vote_count		|		prod_comp_rank|
+------------------+--------------------+-----------------------------+
|Marvel Studios 		|		2656967			|		    1	      |
|Twentieth Century Fox	|		2411163			|			2		  |
|Warner Bros.			|		2396057			|			3	      |
+-------------------+-------------------+-----------------------------+*/


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

SELECT *, RANK() OVER (ORDER BY actor_avg_rating DESC) AS actor_rank
FROM (
    SELECT n.name AS actor_name, SUM(r.total_votes) AS total_votes, COUNT(m.id) AS movie_count, ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes),2) AS actor_avg_rating
    FROM names n
    INNER JOIN role_mapping rm ON rm.name_id = n.id
    INNER JOIN movie m ON m.id = rm.movie_id
    INNER JOIN ratings r ON r.movie_id = m.id
    WHERE rm.category = 'actor' AND m.country = 'India'
    GROUP BY n.name
    HAVING COUNT(m.id) >= 5
) t
ORDER BY actor_avg_rating DESC limit 3;

/* Output:

| actor_name	 |	total_votes		|	movie_count		|	actor_avg_rating 		|actor_rank	   
-------------------------------------------------------------------------------------------------
Vijay Sethupathi | 		23114		| 		5			| 	 8.42					| 1
Fahadh Faasil	 |	 	13557		| 		5			| 	 7.99					| 2
Yogi Babu		 | 		8500		| 		11			|	 7.83					| 3
*/

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

SELECT *, RANK() OVER (ORDER BY actress_avg_rating DESC) AS actress_rank
FROM (
    SELECT n.name AS actress_name, SUM(r.total_votes) AS total_votes, COUNT(m.id) AS movie_count, ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes),2) AS actress_avg_rating
    FROM names n
    INNER JOIN role_mapping rm ON rm.name_id = n.id
    INNER JOIN movie m ON m.id = rm.movie_id
    INNER JOIN ratings r ON r.movie_id = m.id
    WHERE rm.category = 'actress' AND m.country = 'India' and m.languages like '%Hindi%'
    GROUP BY n.name
    HAVING COUNT(m.id) >= 3
) t
ORDER BY actress_avg_rating DESC limit 5;

/* Output:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		|	actress_avg_rating 	|actress_rank	   
--------------------------------------------------------------------------------------------------
Taapsee Pannu		|18061			|3					|	7.74				|		1
Kriti Sanon			|21967			|3					|	7.05				|		2
Divya Dutta			|8579			|3					|	6.88				|		3
Shraddha Kapoor		|26779			|3					|	6.63				|		4
Kriti Kharbanda		|2549			|3					|	4.80				|		5
*/
-- Taapsee Pannu tops with average rating 7.74. 


-- Now let us divide all the thriller movies in the following categories and find out their numbers.*/
/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
*/


select title as movie_name, 
	case when avg_rating > 8 then 'Superhit'
		 when avg_rating between 7 and 8 then 'Hit'
		 when avg_rating between 5 and 7 then 'One-time-watch'
		 when avg_rating < 5 then 'Flop'
	end as movie_category
from ratings r 
inner join movie m on m.id=r.movie_id
inner join genre g using ( movie_id)
WHERE g.genre='thriller' and r.total_votes>=25000
order by avg_rating desc limit 3;

/* Output:

movie_name	|	movie_category	
--------------------------------
Joker		|	Superhit
Andhadhun	|	Superhit
Ah-ga-ssi	|	Superhit
*/

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 

select g.genre, 
	round(avg(m.duration),1) as avg_duration, 
    sum(round(avg(m.duration),1)) over(order by g.genre rows unbounded preceding) as running_total_duration,
    avg(round(avg(m.duration),1)) over(order by g.genre rows 10 preceding) as moving_avg_duration
from movie m
inner join genre g on g.movie_id=m.id
group by g.genre
order by g.genre;
   
   

    
/* Output:

| genre			|	avg_duration	|running_total_duration |moving_avg_duration  
----------------------------------------------------------------------------------
Action			|112.9				|112.9					|112.9
Adventure		|101.9				|214.8					|107.4
Comedy			|102.6				|317.4					|105.8
Crime			|107.1				|424.5					|106.1
Drama			|106.8				|531.3					|106.3
Family			|101.0				|632.3					|105.4
Fantasy			|105.1				|737.4					|105.3
Horror			|92.7				|830.1					|103.8
Mystery			|101.8				|931.9					|103.5
Others			|100.2				|1032.1					|103.2
Romance			|109.5				|1141.6					|103.8
Sci-Fi			|97.9				|1239.5					|102.4
Thriller		|101.6				|1341.1					|102.4
*/


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

WITH top_3_genre AS (
    SELECT genre, COUNT(movie_id) AS movie_count FROM genre
    GROUP BY genre
    ORDER BY movie_count DESC LIMIT 3),
    
top_5_movie AS (
    SELECT 
		g.genre, 
        m.year, 
        m.title AS movie_name, 
        m.worldwide_gross_income, 
        ROW_NUMBER() OVER (PARTITION BY m.year ORDER BY m.worldwide_gross_income DESC) AS movie_rank FROM movie m
    INNER JOIN genre g ON m.id = g.movie_id
    INNER JOIN top_3_genre t ON g.genre = t.genre)

SELECT * FROM top_5_movie
WHERE movie_rank <= 5;

/* Output format:

| genre			|	year			|	movie_name		 			|worldwide_gross_income	|	movie_rank	   
-------------------------------------------------------------------------------------------------------
Drama				2017				Shatamanam Bhavati			INR 530500000					1
Drama				2017				Winner						INR 250000000					2
Drama				2017				Thank You for Your Service	$ 9995692						3
Comedy				2017				The Healer					$ 9979800						4
Drama				2017				The Healer					$ 9979800						5
Thriller			2018				The Villain					INR 1300000000					1
Drama				2018				Antony & Cleopatra			$ 998079						2
Comedy				2018				La fuitina sbagliata		$ 992070						3
Drama				2018				Zaba						$ 991							4
Comedy				2018				Gung-hab					$ 9899017						5
Thriller			2019				Prescience					$ 9956							1
Thriller			2019				Joker						$ 995064593						2
Drama				2019				Joker						$ 995064593						3
Comedy				2019				Eaten by Lions				$ 99276							4
Comedy				2019				Friend Zone					$ 9894885						5
*/


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?

SELECT production_company,
		COUNT(m.id) AS movie_count,
        ROW_NUMBER() OVER(ORDER BY count(id) DESC) AS prod_comp_rank
FROM movie AS m 
INNER JOIN ratings AS r 
ON m.id=r.movie_id
WHERE median_rating>=8 AND production_company IS NOT NULL AND POSITION(',' IN languages)>0
GROUP BY production_company
LIMIT 2;


/* Output:

|production_company 	|movie_count		|	prod_comp_rank
-----------------------------------------------------------------
Star Cinema				|7					|		1
Twentieth Century Fox	|4					|		2
*/

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?

-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)

SELECT * FROM (
    SELECT n.name as actress_name,
        SUM(r.total_votes) AS total_votes,
        COUNT(rm.movie_id) AS movie_count,
        ROUND(AVG(r.avg_rating), 2) AS actress_avg_rating,
        DENSE_RANK() OVER (ORDER BY AVG(r.avg_rating) DESC) AS actress_rank
    FROM names AS n
    INNER JOIN role_mapping AS rm ON n.id = rm.name_id
    INNER JOIN ratings AS r ON r.movie_id = rm.movie_id
    INNER JOIN genre AS g ON g.movie_id = rm.movie_id
    WHERE rm.category = 'actress' AND g.genre = 'drama'
    GROUP BY n.name) t
WHERE actress_avg_rating > 8 LIMIT 3;




/* Output format:

| actress_name		|	total_votes	|	movie_count	    |actress_avg_rating 	|actress_rank	
------------------------------------------------------------------------------------------------------
Sangeetha Bhat		|1010			|		1			|	9.60				|		1
Fatmire Sahiti		|3932			|		1			|	9.40				|		2
Pranati Rai Prakash	|897			|		1			|	9.40				|		2   
*/










/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations*/

WITH movie_date_info AS (
    SELECT 
        d.name_id,
        n.name,
        d.movie_id,
        m.date_published,
        LEAD(m.date_published) OVER (PARTITION BY d.name_id ORDER BY m.date_published, d.movie_id) AS next_movie_date
    FROM director_mapping d
    JOIN names n ON d.name_id = n.id
    JOIN movie m ON d.movie_id = m.id),

date_difference AS (
    SELECT 
        name_id,
        DATEDIFF(next_movie_date, date_published) AS diff FROM movie_date_info
    WHERE next_movie_date IS NOT NULL),

avg_inter_days AS (
    SELECT 
        name_id,
        ROUND(AVG(diff)) AS avg_inter_movie_days FROM date_difference
    GROUP BY name_id
),

final_result AS (
    SELECT
        d.name_id AS director_id,
        n.name AS director_name,
        COUNT(d.movie_id) AS number_of_movies,
        a.avg_inter_movie_days,
        ROUND(AVG(r.avg_rating), 2) AS avg_rating,
        SUM(r.total_votes) AS total_votes,
        MIN(r.avg_rating) AS min_rating,
        MAX(r.avg_rating) AS max_rating,
        SUM(m.duration) AS total_duration
    FROM director_mapping d
    JOIN names n ON n.id = d.name_id
    JOIN movie m ON m.id = d.movie_id
    JOIN ratings r ON r.movie_id = d.movie_id
    JOIN avg_inter_days a ON a.name_id = d.name_id
    GROUP BY d.name_id, n.name, a.avg_inter_movie_days)

SELECT * FROM final_result LIMIT 9;

/*Output:

| director_id	|	director_name		|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration 
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+--------------------
nm0478713	    |Jean-Claude La Marre	|	3				  |		385				|		3.17	|	1280		|	2.4		|	4.1		 |		276
nm6356309		|Özgür Bakar			|	4				  |		112				|		3.75	|	1092		|	3.1		|	4.9		 |		374
nm0393394		|Christophe Honoré		|	2				  |		201				|		6.60	|	2501		|	6.4		|	6.8		 |		218
nm4899218	 	|Justin Lee				|	3				  |		180				|		4.90	|	831			|	3.0		|	6.7		 |		304
nm0006395	 	|Michael Feifer			|	2				  |		322				|		4.30	|	391			|	3.5		|	5.1		 |		169
nm5662493	 	|Doga Can Anafarta		|	2				  |	    588				|		4.45	|	7085		|	3.4		|	5.5		 |		208
nm0637615	 	|Gaspar Noé				|	2				  |	    239				|		7.05	|	33822		|	7.0		|	7.1		 |		147
nm1164755		|Xavier Gens			|	2		 		  |		250				|		5.65	|	11668		|	5.3		|	6.0		 |		210
nm1373966		|Sean King				|	2				  |	    774				|		4.80	|	222			|	4.4		|	5.2		 |		144
*/







