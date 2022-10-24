---Indian Census Dataset Analysis using SQL----

--Creating a table and importing the data from the excel file---
CREATE TABLE Growth_and_Literacy(
	District VARCHAR,
	State_name VARCHAR,
	Growth TEXT,
	Sex_Ratio INT,
	Literacy FLOAT
)

COPY growth_and_literacy
FROM 'D:\Indian Census SQL Project\Census Dataset1.csv'
CSV HEADER;



--Creating another table and importing the data from the excel file---
CREATE TABLE Population_Data(
District VARCHAR,
State_name VARCHAR,
Area_km2 TEXT,
Population TEXT
)

COPY population_data
FROM 'D:\Indian Census SQL Project\Census Dataset2.csv'
CSV HEADER

-- Explore the Dataset 'growth_and_literacy'---
SELECT * FROM growth_and_literacy;
--In the table 'growth_and_literacy', column 'growth' datatype is 'text' so first we
--convert it into float. But, first we need to remove the % symbol
SELECT * FROM growth_and_literacy;
UPDATE growth_and_literacy
SET growth = REPLACE(growth,'%','');

ALTER TABLE growth_and_literacy
	ALTER growth TYPE FLOAT USING growth::FLOAT;

-- Explore the Dataset 'Population_Data'---
SELECT * FROM Population_Data;
-- In this table, column 'area_km2' and 'population' datatype is text so we need to change
-- the data type but before converting the datatype, we need to remove the comma from both
--columns

UPDATE population_data
SET population= REPLACE(population,',','');

UPDATE population_data
SET area_km2= REPLACE(area_km2,',','');

SELECT * FROM population_data;

-- Number of rows into our dataset---
SELECT COUNT(*) FROM population_data;
SELECT COUNT(*) FROM growth_and_literacy;

--Exploring the dataset---
SELECT COUNT(*) FROM population_data
WHERE state_name ='#N/A';

## -- 33 columns out of 640 have been identified where state_name is not present in the data for the column 'Population_data'


SELECT COUNT(*) FROM growth_and_literacy
WHERE state_name ='#N/A';

## -- state_name is present in all the columns in the table 'growth_and_literacy'
-- Number of columns are same in both the tables---


--Fetch the dataset for 'Jharkhand' and 'Bihar' state from the table 'growth_and_literacy'
SELECT * FROM growth_and_literacy;
SELECT * FROM growth_and_literacy
WHERE state_name IN ('Bihar','Jharkhand');


--- Population of India  and Total India Population---
SELECT * FROM population_data;


-- area_km2 and population are in text datatype, so first we need to change the datatype---

ALTER TABLE population_data
	ALTER area_km2 TYPE INT USING area_km2::INT,
	ALTER population TYPE INT USING population::INT;
	
-- Calculating the total population---
SELECT SUM(population) AS Total_Population
FROM population_data;

-- Average population growth rate of India---
SELECT * FROM growth_and_literacy;
SELECT AVG(growth) FROM growth_and_literacy;
-- 19.24% is the Average growth rate of Indian Population ---

--TOP 5 state wise Average growth details--
SELECT state_name,AVG(growth) AS Avg_Growth_rate
FROM growth_and_literacy
GROUP BY state_name
ORDER BY Avg_Growth_rate DESC
LIMIT 5;

--Bottom 5 state wise Average growth details--
SELECT state_name,AVG(growth) AS Avg_Growth_rate
FROM growth_and_literacy
GROUP BY state_name
ORDER BY Avg_Growth_rate ASC
LIMIT 5;


--States having growth rate greater than the Average growth rate of India--
SELECT state_name, 
	AVG(growth) AS Avg_Growth_rate
FROM growth_and_literacy
GROUP BY state_name
HAVING AVG(growth) > 19.24
ORDER BY Avg_Growth_rate DESC;
-- Total 16 States have their average population growth rate is greater than the Avg growth rate of India--


--TOP 5 Cities wise Average growth rate details--
SELECT district,
	AVG(growth) AS Avg_Growth_rate
FROM growth_and_literacy
GROUP BY district
ORDER BY Avg_Growth_rate DESC
LIMIT 5;

--Botton 5 Cities wise Average growth rate details--
SELECT district,
	AVG(growth) AS Avg_Growth_rate
FROM growth_and_literacy
GROUP BY district
ORDER BY Avg_Growth_rate ASC
LIMIT 5;


-- Analyzing the sex_ratio of india--
SELECT ROUND(AVG(sex_ratio),0) AS India_Avg_Sex_Ratio
FROM growth_and_literacy;

--945 is the Average Sex ratio of India--

--State Wise Details---
SELECT state_name, 
	ROUND(AVG(sex_ratio),0) AS Avg_Sex_Ratio
FROM growth_and_literacy
GROUP BY state_name
ORDER BY AVG(sex_ratio) DESC;

