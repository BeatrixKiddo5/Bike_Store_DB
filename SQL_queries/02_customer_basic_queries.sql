--Counting total number of entries in the table:
SELECT COUNT(*) AS total_entries FROM customers;
--There are 1445 entries in this table.

--Counting the number of people having the same name (first and last):
SELECT first_name, last_name, COUNT(*) AS occurence
FROM customers
GROUP BY first_name, last_name
HAVING COUNT(*) >1; -- There are two people having the same name, 'Justina Jenkins'.

--Counting number of NULL entries in phone:
SELECT COUNT(*) AS number_of_nulls FROM customers
WHERE phone = 'NULL'; -- There are 1267 records with no phone number.

--Counting number of nulls in email column:
SELECT COUNT(email) FROM customers
WHERE email LIKE '_null_';-- There are 0 null values in emails.

--Total number of states:
SELECT COUNT(DISTINCT(state)) FROM customers;--There are 3 different states.

--Updating the state variable to contain more than 5 characters:
ALTER TABLE public.customers
	ALTER COLUMN state TYPE VARCHAR(50);
	
--Changing NY to New York and same for the other states:
UPDATE customers
SET state= REPLACE(state, 'NY', 'New York')
WHERE state LIKE 'NY';

UPDATE customers
SET state= REPLACE(state, 'CA', 'California')
WHERE state LIKE 'CA';

UPDATE customers
SET state= REPLACE(state, 'TX', 'Texas')
WHERE state LIKE 'TX';

--Percentage share of each state in the table:
WITH num_entries AS 
(
	SELECT state, COUNT(*) AS fraction FROM customers
	GROUP BY 1
),
total_entries AS
(
	SELECT SUM(fraction) AS total_entries FROM num_entries
)
SELECT state, fraction, ROUND(fraction*100/total_entries, 3) PERCENT
FROM num_entries, total_entries;--New York has 70.5% of entries.

--Number of cities in each state:
SELECT COUNT(DISTINCT(city)), state FROM customers
GROUP BY 2
ORDER BY 1 DESC;-- Maximum cities are in New York(134).

--Percentage share of each city grouped by each state:
WITH num_entries AS 
(
	SELECT state, city, COUNT(*) AS fraction FROM customers
	GROUP BY 2, 1	
),
total_entries AS
(
	SELECT SUM(fraction) AS total_entries FROM num_entries	
)
SELECT city, state, fraction, ROUND(fraction*100/total_entries, 3) PERCENT 
FROM num_entries, total_entries
ORDER BY 4 DESC;-- Mount Vernon of New York has the highest percentage of entries.

--Zip codes for each city for corresponding state:
SELECT zip_code, city, state FROM customers
GROUP BY 1, 2, 3
ORDER BY 3, 1;


