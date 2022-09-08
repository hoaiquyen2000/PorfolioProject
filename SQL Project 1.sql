select *
from Jos_porfolio..CovidDeaths
where continent is not null
order by 3,4


--select *
--from Jos_porfolio..CovidVaccinations
--order by 3,4

select location,date, total_cases, new_cases, total_deaths, population
from Jos_porfolio..CovidDeaths
where continent is not null
order by 1,2


--Looking at total_cases and total_deaths
--Show likelihood of dying if you contract covid in your country

select location,date,total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from Jos_porfolio..CovidDeaths
where location like 'Vietnam' and continent is not null
order by 1,2

--Looking at Total cases vs Population 
--Show percentage of population got Covid

select location,date,total_cases,population,(total_cases/population)*100 as Infected_Percentage
from Jos_porfolio..CovidDeaths
where continent is not null
--where location like 'Vietnam'
order by 1,2

--Looking at countries which Highest Infection Rate compared to Population

select location,population, max(total_cases) as Higest_Infection_Count, 
		max(total_cases/population)*100 as Infected_Percentage
from CovidDeaths
where continent is not null
group by location, population 
--where location like 'Vietnam'
order by Infected_Percentage desc

--Looking at countries which Highest Death Count compared per Population

select location, max(cast(total_deaths as int)) as TotalDeath_Count
from CovidDeaths
where continent is not null
group by location
--where location like 'Vietnam'
order by TotalDeath_Count desc

--BREAK THINGS DOWN BY CONTINENTS 


--Showing the continents with highest death count per population 


select continent, max(cast(total_deaths as int)) as TotalDeath_Count
from CovidDeaths
where continent is not null
group by continent
--where location like 'Vietnam'
order by TotalDeath_Count desc


--Global numbers 

select	date, 
		sum(new_cases) as Total_new_cases, 
		sum(cast(new_deaths as float)) as Total_new_deaths,
		(sum(cast(new_deaths as int))/sum(new_cases))*100 as Death_Percentage
from Jos_porfolio..CovidDeaths
--where location like 'Vietnam' and 
where continent is not null
group by date
order by 1,2


--Looking at Total Population vs Vaccinations

with PopvsVac (continent,location,date,population,new_vaccinations,total_vaccinations) 
as 
(
select distinct dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, vac.total_vaccinations
from CovidDeaths dea inner join CovidVaccinations vac
	on dea.location = vac.location 
	and dea.continent = vac.continent
	and	dea.date = vac.date
where dea.continent is not null
)
select *, (total_vaccinations/population)*100 from PopvsVac 
order by 2,3


--TEMP TABLE
drop table if exists PopvsVac
create table PopvsVac (
				continent nvarchar(255),
				location nvarchar(255),
				date datetime,
				population numeric,
				new_vaccinations numeric,
				total_vaccinations numeric,
				)
insert into PopvsVac 
	select distinct dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, vac.total_vaccinations
	from CovidDeaths dea inner join CovidVaccinations vac
	on dea.location = vac.location 
	and dea.continent = vac.continent
	and	dea.date = vac.date
	--where dea.continent is not null 
select *, (total_vaccinations/population) *100  from PopvsVac
order by 2,3


--Create View to Store Data for later Visualizations

Create View PopvsVacc as 
select distinct dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, vac.total_vaccinations
	from CovidDeaths dea inner join CovidVaccinations vac
	on dea.location = vac.location 
	and dea.continent = vac.continent
	and	dea.date = vac.date
where dea.continent is not null 
--order by 2,3

Select * from PopvsVacc
