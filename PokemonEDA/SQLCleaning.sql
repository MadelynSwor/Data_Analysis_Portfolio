/*
 Cleaning Data using SQL Queries
 
 Author: Madelyn Swor
 
 Notes: 
	 - Data was scraped from serebii.net. A few Pokemon that have variants in later games 
	   have the variant's stats as opposed to their own. 
	 - This means that pokemon with Mega Forms or Alolan Forms have those stats and types 
	   instead of the original pokemons'.
	 - Pokemon that are present in Pokemon X&Y will have their records updated to reflect
	   the original pokemon stats.
			-- Updated stats come from serebii.net, where the dataset was scraped from.
*/

-----------------------------------------------------------------------------------------------
-- Replacing Values with Null in Column type2

UPDATE pokedex  
SET type2 = NULL
WHERE type1 = type2 OR type2 = '';

-----------------------------------------------------------------------------------------------
-- Fixing type2 Value for Pokemon that Have an Alolan Variant 

UPDATE pokedex  
SET type2 = NULL
WHERE pokedex_number IN (27,28,105);

-----------------------------------------------------------------------------------------------
-- Fixing height_m and weight_kg for Pokemon with NULL Values

UPDATE pokedex  
SET height_m = (CASE 
					WHEN pokedex_number = 19 THEN 0.3
					WHEN pokedex_number = 20 THEN 0.7
					WHEN pokedex_number = 26 THEN 0.8
					WHEN pokedex_number = 27 THEN 0.6
					WHEN pokedex_number = 28 THEN 1
					WHEN pokedex_number = 37 THEN 0.6
					WHEN pokedex_number = 38 THEN 1.1
					WHEN pokedex_number = 50 THEN 0.2
					WHEN pokedex_number = 51 THEN 0.7
					WHEN pokedex_number = 52 THEN 0.4
					WHEN pokedex_number = 53 THEN 1
					WHEN pokedex_number = 74 THEN 0.4 
					WHEN pokedex_number = 75 THEN 1
					WHEN pokedex_number = 76 THEN 1.4
					WHEN pokedex_number = 88 THEN 0.9
					WHEN pokedex_number = 89 THEN 1.2
					WHEN pokedex_number = 103 THEN 2
					WHEN pokedex_number = 105 THEN 1
					WHEN pokedex_number = 720 THEN 0.5
					WHEN pokedex_number = 745 THEN 0.8
					ELSE height_m
				END),
weight_kg = (CASE 
					WHEN pokedex_number = 19 THEN 3.5
					WHEN pokedex_number = 20 THEN 18.5
					WHEN pokedex_number = 26 THEN 30
					WHEN pokedex_number = 27 THEN 12
					WHEN pokedex_number = 28 THEN 29.5
					WHEN pokedex_number = 37 THEN 9.9
					WHEN pokedex_number = 38 THEN 19.9
					WHEN pokedex_number = 50 THEN 0.8
					WHEN pokedex_number = 51 THEN 33.3
					WHEN pokedex_number = 52 THEN 4.2
					WHEN pokedex_number = 53 THEN 32
					WHEN pokedex_number = 74 THEN 20 
					WHEN pokedex_number = 75 THEN 105
					WHEN pokedex_number = 76 THEN 300
					WHEN pokedex_number = 88 THEN 30
					WHEN pokedex_number = 89 THEN 30
					WHEN pokedex_number = 103 THEN 120
					WHEN pokedex_number = 105 THEN 45
					WHEN pokedex_number = 720 THEN 9
					WHEN pokedex_number = 745 THEN 25
					ELSE weight_kg
				END)
WHERE 
	pokedex_number IN (19,20,26,27,28,37,38,50,51,52,53,74,75,76,88,89,103,105,720,745);

-----------------------------------------------------------------------------------------------
-- Converting Column weight_kg to Pounds

UPDATE pokedex
SET weight_kg = ROUND(weight_kg*2.205,1)

