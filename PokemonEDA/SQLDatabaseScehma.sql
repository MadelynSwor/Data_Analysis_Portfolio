/*
 Database Schema 
 Author: Madelyn Swor
 Original Dataset: https://www.kaggle.com/datasets/rounakbanik/pokemon
*/
CREATE TABLE [dbo].[pokedex](
	[pokedex_number] [float] NULL,
	[generation] [float] NULL,
	[name] [nvarchar](255) NULL,
	[type1] [nvarchar](255) NULL,
	[type2] [nvarchar](255) NULL,
	[attack] [float] NULL,
	[hp] [float] NULL,
	[defense] [float] NULL,
	[speed] [float] NULL,
	[sp_attack] [float] NULL,
	[sp_defense] [float] NULL,
	[base_total] [float] NULL,
	[experience_growth] [float] NULL,
	[capture_rate] [float] NULL,
	[base_egg_steps] [float] NULL,
	[base_happiness] [float] NULL,
	[percentage_male] [float] NULL,
	[height_ft] [float] NULL,
	[weight_lb] [float] NULL,
	[is_legendary] [float] NULL,
	[percentage_female] [float] NULL
);

CREATE TABLE [dbo].[pokemonAgainst](
	[pokedex_number] [float] NULL,
	[name] [nvarchar](255) NULL,
	[type1] [nvarchar](255) NULL,
	[type2] [nvarchar](255) NULL,
	[against_normal] [float] NULL,
	[against_fire] [float] NULL,
	[against_water] [float] NULL,
	[against_electric] [float] NULL,
	[against_grass] [float] NULL,
	[against_ice] [float] NULL,
	[against_fight] [float] NULL,
	[against_poison] [float] NULL,
	[against_ground] [float] NULL,
	[against_flying] [float] NULL,
	[against_psychic] [float] NULL,
	[against_bug] [float] NULL,
	[against_rock] [float] NULL,
	[against_ghost] [float] NULL,
	[against_dragon] [float] NULL,
	[against_dark] [float] NULL,
	[against_steel] [float] NULL,
	[against_fairy] [float] NULL
);

CREATE TABLE [dbo].[xyPokemon](
	[pokedex_num] [float] NULL
);

