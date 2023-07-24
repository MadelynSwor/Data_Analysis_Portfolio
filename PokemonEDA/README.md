What is the Best Pokémon Team in Pokémon X&Y?
======
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

### 4. Finding the Most Resistant Pokémon Types.

The 12 gym leaders in Pokémon X&Y are **bug, rock, fighting, grass, electric, fairy, psychic, ice, steel, fire, dragon, and water**. As there are 18 total types of Pokémon, we’ll use the SQL excerpt below to find which types are most resistant to the gyms.

```SQL
WITH againstCTE AS ( -- Finding weakness of primary type
select name,type1,type2,
SUM(against_fire+against_water+against_electric+against_grass+against_ice+against_fight+
	against_psychic+against_bug+against_rock+ against_dragon+against_steel+against_fairy) AS total_weakness
from pokemon..pokemonAgainst
group by name,type1,type2
)
SELECT type1, ROUND(AVG(total_weakness),1) AS avg_weakness
FROM againstCTE
WHERE type2 IS NULL 
GROUP BY type1
ORDER BY AVG(total_weakness) ASC;
```