EXEC sp_rename '[pokedex].[weight_kg]', 'weight_lb', 'COLUMN';

-----------------------------------------------------------------------------------------------
-- Converting Column height_m to Feet

UPDATE pokedex
SET height_m = ROUND(height_m*3.281,1)

EXEC sp_rename '[pokedex].[height_m]', 'height_ft', 'COLUMN';

-----------------------------------------------------------------------------------------------
-- Adding Column Percentage Female

ALTER TABLE pokedex
ADD percentage_female float;

UPDATE pokedex
SET percentage_female = (100 - percentage_male);

-----------------------------------------------------------------------------------------------
-- Updating Stats From Alolan Form to Original Pokemons' Stats

UPDATE pokedex   
SET attack = (CASE 									
					WHEN pokedex_number = '26' THEN 90					
					WHEN pokedex_number = '103' THEN 95
					ELSE attack
				END),
defense = (CASE 					
					WHEN pokedex_number = '26' THEN 55
					WHEN pokedex_number = '27' THEN 85
					WHEN pokedex_number = '28' THEN 110
					WHEN pokedex_number = '50' THEN 25
					WHEN pokedex_number = '51' THEN 50
					ELSE defense
				END),
sp_attack = (CASE 					
					WHEN pokedex_number = '26' THEN 90
					WHEN pokedex_number = '27' THEN 20
					WHEN pokedex_number = '28' THEN 45
					ELSE sp_attack
				END),
sp_defense = (CASE 					
					WHEN pokedex_number = '26' THEN 80
					WHEN pokedex_number = '27' THEN 30
					WHEN pokedex_number = '28' THEN 55
					ELSE sp_defense
				END),
speed = (CASE 					
					WHEN pokedex_number = '50' THEN 95
					WHEN pokedex_number = '51' THEN 120 
					WHEN pokedex_number = '103' THEN 55
					ELSE speed
				END)
WHERE 
	pokedex_number IN (26,27,28,50,51,74,75,76,103,105);

-----------------------------------------------------------------------------------------------
-- Fixing Stats to Reflect Original Stats for Pokemon that Have Mega Forms

UPDATE pokedex  
SET attack = (CASE 					
					WHEN pokedex_number = 3 THEN 82
					WHEN pokedex_number = 6 THEN 84 
					WHEN pokedex_number = 9 THEN 83
					WHEN pokedex_number = 15 THEN 90
					WHEN pokedex_number = 115 THEN 95
					WHEN pokedex_number = 127 THEN 125
					WHEN pokedex_number = 130 THEN 125
					WHEN pokedex_number = 142 THEN 105
					WHEN pokedex_number = 150 THEN 110
					WHEN pokedex_number = 181 THEN 75
					WHEN pokedex_number = 208 THEN 85
					WHEN pokedex_number = 212 THEN 130
					WHEN pokedex_number = 214 THEN 125
					WHEN pokedex_number = 248 THEN 134
					WHEN pokedex_number = 282 THEN 65
					WHEN pokedex_number = 302 THEN 75
					WHEN pokedex_number = 303 THEN 85
					WHEN pokedex_number = 306 THEN 110
					WHEN pokedex_number = 308 THEN 60
					WHEN pokedex_number = 319 THEN 120
					WHEN pokedex_number = 334 THEN 70
					WHEN pokedex_number = 354 THEN 115
					WHEN pokedex_number = 359 THEN 130
					WHEN pokedex_number = 373 THEN 135
					WHEN pokedex_number = 445 THEN 130
					WHEN pokedex_number = 448 THEN 110
					WHEN pokedex_number = 460 THEN 92
					WHEN pokedex_number = 475 THEN 125
					WHEN pokedex_number = 719 THEN 100
					WHEN pokedex_number = 720 THEN 110
					WHEN pokedex_number = 555 THEN 140
					ELSE attack
				END),
