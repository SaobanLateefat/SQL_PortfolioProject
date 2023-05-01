select *
from portfolioProject..CovidDeaths$
order by 3,4

--select *
--from portfolioProject..CovidDeaths$
--order by 3,4

--select data

select location, date, total_cases, new_cases, total_deaths, population
from portfolioProject..CovidDeaths$
order by 1,2

-- looking at the total cases vs total death
-- Shows the likelihood of dying if one contract covid in Nigeria
select location, date, total_cases, total_deaths, (total_deaths / total_cases)*100 as DeathPercentage
from portfolioProject..CovidDeaths$
where location like '%nigeria%'
order by 1,2


--Looking at the total cases vs population
-- Shows what percentage of population got covid

select location, date, population, total_cases, (total_cases / population)*100 as PercentPopulation
from portfolioProject..CovidDeaths$
where location like '%nigeria%'
order by 1,2


--Looking at country with highest infection rate compared to population

select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases / population))*100 as PercentPopulationInfected
from portfolioProject..CovidDeaths$
Group by Location, population
order by 1,2

-- Showing countries with highest death count per population

select location, max(cast(total_deaths as int))as TotalDeathCount
from portfolioProject..CovidDeaths$
where continent is null
Group by Location
order by TotalDeathCount desc

--Breaking things down by continent

select continent, max(cast(total_deaths as int))as TotalDeathCount
from portfolioProject..CovidDeaths$
where continent is not null
Group by continent
order by TotalDeathCount desc


--showing continent with the highest death count per population

select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from portfolioProject..CovidDeaths$
where continent is not null
Group by continent
order by TotalDeathCount desc


--Global Numbers
select date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from portfolioProject..CovidDeaths$
where continent is not null
order by 1,2


-- Looking at total population vs vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	Sum(CONVERT(int, vac.new_vaccinations))  OVER (partition by dea.location order by dea.location, dea.date) as Sum_new_vaccination
from portfolioProject..CovidDeaths$ dea
join portfolioProject..CovidDeaths$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3



-- Use CTE
 
With PopvsVac (Continent, Location, Date, Population,New_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	Sum(CONVERT(int, vac.new_vaccinations))  OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from portfolioProject..CovidDeaths$ dea
join portfolioProject..CovidDeaths$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select*, (RollingPeopleVaccinated/Population)*100
From PopvsVac





--TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric,
)



Insert into #PercentPopulationVaccinated
	
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
Sum(CONVERT(int, vac.new_vaccinations))  OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from portfolioProject..CovidDeaths$ dea
join portfolioProject..CovidDeaths$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select*, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




-- Creating view to store data for later visualizations

Create View PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	Sum(CONVERT(int, vac.new_vaccinations))  OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from portfolioProject..CovidDeaths$ dea
join portfolioProject..CovidDeaths$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *
from PercentPopulationVaccinated












