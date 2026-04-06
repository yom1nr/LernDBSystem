SELECT * FROM actor;

SELECT city_id, city, country_id 
FROM city 
WHERE country_id = 44 
LIMIT 10;

SELECT * FROM city 
WHERE city LIKE '%city';

SELECT * FROM rental 
WHERE return_date BETWEEN '2005-05-25' AND  '2005-05-27' 
ORDER BY return_date ASC 
LIMIT 5;

SELECT SUM(amount) 
FROM payment 
WHERE customer_id = 1;

SELECT COUNT(*) 
FROM film_text;

SELECT COUNT(*) 
FROM customer 
WHERE first_name LIKE 'A%' OR first_name LIKE '%A';

SELECT rating, AVG(length) AS avg_length 
FROM film 
GROUP BY rating;

SELECT customer_id, staff_id, MAX(amount) AS rental_amount 
FROM payment 
GROUP BY customer_id, staff_id 
HAVING rental_amount > 10 
ORDER BY staff_id DESC;