defense = (CASE 					
					WHEN pokedex_number = 3 THEN 83
					WHEN pokedex_number = 9 THEN 100
					WHEN pokedex_number = 18 THEN 75
					WHEN pokedex_number = 65 THEN 45
					WHEN pokedex_number = 80 THEN 110
					WHEN pokedex_number = 94 THEN 60
					WHEN pokedex_number = 115 THEN 80
					WHEN pokedex_number = 127 THEN 100
					WHEN pokedex_number = 130 THEN 79
					WHEN pokedex_number = 130 THEN 65
					WHEN pokedex_number = 150 THEN 90
					WHEN pokedex_number = 181 THEN 85
					WHEN pokedex_number = 208 THEN 200
					WHEN pokedex_number = 208 THEN 100
					WHEN pokedex_number = 214 THEN 75
					WHEN pokedex_number = 229 THEN 50
					WHEN pokedex_number = 248 THEN 110
					WHEN pokedex_number = 302 THEN 75
					WHEN pokedex_number = 303 THEN 85
					WHEN pokedex_number = 306 THEN 180
					WHEN pokedex_number = 308 THEN 75
					WHEN pokedex_number = 310 THEN 60
					WHEN pokedex_number = 319 THEN 40
					WHEN pokedex_number = 334 THEN 90
					WHEN pokedex_number = 354 THEN 65
					WHEN pokedex_number = 373 THEN 80
					WHEN pokedex_number = 445 THEN 95
					WHEN pokedex_number = 448 THEN 70
					WHEN pokedex_number = 460 THEN 75
					WHEN pokedex_number = 475 THEN 65
					WHEN pokedex_number = 531 THEN 86
					WHEN pokedex_number = 719 THEN 150
					WHEN pokedex_number = 555 THEN 55
					ELSE defense
				END),
sp_attack = (CASE 					
					WHEN pokedex_number = 3 THEN 122
					WHEN pokedex_number = 6 THEN 109
					WHEN pokedex_number = 9 THEN 85
					WHEN pokedex_number = 15 THEN 45
					WHEN pokedex_number = 18 THEN 70
					WHEN pokedex_number = 65 THEN 135
					WHEN pokedex_number = 80 THEN 100
					WHEN pokedex_number = 94 THEN 130
					WHEN pokedex_number = 115 THEN 40
					WHEN pokedex_number = 127 THEN 55
					WHEN pokedex_number = 130 THEN 60
					WHEN pokedex_number = 130 THEN 60
					WHEN pokedex_number = 150 THEN 154
					WHEN pokedex_number = 181 THEN 115
					WHEN pokedex_number = 208 THEN 55
					WHEN pokedex_number = 229 THEN 110
					WHEN pokedex_number = 282 THEN 125
					WHEN pokedex_number = 302 THEN 65
					WHEN pokedex_number = 308 THEN 60
					WHEN pokedex_number = 310 THEN 105
					WHEN pokedex_number = 319 THEN 95
					WHEN pokedex_number = 334 THEN 70
					WHEN pokedex_number = 354 THEN 83
					WHEN pokedex_number = 359 THEN 75
					WHEN pokedex_number = 373 THEN 110
					WHEN pokedex_number = 445 THEN 80
					WHEN pokedex_number = 448 THEN 115
					WHEN pokedex_number = 460 THEN 92
					WHEN pokedex_number = 531 THEN 60
					WHEN pokedex_number = 719 THEN 100
					WHEN pokedex_number = 720 THEN 150
					WHEN pokedex_number = 555 THEN 30
					ELSE sp_attack
				END),
