use Portfolio;

select * from CovidDeaths order by location , date;

select * from CovidVacc order by location , date

select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths
order by location , date

-- Looking Total Cases vs Total Deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from CovidDeaths
where location='india'
order by location , date

-- Looking Total Cases vs Population

select location, date, population, total_cases, (total_cases/population) as Infection_rate
from CovidDeaths
where location='india'
order by location , date

-- Countries with the highest infection rate

select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as Infection_rate
from CovidDeaths
group by location , population
order by Infection_rate DESC

-- Countries with the highest death count againt the total cases

Select location, max(total_cases) as TotalCases, max(total_deaths) as TotalDeaths
from CovidDeaths
group by location
order by TotalDeaths desc

Select location, max(total_cases) as TotalCases, max(total_deaths) as TotalDeaths
from CovidDeaths
where continent is not null
group by location
order by TotalDeaths desc

-- Countries with the highest death count againt the population

Select location, max(cast(population as int)) as TotalPopulation, max(cast(total_deaths as int)) as TotalDeaths
from CovidDeaths
where continent is not null
group by location
order by TotalDeaths desc

-- Looking at the data continent wise

Select continent, max(cast(population as int)) as TotalPopulation, max(cast(total_deaths as int)) as TotalDeaths
from CovidDeaths
where continent is not null
group by continent
order by TotalDeaths desc

-- Total cases and deaths globally date wise

Select date, sum(new_cases) as Total_Cases, sum(cast(new_deaths as int)) as Total_Deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as Death_Percentage
from CovidDeaths
where continent is not null
group by date
order by 1,2

-- Grand total of cases, deaths and death percentage globally

Select sum(new_cases) as Total_Cases, sum(cast(new_deaths as int)) as Total_Deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as Death_Percentage
from CovidDeaths
where continent is not null
order by 1,2

-- Total populations vs Vaccinated population

select CovidDeaths.continent, CovidDeaths.location, CovidDeaths.date, CovidDeaths.population, CovidVacc.new_vaccinations,
sum(convert(int,CovidVacc.new_vaccinations)) over (partition by CovidDeaths.location order by CovidDeaths.location, CovidDeaths.date)
as PeopleVaccinated, (sum(convert(int,CovidVacc.new_vaccinations)) over (partition by CovidDeaths.location order by CovidDeaths.location, CovidDeaths.date)/population)*100 as VaccPercentage
from CovidDeaths join CovidVacc	
	on CovidDeaths.location = CovidVacc.location
	and CovidDeaths.date = CovidVacc.date
where CovidDeaths.continent is not null
order by 2,3

-- Creating views for the visualizations

create view VaccinatedPopulation as
select CovidDeaths.continent, CovidDeaths.location, CovidDeaths.date, CovidDeaths.population, CovidVacc.new_vaccinations,
sum(convert(int,CovidVacc.new_vaccinations)) over (partition by CovidDeaths.location order by CovidDeaths.location, CovidDeaths.date)
as PeopleVaccinated, (sum(convert(int,CovidVacc.new_vaccinations)) over (partition by CovidDeaths.location order by CovidDeaths.location, CovidDeaths.date)/population)*100 as VaccPercentage
from CovidDeaths join CovidVacc	
	on CovidDeaths.location = CovidVacc.location
	and CovidDeaths.date = CovidVacc.date
where CovidDeaths.continent is not null
