/*
   Cleaning Dataset with SQL
   Dataset: https://catalog.data.gov/dataset/electric-vehicle-population-data

   Notes on Cleaning: 

   1.) No duplicates present
   2.) No null values in areas other than postal_code, county, census, etc. unimportant to analysis.
   3.) Incorrect values found:
      a.) MSRP includes the total cost to make the car, plus a profit margin. However, more than 90% of values 
	      have '0' listed for MSRP.

	  b.) Some electric ranges are listed as '0', because new models don't have CAFV elgibility researched
			   May use estimate based on historical data, but note that more than half of 
			   entries for BEV cars have 0 listed for ER.
   
   Notes on Dataset:

	1.) VIN is not unique.
	2.) Cars that have base_MSRP values were made in or before 2020.

*/
-----------------------------------------------------------------------------------------
-- Change base_MSRP values to NULL if value is 0

UPDATE electric_vehicle_population
SET base_MSRP = NULL
WHERE base_MSRP = 0 

-----------------------------------------------------------------------------------------
-- Change values in column clean_alternative_fuel_vehicle_elgibility to values yes, no, and unknown.

UPDATE electric_vehicle_population
SET clean_alternative_fuel_vehicle_eligibility = 
	CASE
		WHEN clean_alternative_fuel_vehicle_eligibility = 'Clean Alternative Fuel Vehicle Eligible' THEN 'Yes'
		WHEN clean_alternative_fuel_vehicle_eligibility = 'Not eligible due to low battery range' THEN 'No'
		WHEN clean_alternative_fuel_vehicle_eligibility = 'Eligibility unknown as battery range has not been researched' THEN 'Unknown'
	END
	
