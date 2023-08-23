# Population of Electric Vehicles in Washington, US


## Introduction
Within the last two decades there's been a push towards the production of electric vehicles. As people steer away from fossil fuels to more sustainable forms of energy, electric vehicles are on the path of becoming the standard. Through this dataset, I hope to answer just how popular electric vehicles have become and identify any future trends.

## Table of Contents
- [About the dataset]()
- [Terms to Know]()
- [EDA with SQL]()
- [Analysis]()
- [Sources]()

### About the dataset
This dataset was created by the U.S. state government of Washington and can be accessed at [data.gov](https://catalog.data.gov/dataset/electric-vehicle-population-data). This data is composed of 2 types of electric vehicles, Battery Electric Vehicles (BEVs) and Plug-in Hybrid Electric Vehicles (PHEVs), that are currently registered by Washington State Department of Licensing (DOL) as of July 2023.

This project uses fields such as VIN, county, city, make, model, and model year. [LIST ALL FIELDS USED HERE]

To learn more about the database schema and how I cleaned the dataset visit here:
- [Clean data directory]()
- [Schema directory]()

### Terms to Know
Before jumping into our questions, let's go over a few terms that'll come up throughout our analysis.

1.) Electric vehicle type
>Battery Electric Vehicles (BEVs): are fully electric vehicles with a rechargeable batteries and no gasoline engine.
>Plug-in Hybrid Electric Vehicles (PHEVs): has a gas-powered engine coupled with an electric motor and battery.
2.) Clean Alternative Fuel Vehicle (CAFV) Eligibility:
> is based upon fuel requirement and electric range. Vehicles that qualify are elgibile for a tax exemption in Washington State.
3.) Electric Range:
> the number of miles an electric vehicle can travel on a fully charged battery.

### EDA with SQL
#### 1.) Find how many distinct makes there are?
> There are 37 distintive makes

#### 2.) How many vehicles are there for each make?
> [input table output]. The leading make is Tesla with nearly half of all EVs in WA with 65,552 vehicles. The lowest is tied with 3 vehicles in WA, Bentley and Wheego Electric Cars.

#### 3.) What's the average electric range for BEVs and PHEVs?
> [SHOW OUTPUT]

#### 4.) What vehicle model and model year have the highest electric range for each make?
> [Show output] Note that this excludes cars that have haven't had their CAFV elgibility researched.

#### 5.) What's the average electric range by model year?
> [SHOW OUTPUT]

#### 6.) How many different PHEV and BEV models does each make have in WA?
> Nearly half of makes have only specialize in one type, making only PHEV or BEV models.

#### 7.) What 5 counties have the most registered electric vehicles?
> [Show output][then put a map up of counties in WA]. Looking at the map of counties we see that the top 5 counties all border one another. King County contains Seattle, the largest city in WA and Clark County is located near Portland, Oregon, which is Oregon's largest city.

#### 8.) What Percentage of of registered cars are electric vehicles?
> Currently 5% of registered cars are electric.

#### 9.) What percentage of electric vehicles are BEVs or PHEVs?
> 77% of electric cars in WA are BEV while only 23% are PHEV.

#### 10.) How many models does each make have?
> BMW and Audi are tied with having 11 different models in WA.

#### 11.) What's the oldest model year for each make in WA?
> The oldest electric vehicle in WA is a Chevrolet with a model year of 1997.

#### 12.) What's the distribution of vehicles by model year?
> There's been a steady increase of registered EVs save for 2019 and 2014. The highest population of EVs are 2023 models. Note that even though this dataset is from July 2023, consumers were able to buy 2023 models in 2022. 

#### 13.) How many cars are eligible for CAFV?
> Out of the models that have had their CAFV researched, 78% of vehicles qualify. It's important to note that models from 2019 to 2024 are 'Unknown' whether they qualify as listed as in the process of being researched by WA.

### Analysis
1.) One interesting thing is that as early as 1997 there's been BEVs. What happened to the decline of early models?

>> based on a basic quick search, it seems some older models weren't as reliable after a number of miles driven. And also I imagine due to lack of electric infrastructure.

2.) Affect of cold environment on electric cars?
> In this case PHEVs may have BEVs beat. Quick search says BEVs can lose some electric range in a sudden cold spell.


### Sources
- The number of registered cars(2,977,074) is located at statista(https://www.statista.com/statistics/196010/total-number-of-registered-automobiles-in-the-us-by-state/)



K 
2
J : Japan
W
3
S : Europe
4
L
7
Z : Europe
5
1
Y



