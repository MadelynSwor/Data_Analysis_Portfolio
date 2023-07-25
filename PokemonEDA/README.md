What is the Best Pokémon Team in Pokémon X&Y?
======

## Table of Contents
- [Introduction](#1-introduction)
- [Conditions for the Choosing Best Team](#2-conditions-for-the-choosing-best-team)
- [Pokémon Types; Advantages and Disadvantages](#3-pokémon-types-advantages-and-disadvantages)
- [Finding the Most Resistant Pokémon Types](#4-finding-the-most-resistant-pokémon-types)
- [Conclusion](#5-conclusion)

### 1. Introduction

Like many kids who grew up in the early 2000s I loved playing Pokémon. I was in the seventh grade when the sixth installment of the game, Pokémon X & Y, came out. My friends and I became obsessed. Every lunch we’d huddle around our 3DS comparing teams while one person kept lookout for the lunch monitor. While it’s been years since I’ve picked up the game, I thought it’d be fun to answer my 13 year old self’s question. What is the best Pokémon team?

Before diving into the process of picking the best team, what is Pokémon? Pokémon is a franchise that revolves around you, a trainer, collecting monsters called Pokémon. Players start the game by choosing from **_three_ _starter_ _Pokémon_**. From there players are tasked with exploring the world, battling other trainers, and improving your Pokémon team. To progress the game’s story, trainers and their Pokémon team need to defeat **_12_ _gym_ _leaders_**. A big appeal for Pokémon fans is choosing which six Pokémon you put on your team. Going back to my original question, how do you decide the best team?

### 2. Conditions for the Choosing Best Team

Before we comb through the dataset there are a few things to consider.

**1.)** We want types that have a higher resistance to the 12 gym leaders. <br>
>> There are 12 total gym leaders that players need to beat in order to win the game. Each leader has a team of one type. For example, the bug gym leader will have a team of all bug type Pokémon. By choosing a team with higher resistance against the gym leaders, players will have the upper hand against gym leaders. <br>

**2.)** For a balanced team, all Pokémon on the team will be different types. No overlapping.<br>
>> A Pokémon team with diverse types is better prepared for facing all opponents. This ensures our team won’t be at a disadvantage.

**3.)** No legendary Pokémon.<br>
>> Legendaries are powerful Pokémon whose high stats make them formidable. However, since they can only be acquired late game we’ll focus our analysis on non-legendary Pokémon.

**4.)** Team will be composed of Pokémon with the highest stats.<br>
>> * Pokémon have 6 stats; hp, attack, defense, speed, special attack, and special defense. <br>
>> * Our dataset has a column called ```base_total``` that is the sum of all the stats. The higher the ```base_total``` the better stats that Pokémon has.

**5.)** Create a team for each starter Pokémon.
>> * Players start out the game choosing a starter Pokémon that is either fire, water, or grass type. Being the first Pokémon given to the players, many fans become attached to their starter and keep them on their team throughout the game. <br>
>>* In Pokémon X & Y the starters are Greninja, Chesnaught, and Delphox respectively.

<div align="center">
<img src="https://raw.githubusercontent.com/MadelynSwor/Data_Analysis_Portfolio/main/PokemonEDA/Visuals/alltogetherNow.png" height="150" >
</div>

### 3. Pokémon Types; Advantages and Disadvantages

The first step to building your team is choosing which types of Pokémon. The game has a total of **_18_ _different_ _types_**. Each type has multiple advantages and disadvantages. As shown in the image below, fire pokemon are strong against grass but weak against water. <br>

<div align="center"> 
<img src="https://raw.githubusercontent.com/MadelynSwor/Data_Analysis_Portfolio/main/PokemonEDA/Visuals/pokemonTypes.png" width="500">      
</div>  <br>  

The chart below shows how weak one type is against another. The lower the number, the more resistant that type is. We see in our first row that the bug type is more resistant to fighting, grass, and ground, but weaker to fire, flying, and rock types. Gray cells with the value ```1.000``` are attacks that deal normal damage.

<div align="center">
<img src="https://raw.githubusercontent.com/MadelynSwor/Data_Analysis_Portfolio/main/PokemonEDA/Visuals/typeWeaknessViz.png">
</div>  <br> 

Note that the chart covers the weakness for Pokémon that have one type. A Pokémon that has two types have weakness values that reflect characteristics of both types. We’ll delve into how this affects the overall resistance of a pokemon in the following section.

### 4. Finding the Most Resistant Pokémon Types

The 12 gym leaders in Pokémon X&Y are **bug, rock, fighting, grass, electric, fairy, psychic, ice, steel, fire, dragon, and water**. As there are 18 total types of Pokémon, we’ll use the SQL excerpt below to find which types are most resistant to the gyms.

```SQL
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
```
<img src="https://raw.githubusercontent.com/MadelynSwor/Data_Analysis_Portfolio/main/PokemonEDA/Visuals/SQLResultQuery1.png">

