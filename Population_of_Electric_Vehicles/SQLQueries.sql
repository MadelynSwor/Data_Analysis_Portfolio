/*
	SQL Queries for the Electric Vehicle Population in Washington State
*/
-----------------------------------------------------------------------------------------
-- 1.) Find how many distinct makes there are?

SELECT DISTINCT(make)
FROM electric_vehicle_population;

-----------------------------------------------------------------------------------------
-- 2.) How many vehicles are there for each make?

SELECT make, COUNT(*) AS count_make
FROM electric_vehicle_population
GROUP BY make
ORDER BY COUNT(*) DESC;

-----------------------------------------------------------------------------------------
-- 3.) What 5 counties have the most registered electric vehicles?

SELECT county, COUNT(*) AS total_for_county
FROM electric_vehicle_population
GROUP BY county
ORDER BY COUNT(*) DESC
OFFSET 0 ROWS FETCH FIRST 5 ROWS ONLY;

-- Note King is the top county, the next 2 counties border King. King contains Seattle.
-- Clark covers the city Vancouver, which is near Portland Oreagon. Thurston borders
-- Pierce County.

-----------------------------------------------------------------------------------------
-- Washington State has 2,977,074 registered cars.
-- 4.) What Percentage of of registered cars are electric vehicles?

SELECT ROUND(COUNT(*)*1.0/2977074*100.0,1) AS percentage_EV -- *1.0 to ensure decimal division
FROM electric_vehicle_population;

-----------------------------------------------------------------------------------------
-- 5.) What percentage of electric vehicles are BEVs or PHEVs?

SELECT electric_vehicle_type, COUNT(*) AS total, COUNT(*)/143596.0*100.0 AS percent_total
FROM electric_vehicle_population
GROUP BY electric_vehicle_type
ORDER BY COUNT(*) DESC;

-----------------------------------------------------------------------------------------
-- 6.) How many models does each make have?

SELECT make, COUNT(DISTINCT(model)) AS model_count
FROM electric_vehicle_population
GROUP BY make
ORDER BY COUNT(DISTINCT(model)) DESC;

-----------------------------------------------------------------------------------------
-- 7.) What's the oldest model year for each make in WA?

SELECT make, MIN(model_year) AS oldest_model_year
FROM electric_vehicle_population
WHERE electric_vehicle_type LIKE '%BEV%'
GROUP BY make
ORDER BY MIN(model_year) ASC;

/* Interesting looking at older models. May have to research more about these older BEVs
select make, model_year, model
from electric_vehicle_population 
WHERE electric_vehicle_type LIKE '%BEV%' AND model_year < 2003 */

-----------------------------------------------------------------------------------------
-- 8.) What's the distribution of vehicles by model year?

SELECT model_year, COUNT(*) AS total_per_model_year
FROM electric_vehicle_population
WHERE model_year != 2024 -- Get rid of early releases 
GROUP BY model_year
ORDER BY model_year DESC;

-----------------------------------------------------------------------------------------
-- 9.) How many cars are eligible for CAFV tax exemption?

SELECT clean_alternative_fuel_vehicle_eligibility, COUNT(*) as total
FROM electric_vehicle_population
WHERE clean_alternative_fuel_vehicle_eligibility != 'Unknown'
GROUP BY clean_alternative_fuel_vehicle_eligibility
ORDER BY COUNT(*) DESC;
-----------------------------------------------------------------------------------------
-- 10.) What's the average electric range for BEVs and PHEVs?

WITH cte_find_myear AS (
SELECT make, model, electric_vehicle_type, clean_alternative_fuel_vehicle_eligibility, model_year,electric_range
FROM electric_vehicle_population
WHERE electric_range = 0 AND electric_vehicle_type LIKE '%(BEV)%') 

SELECT make, model, model_year, COUNT(model_year) AS count_myear
FROM cte_find_myear
GROUP BY make, model, model_year
ORDER BY COUNT(model_year) DESC