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
-- 3.) What's the average electric range for BEVs and PHEVs?

SELECT electric_vehicle_type, ROUND(AVG(electric_range),0,1) AS avg_electric_range
FROM electric_vehicle_population
WHERE electric_range != 0
GROUP BY electric_vehicle_type 
ORDER BY AVG(electric_range) DESC

-----------------------------------------------------------------------------------------
-- 4.) What vehicle model and model year have the highest electric range for each make?

WITH highest_range AS (
	SELECT make, model, model_year, electric_vehicle_type, electric_range, 
		ROW_NUMBER() OVER(PARTITION BY make ORDER BY electric_range DESC) as rank_num
	FROM electric_vehicle_population
	WHERE electric_range != 0 )

SELECT make, model, model_year, electric_vehicle_type, electric_range
FROM highest_range
WHERE rank_num = 1
ORDER BY electric_range DESC;

-----------------------------------------------------------------------------------------
-- 5.) What's the average electric range for by year for PHEVs and BEVs?

WITH avg_range AS (
	SELECT model_year, electric_vehicle_type, electric_range, 
		DENSE_RANK() OVER(ORDER BY electric_vehicle_type DESC) as ev_type -- rank 1 = PHEVs,rank 2 = BEVs
	FROM electric_vehicle_population
	WHERE electric_range != 0),
	 
renamed_avg_range AS (
    SELECT model_year, electric_vehicle_type, electric_range, 
           CASE 
               WHEN ev_type = 1 THEN 'PHEV'
               WHEN ev_type = 2 THEN 'BEV'
           END AS renamed_ev_type
    FROM avg_range
)

SELECT model_year,renamed_ev_type, ROUND(AVG(electric_range),1,1) AS avg_range
FROM renamed_avg_range
GROUP BY renamed_ev_type, model_year
ORDER BY renamed_ev_type, model_year DESC;

-----------------------------------------------------------------------------------------
-- 6.) How many different PHEV and BEV models does each make have in WA?

WITH count_types AS (
	SELECT make, model, electric_vehicle_type, 
		DENSE_RANK() OVER(ORDER BY electric_vehicle_type DESC) as ev_type -- rank 1 = PHEVs,rank 2 = BEVs
	FROM electric_vehicle_population )

SELECT make, electric_vehicle_type, COUNT(DISTINCT model) AS num_models
FROM count_types
GROUP BY make, electric_vehicle_type
ORDER BY make, COUNT(DISTINCT model) DESC

-----------------------------------------------------------------------------------------
-- 7.) What 5 counties have the most registered electric vehicles?

SELECT county, COUNT(*) AS total_for_county
FROM electric_vehicle_population
GROUP BY county
ORDER BY COUNT(*) DESC
OFFSET 0 ROWS FETCH FIRST 5 ROWS ONLY;

-----------------------------------------------------------------------------------------
-- Washington State has 2,977,074 registered cars.
-- 8.) What Percentage of of registered cars are electric vehicles?

SELECT ROUND(COUNT(*)*1.0/2977074*100.0,1) AS percentage_EV -- *1.0 to ensure decimal division
FROM electric_vehicle_population;

-----------------------------------------------------------------------------------------
-- 9.) What percentage of electric vehicles are BEVs or PHEVs?

SELECT electric_vehicle_type, COUNT(*) AS total, COUNT(*)/143596.0*100.0 AS percent_total
FROM electric_vehicle_population
GROUP BY electric_vehicle_type
ORDER BY COUNT(*) DESC;

-----------------------------------------------------------------------------------------
-- 10.) How many models does each make have?

SELECT make, COUNT(DISTINCT(model)) AS model_count
FROM electric_vehicle_population
GROUP BY make
ORDER BY COUNT(DISTINCT(model)) DESC;

-----------------------------------------------------------------------------------------
-- 11.) What's the oldest model year for each make in WA?

SELECT make, MIN(model_year) AS oldest_model_year
FROM electric_vehicle_population
WHERE electric_vehicle_type LIKE '%BEV%'
GROUP BY make
ORDER BY MIN(model_year) ASC;

-----------------------------------------------------------------------------------------
-- 12.) What's the distribution of vehicles by model year?

SELECT model_year, COUNT(*) AS total_per_model_year
FROM electric_vehicle_population
WHERE model_year != 2024 -- Get rid of early releases 
GROUP BY model_year
ORDER BY model_year DESC;

-----------------------------------------------------------------------------------------
-- 13.) How many cars are eligible for CAFV tax exemption based on vehicle type?

WITH count_CAFV AS (
	SELECT electric_vehicle_type, clean_alternative_fuel_vehicle_eligibility,
		DENSE_RANK() OVER(ORDER BY electric_vehicle_type DESC) as ev_type -- rank 1 = PHEVs,rank 2 = BEVs
	FROM electric_vehicle_population 
	WHERE clean_alternative_fuel_vehicle_eligibility != 'Unknown')

SELECT electric_vehicle_type, COUNT(ev_type) AS total_CAFV_eligible
FROM count_CAFV
WHERE clean_alternative_fuel_vehicle_eligibility != 'No'
GROUP BY electric_vehicle_type
ORDER BY COUNT(ev_type) DESC;

