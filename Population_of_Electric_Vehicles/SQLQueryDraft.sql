/*
   Author: Madelyn Swor
   Dataset: https://catalog.data.gov/dataset/electric-vehicle-population-data
*/


-----------------------------------------------------------------------------------------
/*
   Questions for EDA:

   2.) What's the population of each make? [X]
   3.) Group brand/make by major cities in washington [X]
   5.) What make has the biggest population in washington?
   6.) -- In final report, what's the total car registrations of washington?  [X]
   8.) Population for each electric vehicle type? [X]
   10.) How many models does each make have? [X]
   11.) Distribution of model year? Has it gone up in popularity? [X]
   12.) What make and model (and year?) have the highest number of cars in Washington?
   13.) The first digit of VIN is the country of origin or the final processing plant.
       "For example, numbers, 1, 4 and 5 represent the U.S. 2 is Canada and the number 3 represents Mexico"
	   (double check that fact). What country produces the highest amount of electric vehicles?
	   Country for highest electric battery? Country for highest plug-in?
	14.) Are more cars being made that are eligible for CAFV? [X]

*/
-----------------------------------------------------------------------------------------
-- Find how many distinct makes there are?

SELECT DISTINCT(make)
FROM electric_vehicle_population;

-----------------------------------------------------------------------------------------
-- How many Battery Electric Vehicles (BEVs) vs Plug-in Hybrid Electric Vehicles (PHEVs) 
-- are there?

SELECT 

-----------------------------------------------------------------------------------------
-- Okay so BEV with 0 electric_range haven't had their CAFV eligibility researched,
-- so make sure to exclude these entries when finding avg electric range of BEVs.
-- range of year for BEVs with 0 electric range is 2019-2023.


WITH cte_find_myear AS (
SELECT make, model, electric_vehicle_type, clean_alternative_fuel_vehicle_eligibility, model_year,electric_range
FROM electric_vehicle_population
WHERE electric_range = 0 AND electric_vehicle_type LIKE '%(BEV)%') 
-- 63,954 entries have 0 ER out of 143,596 total entries								
-- 63,954 entries have 0 ER out of 110,865 BEV vehicles. More than half.
-- NOTE: may have to replace these values base on historical data

SELECT make, model, model_year, COUNT(model_year) AS count_myear
FROM cte_find_myear
GROUP BY make, model, model_year
ORDER BY COUNT(model_year) DESC

-- avg year by make
WITH cte_find_myear AS (
SELECT make, model, electric_vehicle_type, clean_alternative_fuel_vehicle_eligibility, model_year,electric_range
FROM electric_vehicle_population
WHERE electric_range = 0 AND electric_vehicle_type LIKE '%(BEV)%') 

SELECT make, AVG(model_year) AS avg_myear
FROM cte_find_myear
GROUP BY make
ORDER BY AVG(model_year) DESC

-- Checking if any plug-in cars have CAFV elgibility.
SELECT make, model, electric_vehicle_type, clean_alternative_fuel_vehicle_eligibility, model_year,electric_range
FROM electric_vehicle_population
WHERE electric_vehicle_type NOT LIKE '%(BEV)%'
AND clean_alternative_fuel_vehicle_eligibility != 'Eligibility unknown as battery range has not been researched';


-- Counting how many cars have a an electric range of 0 by year
SELECT model_year,COUNT(*) AS total
FROM electric_vehicle_population
WHERE electric_range = 0
GROUP BY model_year
ORDER BY COUNT(*) DESC

select * from electric_vehicle_population where electric_vehicle_type LIKE '%(BEV)%'


-- Counting how many cars have 0 listed for base_MSRP
SELECT COUNT(*)
from electric_vehicle_population
where base_MSRP = 0


-- Finding the avg electric range for teslas
SELECT 
	model_year,model, AVG(electric_range) AS avg_electric_range
from electric_vehicle_population
WHERE make LIKE '%Tesla%' AND electric_range != 0
GROUP BY model, model_year 
ORDER BY AVG(electric_range) DESC


