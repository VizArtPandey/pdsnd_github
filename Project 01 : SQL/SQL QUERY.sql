---------------------------------------------------------------------------------------------------------

/* QUERY 01 - QUERY USED FOR THE FIRST INSIGHT */

---------------------------------------------------------------------------------------------------------
WITH rental_db
     AS (SELECT title,
                NAME,
                rental_id
         FROM   category c
                JOIN film_category fc
                  ON c.category_id = fc.category_id
                JOIN film f
                  ON fc.film_id = f.film_id
                JOIN inventory i
                  ON i.film_id = f.film_id
                JOIN rental r
                  ON r.inventory_id = i.inventory_id
         WHERE  NAME IN ( 'Animation', 'Children', 'Classics', 'Comedy',
                          'Family', 'Music' ))
SELECT 
       NAME  AS category_name,
       Count(rental_id) as rental_id
FROM   rental_db
GROUP  BY 1,
          2
ORDER  BY 2 DESC

---------------------------------------------------------------------------------------------------------

/* QUERY 02- QUERY USED FOR THE SECOND INSIGHT */

---------------------------------------------------------------------------------------------------------

WITH rental_db
     AS (SELECT title,
                NAME,
                rental_duration
         FROM   category c
                JOIN film_category fc
                  ON c.category_id = fc.category_id
                JOIN film f
                  ON fc.film_id = f.film_id
         WHERE  NAME IN ( 'Animation', 'Children', 'Classics', 'Comedy',
                          'Family', 'Music' ))
SELECT DISTINCT title,
       NAME,
       rental_duration,
       Ntile(4)
         OVER (
           ORDER BY rental_duration ASC ) AS standard_quartile
FROM   rental_db
ORDER  BY 3 

---------------------------------------------------------------------------------------------------------

/* QUERY 03 - QUERY USED FOR THE THIRD INSIGHT */

---------------------------------------------------------------------------------------------------------
WITH rental_db
     AS (SELECT NAME,
                Ntile(4)
                  OVER (
                    ORDER BY rental_duration ASC ) AS quartile
         FROM   category c
                JOIN film_category fc
                  ON c.category_id = fc.category_id
                JOIN film f
                  ON fc.film_id = f.film_id
         WHERE  NAME IN ( 'Animation', 'Children', 'Classics', 'Comedy',
                          'Family', 'Music' ))
SELECT NAME AS category_name,
       quartile,
       Count(NAME)
FROM   rental_db
GROUP  BY 1,
          2
ORDER  BY 1,
          2 
---------------------------------------------------------------------------------------------------------

/* QUERY 04 - QUERY USED FOR THE FOURTH INSIGHT */

---------------------------------------------------------------------------------------------------------

   SELECT s.store_id                          AS Store_ID,
       Extract(isoyear FROM r.rental_date) AS Rental_year,
       Extract(month FROM r.rental_date)   AS Rental_month,
       Count(r.rental_id)                  AS Count_rentals
FROM   rental r
       JOIN staff using (staff_id)
       JOIN store s using (store_id)
GROUP  BY 1,
          2,
          3
ORDER  BY 4 DESC,
          1,
          2,
          3;        

---------------------------------------------------------------------------------------------------------