/*
 SQL Queries for Pokedex Project

 Author: Madelyn Swor
 DBMS: SQL Sever
*/
-----------------------------------------------------------------------------------------------
-- For Primary Type Weakness Chart Visual

SELECT 
	DISTINCT(type1) AS type,
	against_bug AS bug,
	against_dark AS dark,
	against_dragon AS dragon,
	against_electric AS electric,
	against_fairy AS fairy,
	against_fight AS fight,
	against_fire AS fire,
	against_flying AS flying,
	against_ghost AS ghost,
	against_grass AS grass,
	against_ground AS ground,
	against_ice AS ice,
	against_normal AS normal,
	against_poison AS poison,
	against_psychic AS psychic,	
	against_rock AS rock,
	against_steel AS steel, 
	against_water AS water
FROM pokemonAgainst
WHERE type2 IS NULL;

-----------------------------------------------------------------------------------------------
-- Finding Which Types are the weakest to other Types
   -- The gym types that appear in x&y are bug, fighting, rock, grass, electric, fairy, psychic,
   -- ice, steel, fire, dragon, and water.

WITH againstCTE AS ( -- Finding weakness of primary type
	SELECT name,type1,type2,
		SUM(against_fire+against_water+against_electric+against_grass+against_ice+against_fight+
		against_psychic+against_bug+against_rock+ against_dragon+against_steel+against_fairy) AS total_weakness
	FROM pokemon..pokemonAgainst
	GROUP BY name,type1,type2
)
SELECT type1, ROUND(AVG(total_weakness),1) AS avg_weakness
FROM againstCTE
WHERE type2 IS NULL 
GROUP BY type1
ORDER BY AVG(total_weakness) ASC;

-----------------------------------------------------------------------------------------------
-- Finding Top Pokemon in X & Y that have a High Resistance and base_total

SELECT * INTO #tmpPokedex FROM ( --pokedex, but only pokemon from x & y
	SELECT agst.pokedex_number,
		   agst.name,
		   agst.type1,
		   agst.type2,
		   dex.base_total,
		   SUM(against_fire+against_water+against_electric+against_grass+against_ice+against_fight+
		   against_psychic+against_bug+against_rock+ against_dragon+against_steel+against_fairy) AS total_weakness
	FROM pokedex dex
	RIGHT JOIN xyPokemon xy 
	ON dex.pokedex_number = xy.pokedex_num 
	JOIN pokemonAgainst agst
	ON dex.pokedex_number = agst.pokedex_number
	WHERE is_legendary = 0
	GROUP BY agst.pokedex_number,agst.name,agst.type1,agst.type2,dex.base_total
) AS tmpPokedex;

WITH ctePossibleTeam AS (  --ensures the top base_total for pokemon of that combination of type1 and type2
	SELECT *,
		rank()	OVER(PARTITION BY type1,type2 ORDER BY base_total DESC) AS rank_num
	FROM #tmpPokedex
	WHERE 
		total_weakness <= 12.75 AND 
		base_total >= 510 AND
		name NOT IN ('Greninja','Delphox','Chesnaught') AND
		(type1 IN ('steel','ghost','electric','fairy','poison','fire','psychic','water','dragon','normal','fighting','bug') OR
		type2 IN ('steel','ghost','electric','fairy','poison','fire','psychic','water','dragon','normal','fighting','bug'))
)
SELECT pokedex_number,name,type1,type2,base_total,total_weakness
FROM ctePossibleTeam
WHERE rank_num = 1
ORDER BY base_total DESC,type1,type2;


