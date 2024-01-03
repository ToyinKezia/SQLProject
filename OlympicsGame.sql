Select * from Athlete
order by year DESC

--Exploring Athlete who won Gold medal during the Summer Olympic Games
Select name, Age, Sex, Games, season, medal 
from Athlete
where medal = 'Gold'
and Season LIKE '%Summer%'
Order by Season DESC

--Exploring Athlete who won Gold medal during the Winter Olympic Games
Select name, Age, Sex, Games, medal, Season
from Athlete
where medal = 'Gold'
and Games LIKE '%Winter%'
Order by Season DESC

-- How many Olympics games have been held
Select count(distinct games)
from Athlete

-- Where are the Olympics games held so far
Select  distinct (year), season, city
from Athlete
order by year

--Identify the sport played in all summer olympics
select sport, count( distinct games) as no_of_games
from Athlete
where season = 'Summer'
group by sport
Order by sport DESC

--Identify the sport played in winter olympics
select sport, count( distinct games) as no_of_games
from Athlete
where season = 'Winter'
group by sport
Order by sport DESC

-- The total number of nations that participated in each Olympic games
select games, count( distinct NOC) as total_countries
from Athlete
group by games
order by total_countries DESC


-- which year saw the highest and lowest no of participating countries
select year, count( distinct NOC) as NoofParticipatingCountries from Athlete
group by year
order by NoofParticipatingCountries DESC

-- which nation has participated in all the olympics games
SELECT NOC, COUNT(DISTINCT games) AS participated_in_all_games
FROM Athlete
GROUP BY NOC
HAVING COUNT(DISTINCT games) = (SELECT count(DISTINCT games) FROM Athlete)

-- how many sports were played just once in the olympic games
SELECT sport
from Athlete
group by Sport
HAVING COUNT(DISTINCT Games) <= 1

-- total number of sports played in each games
select count(distinct sport) as total_no_of_sport, games 
from Athlete
group by games
order by total_no_of_sport DESC

-- find the oldest person to win a gold medal
select Name, Sex, Team, NOC, Age
from Athlete
where medal = 'Gold' and 
Age = (select max(Age) from Athlete where Medal = 'Gold')

-- the top 5 athletes who have won the most gold medals

Select top 5 ath.name, reg.region, count(ath.medal) as total_medal
from Athlete ath join NOCRegions reg
on ath.noc = reg.noc
where ath.medal = 'gold'
group by ath.Name, reg.region
order by total_medal DESC

-- the top 5 athletes who have won the most medal
Select top 5 ath.name, reg.region, count(ath.medal) as total_medal
from Athlete ath join NOCRegions reg
on ath.noc = reg.noc
where ath.medal in ('Silver', 'Bronze', 'Gold')
group by ath.Name, reg.region
order by total_medal DESC

-- the top 5 countries with the most number of medal
Select top 5 reg.region, count(ath.medal) as total_medal
from Athlete ath join NOCRegions reg
on ath.noc = reg.noc
where ath.medal IN ('Silver', 'Bronze', 'Gold')
group by reg.region
order by total_medal DESC

--the total number of medal won by each country
Select distinct reg.region, count(ath.medal) as total_medal
from Athlete ath join NOCRegions reg
on ath.noc = reg.noc
where ath.medal IN ('Silver', 'Bronze', 'Gold')
group by reg.region
order by total_medal DESC

-- list down the total gold, Silver and Bronze medals by each country
select reg.region,
count(Case when ath.medal = 'Gold' then 1 end) As Gold,
count(Case when ath.medal = 'Silver' then 1 end) as Silver,
count(Case when ath.medal = 'Bronze' then 1 end) as Bronze
from Athlete ath join NOCRegions reg
on ath.noc = reg.noc
group by reg.region
order by Gold, Silver, Bronze DESC

-- listing down the total gold, silver and bronze medals won by each country in each game
select ath.games, reg.region,
count(Case when ath.medal = 'Gold' then 1 end) As Gold,
count(Case when ath.medal = 'Silver' then 1 end) as Silver,
count(Case when ath.medal = 'Bronze' then 1 end) as Bronze
from Athlete ath join NOCRegions reg
on ath.noc = reg.noc
group by reg.region, ath.games
order by reg.region, ath.games 

-- identify the country with the most medals in each olympic games
select ath.games, reg.region,
count(Case when ath.medal = 'Gold' then 1 end) As Gold,
count(Case when ath.medal = 'Silver' then 1 end) as Silver,
count(Case when ath.medal = 'Bronze' then 1 end) as Bronze
from Athlete ath join NOCRegions reg
on ath.noc = reg.noc
group by reg.region, ath.games
order by Gold DESC, Silver DESC, Bronze DESC 

-- MEdals won by India for Hockey in Olympic Games
select ath.Games, count(ath.medal) as total_medals
from Athlete ath join NOCRegions reg
on ath.noc = reg.noc
where ath.Sport = 'Hockey'
and reg.region = 'India'
and medal != 'NA'
group by ath.Games
order by total_medals DESC, ath.Games DESC