-- How many states having sex_ratio is less than 1000---
SELECT state_name, 
	ROUND(AVG(sex_ratio),0) AS Avg_Sex_Ratio
FROM growth_and_literacy
GROUP BY state_name
HAVING AVG(sex_ratio)<1000
ORDER BY AVG(sex_ratio) ASC;
--Total 32 States have been identified where sex ratio is less than 1000--

-- How many states having sex_ratio is greater than 1000---
SELECT state_name, 
	ROUND(AVG(sex_ratio),0) AS Avg_Sex_Ratio
FROM growth_and_literacy
GROUP BY state_name
HAVING AVG(sex_ratio)>=1000
ORDER BY AVG(sex_ratio) ASC;
--Only 3 states In India having Sex_ratio greater than 1000---

-- Top 5 Districts having Sex_ratio is greater than 1000-

SELECT district, 
	state_name,
	ROUND(AVG(sex_ratio),2) AS Avg_Sex_Ratio
FROM growth_and_literacy
GROUP BY district,state_name
HAVING AVG(sex_ratio)>=1000
ORDER BY AVG(sex_ratio) DESC
LIMIT 5;

-- Bottom 5 Districts having Sex_ratio is less than 1000-
SELECT district, 
	state_name,
	ROUND(AVG(sex_ratio),0) AS Avg_Sex_Ratio
FROM growth_and_literacy
GROUP BY district,state_name
HAVING AVG(sex_ratio)<1000
ORDER BY AVG(sex_ratio) ASC
LIMIT 5;

SELECT COUNT(district) AS Total_Cities, 
	state_name,
	ROUND(AVG(sex_ratio),0) AS Avg_Sex_Ratio
FROM growth_and_literacy
GROUP BY state_name
HAVING AVG(sex_ratio)<1000
ORDER BY COUNT(district) DESC
LIMIT 5;

-- Uttar Pradesh and Madhya Pradesh are two of the most backward states in terms of Sex_ratio in India.
-- Uttar Pradesh and Madhya Pradesh have 71 and 50 cities having sex ratio is less than 1000 respectively.



---Analyzing the literacy rate of India as per the Census Dataset---

SELECT AVG(literacy) AS Avg_literacy_rate 
FROM growth_and_literacy;
--Average literacy rate of India is 72.30%---


--State Wise Average Literacy rate
SELECT state_name, 
	AVG(literacy) AS Avg_literacy_rate 
FROM growth_and_literacy
GROUP BY state_name
Order BY AVG(literacy) DESC;

--Total Number of states having Average literacy rate is greater than India-----
SELECT state_name, 
	AVG(literacy) AS Avg_literacy_rate 
FROM growth_and_literacy
GROUP BY state_name
HAVING AVG(literacy)>72.30
Order BY AVG(literacy) DESC;
-- Total 24 States having Average literacy rate is greater than average of India.

--Total Number of states having Average literacy rate is below India-----
SELECT state_name, 
	AVG(literacy) AS Avg_literacy_rate 
FROM growth_and_literacy
GROUP BY state_name
HAVING AVG(literacy)<72.30
Order BY AVG(literacy) ASC;

-- Total 11 States having Average literacy rate is less than average of India.


SELECT district,
	state_name, 
	AVG(literacy) AS Avg_literacy_rate 
FROM growth_and_literacy
GROUP BY district,state_name
HAVING AVG(literacy)>72.30
Order BY AVG(literacy) DESC;
-- Total 316 Cities having Average literacy rate is greater than average of India--

SELECT district,
	state_name, 
	AVG(literacy) AS Avg_literacy_rate 
FROM growth_and_literacy
GROUP BY district,state_name
HAVING AVG(literacy)<72.30
Order BY AVG(literacy) ASC;
---Total 323 Cities having Average literacy rate is greater than average of India--


SELECT COUNT(DISTINCT district) AS Total_Cities,
	state_name, 
	AVG(literacy) AS Avg_literacy_rate 
FROM growth_and_literacy
GROUP BY state_name
HAVING AVG(literacy)>72.30
Order BY COUNT(DISTINCT district) DESC;
-- Maharashtra topping the chart which is having 35 cities which are above the national average.
-- Followed by Tamilnadu, which is having 32 cities.


SELECT COUNT(DISTINCT district) AS Total_Cities,
	state_name, 
	AVG(literacy) AS Avg_literacy_rate 
FROM growth_and_literacy
GROUP BY state_name
HAVING AVG(literacy)<72.30
Order BY COUNT(DISTINCT district) DESC;

-- Uttarpradesh and Madhya Pradesh having the most number of cities(71 & 50 respectively) which are below the national average.
-- Both Uttarpradesh and Madhya Pradesh have average literacy rate of 67% which is also below the national average.