Looking at the output of our query, we see steel is the most resistant, whereas rock and ice are tied for being the least. In selecting resistant Pokémon for our team, we’ll limit our search to Pokémon that have at least one type in steel, ghost, electric, fairy, poison, fire, psychic, water, dragon, normal, fighting, or bug. 

To limit our search further we’ll use a rank system. We’re interested in finding Pokémon with the max base total stat for each unique combination of ```type1``` and ```type2```. 

```SQL
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
) as tmpPokedex

WITH ctePossibleTeam AS (  --ensures the top base_total for Pokémon of that combination of type1 and type2
	SELECT *,
		rank() OVER(PARTITION BY type1,type2 ORDER BY base_total DESC) as rank_num
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
ORDER BY base_total DESC,type1,type2
```

<img src="https://raw.githubusercontent.com/MadelynSwor/Data_Analysis_Portfolio/main/PokemonEDA/Visuals/SQLResultQuery2.png"> 
<br>

This gives us 18 potential Pokémon for our team of six. When selecting Pokémon from this list, we need to keep in mind all of our team’s types. Here’s a visual of what Pokémon from our output can be on what starter team.

<div align="center">
<img src="https://raw.githubusercontent.com/MadelynSwor/Data_Analysis_Portfolio/main/PokemonEDA/Visuals/venndiagramStarters.png" height = "500">
</div>  <br> 

Now that we know which of the potential teammates can be matched to which starter, we can start choosing the best Pokémon for each starter. Let’s organize our list of candidates by ```type1```, ```type2```, and ```base_total```.

<div align="center">
<img src="https://raw.githubusercontent.com/MadelynSwor/Data_Analysis_Portfolio/main/PokemonEDA/Visuals/teammatesBase.png">
</div>

The top two highest ```base_total``` are the Pokémon _Scizor_ and _Florges_. Since _Scizor_ is a bug steel type and _Florges_ is a fairy type, both Pokémon can be placed in any starter team. This leaves us three open slots on each team.

<div align="center">
<img src="https://raw.githubusercontent.com/MadelynSwor/Data_Analysis_Portfolio/main/PokemonEDA/Visuals/chesnaughtTeamPT1.png" width="400">
</div>
<div align="center">
<img src="https://raw.githubusercontent.com/MadelynSwor/Data_Analysis_Portfolio/main/PokemonEDA/Visuals/gregninjaTeamPT1.png"width="400">
</div>
<div align="center">
<img src="https://raw.githubusercontent.com/MadelynSwor/Data_Analysis_Portfolio/main/PokemonEDA/Visuals/delphoxTeamPT1.png"width="400">
</div>   <br>

Next we choose the next Pokémon with the highest ```base_total```, _Venusaur_. However, since venusaur is a grass poison type, it can’t be on Chesnaught’s team since Chesnaught is a grass fighting type. For Chesnaught’s team, the next Pokémon with the highest ```base_total``` that doesn’t overlap types would be _Kingdra_.

<div align="center">
<img src="https://raw.githubusercontent.com/MadelynSwor/Data_Analysis_Portfolio/main/PokemonEDA/Visuals/ChesnaughtTeamPT2.png"width="400">
</div>
<div align="center">
<img src="https://raw.githubusercontent.com/MadelynSwor/Data_Analysis_Portfolio/main/PokemonEDA/Visuals/GregTeamPT2.png"width="400">
</div>
<div align="center">
<img src="https://raw.githubusercontent.com/MadelynSwor/Data_Analysis_Portfolio/main/PokemonEDA/Visuals/delphoxTeamPT2.png"width="400">
</div>    <br>

Using this method of elimination of the highest ```base_total``` with types not already on the team, this is our final result.

<div align="center">
<img src="https://raw.githubusercontent.com/MadelynSwor/Data_Analysis_Portfolio/main/PokemonEDA/Visuals/ChesnaughtTeamPT3.png"width="400">
</div>
<div align="center">
<img src="https://raw.githubusercontent.com/MadelynSwor/Data_Analysis_Portfolio/main/PokemonEDA/Visuals/GregTeamPT3.png"width="400">
</div>
<div align="center">
<img src="https://raw.githubusercontent.com/MadelynSwor/Data_Analysis_Portfolio/main/PokemonEDA/Visuals/DelTeamPT3.png"width="400">
</div>    <br>


### 5.) Conclusion

By finding the most resistant Pokémon types coupled with pokemon with high ```base_total```, we’ve found the best team matchups for each starter Pokémon. <br>
* Greninja, Scizor, Florges, Jolteon, Venusaur, Flareon <br>
* Chesnaught, Scizor, Florges, Jolteon, Kingdra, Flareon <br>
* Delphox, Scizor, Florges, Jolteon, Venusaur, Kingdra

While this analysis is seven years too late to settle any middle school arguments, rest assured this age old answer has been solved. If you meet any old Pokémon X & Y fans out there, feel free to wow them with this insight.