sp_defense = (CASE 					
					WHEN pokedex_number = 3 THEN 100
					WHEN pokedex_number = 6 THEN 85
					WHEN pokedex_number = 9 THEN 105
					WHEN pokedex_number = 18 THEN 70
					WHEN pokedex_number = 65 THEN 95
					WHEN pokedex_number = 94 THEN 75
					WHEN pokedex_number = 115 THEN 80
					WHEN pokedex_number = 127 THEN 70
					WHEN pokedex_number = 130 THEN 100
					WHEN pokedex_number = 130 THEN 75
					WHEN pokedex_number = 150 THEN 90
					WHEN pokedex_number = 181 THEN 90
					WHEN pokedex_number = 208 THEN 65
					WHEN pokedex_number = 208 THEN 80
					WHEN pokedex_number = 214 THEN 95
					WHEN pokedex_number = 229 THEN 80
					WHEN pokedex_number = 248 THEN 100
					WHEN pokedex_number = 282 THEN 115
					WHEN pokedex_number = 302 THEN 65
					WHEN pokedex_number = 303 THEN 55
					WHEN pokedex_number = 306 THEN 60
					WHEN pokedex_number = 308 THEN 75
					WHEN pokedex_number = 310 THEN 60
					WHEN pokedex_number = 319 THEN 40
					WHEN pokedex_number = 354 THEN 63
					WHEN pokedex_number = 373 THEN 80
					WHEN pokedex_number = 445 THEN 85
					WHEN pokedex_number = 460 THEN 85
					WHEN pokedex_number = 531 THEN 86
					WHEN pokedex_number = 719 THEN 150
					WHEN pokedex_number = 555 THEN 55
					ELSE sp_defense
				END),
speed = (CASE 					
					WHEN pokedex_number = 15 THEN 75
					WHEN pokedex_number = 18 THEN 101
					WHEN pokedex_number = 65 THEN 120
					WHEN pokedex_number = 94 THEN 110
					WHEN pokedex_number = 115 THEN 90
					WHEN pokedex_number = 127 THEN 85
					WHEN pokedex_number = 130 THEN 130
					WHEN pokedex_number = 150 THEN 130
					WHEN pokedex_number = 181 THEN 55
					WHEN pokedex_number = 208 THEN 65
					WHEN pokedex_number = 214 THEN 85
					WHEN pokedex_number = 229 THEN 95
					WHEN pokedex_number = 248 THEN 61
					WHEN pokedex_number = 282 THEN 80
					WHEN pokedex_number = 302 THEN 50
					WHEN pokedex_number = 308 THEN 80
					WHEN pokedex_number = 310 THEN 105
					WHEN pokedex_number = 319 THEN 95
					WHEN pokedex_number = 354 THEN 65
					WHEN pokedex_number = 359 THEN 75
					WHEN pokedex_number = 373 THEN 100
					WHEN pokedex_number = 445 THEN 102
					WHEN pokedex_number = 448 THEN 90
					WHEN pokedex_number = 460 THEN 60
					WHEN pokedex_number = 475 THEN 80
					WHEN pokedex_number = 719 THEN 50
					WHEN pokedex_number = 720 THEN 70
					WHEN pokedex_number = 555 THEN 95
					ELSE speed
				END)
WHERE pokedex_number IN (3,6,9,15,18,65,80,94,115,127,130,142,150,181,208,212,214,229,248,282,302,303,306,308,310,319,334,354,359,373,445,448,460,475,531,719,720);

-----------------------------------------------------------------------------------------------
-- Updating Column base_total

UPDATE pokedex
SET base_total = (defense+ hp+attack+speed+sp_attack+sp_defense);

-----------------------------------------------------------------------------------------------
-- Updating type2 in Table PokemonAgainst
	-- against_element values do reflects the orginal pokemon, not the alolan varients
	-- or mega forms, therefore no need to update anything but column type2.

UPDATE pokemonAgainst  -- Change type2 for gen 1 pokemon, Originals
SET type2 = NULL
WHERE 
	pokedex_number IN (27,28,105);

UPDATE pokemonAgainst 
SET type2 = CASE
			WHEN type2 = type1 THEN NULL
			ELSE type2
			END;