--Top 5 cities in terms of highest literacy rate in India------
SELECT district,
	state_name, 
	AVG(literacy) AS Avg_literacy_rate 
FROM growth_and_literacy
GROUP BY district,state_name
HAVING AVG(literacy)>72.30
Order BY AVG(literacy) DESC
LIMIT 5;


--Bottom 5 cities in terms of lowst literacy rate in India------
SELECT district,
	state_name, 
	AVG(literacy) AS Avg_literacy_rate 
FROM growth_and_literacy
GROUP BY district,state_name
Order BY AVG(literacy) ASC
LIMIT 5;


-- District and State wise male and female population---

SELECT * FROM growth_and_literacy;
SELECT * FROM population_data;

ALTER TABLE growth_and_literacy
	ALTER sex_ratio TYPE FLOAT USING sex_ratio::FLOAT;

SELECT
	district,
	state_name,
	ROUND(((population)/(sex_ratio + 1))) AS Males,
	ROUND(((population*sex_ratio)/(sex_ratio + 1))) AS Females
FROM(
	SELECT G.district,
		G.state_name,
		G.sex_ratio/1000 AS Sex_Ratio,
		P.population
	FROM growth_and_literacy AS G
	INNER JOIN population_data AS P
	ON G.district = P.district) A
GROUP BY A.state_name,A.district,A.population,A.sex_ratio;

--- State and district wise Total Literate and illerate population---
SELECT
	district,
	state_name,
	Literacy_ratio*population AS Literate_People,
	((1-Literacy_ratio)*population) AS Illiterate_people
FROM(
	SELECT G.district,
		G.state_name,
		G.sex_ratio/1000 AS Sex_Ratio,
		G.literacy/100 AS Literacy_ratio,
		ROUND(P.population)
	FROM growth_and_literacy AS G
	INNER JOIN population_data AS P
	ON G.district = P.district) A
GROUP BY A.state_name,A.district,A.population,A.sex_ratio,A.Literacy_ratio;



-- District and state wise population comparison in 2011 and 2001 as per the growth rate--
SELECT G.district,
		G.state_name,
		G.sex_ratio/1000 AS Sex_Ratio,
		G.literacy/100 AS Literacy_ratio,
		ROUND(P.population) AS Population_in_2011,
		ROUND(((P.population)/(1+G.growth))) AS Population_in_2001,
		G.growth/100 AS Growth_Rate
FROM growth_and_literacy AS G
INNER JOIN population_data AS P
ON G.district = P.district
GROUP BY G.district,G.state_name,G.sex_ratio,G.literacy,P.population,G.growth
ORDER BY G.growth DESC;


--Total Population of India in 2011 & 2001 as per the growth rate---

SELECT ROUND(AVG(G.sex_ratio)) AS Avg_Sex_Ratio,
	ROUND(AVG(G.literacy)) AS Avg_Literacy_ratio,
	ROUND(SUM(P.population)) AS Population_in_2011,
	ROUND(SUM((P.population)/(1+G.growth))) AS Population_in_2001,
	ROUND(AVG(G.growth)) AS Avg_Growth_Rate
FROM growth_and_literacy AS G
INNER JOIN population_data AS P
ON G.district = P.district


SELECT G.district,
	G.state_name,
	G.sex_ratio AS Sex_Ratio,
	G.literacy AS Literacy_ratio,
	P.area_km2,
	ROUND(P.population) AS Total_Population,
	ROUND(P.population/P.area_km2) AS Population_denesity_per_km2
FROM growth_and_literacy AS G
INNER JOIN population_data AS P
ON G.district = P.district
GROUP BY G.district,G.state_name,G.sex_ratio,G.literacy,P.area_km2,P.population
ORDER BY Population_denesity_per_km2 DESC;



--- Top 3 Districts from each states having the highest literacy rate--
SELECT state_name, 
	district, 
	literacy_rate,
	Literacy_Rank
FROM
	(
	SELECT G.district,
		G.state_name,
		G.literacy AS literacy_rate,
		DENSE_RANK() OVER(PARTITION BY G.state_name ORDER BY G.literacy DESC) AS Literacy_Rank
	FROM growth_and_literacy AS G
	INNER JOIN population_data AS P
	ON G.district = P.district)A
WHERE A.Literacy_Rank<4;


--- Bottom 3 Districts from each states having the highest literacy rate--
SELECT state_name, 
	district, 
	literacy_rate,
	Literacy_Rank
FROM
	(
	SELECT G.district,
		G.state_name,
		G.literacy AS literacy_rate,
		DENSE_RANK() OVER(PARTITION BY G.state_name ORDER BY G.literacy ASC) AS Literacy_Rank
	FROM growth_and_literacy AS G
	INNER JOIN population_data AS P
	ON G.district = P.district)A
WHERE A.Literacy_Rank<4;