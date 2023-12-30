select *
from Coviddeaths
order by 3,4 ASC

-------- Selecting the data to use
--select location, date, total_cases, total_deaths, new_cases, population
--from Coviddeaths
where continent != ''
--order by 1,2

----Looking at the total cases vs total deaths
----shows the likelihood of dying from covid in Nigeria
--select location, date, total_cases, total_deaths, (convert(float,total_deaths) /nullif(convert(float,total_cases),0))*100 as DeathPercentage
--from Coviddeaths
--where location like '%Nigeria%'
--order by 1,2

----Looking at the total cases vs total deaths
----shows the likelihood of dying from covid in Korea
select location, date, cast(total_cases as int) as total_cases, cast(total_deaths as int) as total_deaths, (convert(float,total_deaths) /nullif(convert(float,total_cases),0))*100 as DeathPercentage
from Coviddeaths
where location like '%South Korea%' 
and continent is not null
order by 1,2


-- Explore the Total cases vs Total Population
-- Shows the percentage population had covid
SELECT location, date, CAST(total_cases AS INT) AS total_cases, CAST(population AS INT) AS population,(CAST(total_cases AS FLOAT) / CAST(population AS FLOAT)) * 100 AS CasePercentage
FROM Coviddeaths
WHERE location LIKE '%Nigeria%'
ORDER BY 1, 2

SELECT location, date, CAST(total_cases AS INT) AS total_cases, CAST(population AS INT) AS population,(CAST(total_cases AS FLOAT) / CAST(population AS FLOAT)) * 100 
AS CasePercentage
FROM Coviddeaths
WHERE location LIKE '%South Korea%'
ORDER BY 1, 2

-- Exploring countries with highest infection rate
Select location, population, Max(cast(total_cases as int)) as HighestInfectionCount, Max (Cast(total_cases as float)/ Cast (population as float))*100 as 
PercentPopulationInfected
From Coviddeaths
where continent != ''
Group by location, population
Order by PercentPopulationInfected desc

-- Exploring the HighestDeathCount per Population
Select location, Max(cast(total_deaths as int)) as TotalHighestDeathCount
From Coviddeaths
where continent != ''
Group by location
Order by TotalHighestDeathCount desc

-- Breaking by Continent with the highest death count

select continent, sum(cast(new_deaths as int)) as TotalDeathCount
from Coviddeaths
where continent != ''
group by continent
Order by TotalDeathCount DESC

-- Globally what is happening
SELECT
date, SUM(CAST(new_cases AS INT)) AS total_cases,
SUM(CAST(new_deaths AS INT)) AS total_deaths,
FROM coviddeaths
where continent != ''
GROUP BY
    date
ORDER BY
    date

	---------------------------------
 Select *
from Covidvaccination

-- Looking at total vaccination vs total population
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) Over (Partition by dea.location Order by dea.location, dea.date)
AS RollingPopVaccinations
from Coviddeaths dea
Join Covidvaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent != ''
and vac.continent != ''
order by 2,3

--Using CTE
With PopsVac (Continent, Location, Date, Population, new_vaccinations, RollingPopVaccinations)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) Over (Partition by dea.location Order by dea.location, dea.date)
AS RollingPopVaccinations
from Coviddeaths dea
Join Covidvaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent != ''
and vac.continent != ''
)
Select *, (RollingPopVaccinations/Population)*100
From
PopsVac

--Using Temp Table
Drop Table If Exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent varchar(255),
Location varchar (255),
Population numeric,
Date datetime,
New_vaccinations numeric,
RollingPopVaccinations numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) Over (Partition by dea.location Order by dea.location, dea.date)
AS RollingPopVaccinations
from Coviddeaths dea
Join Covidvaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent != ''
and vac.continent != ''
order by 2,3

Select *, (RollingPopVaccinations/Population)*100
From
#PercentPopulationVaccinated









