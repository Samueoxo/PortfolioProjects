select*
from portfolioproject..CovidDeaths
where continent is not null
order by 3,4

--select*
--from portfolioproject..CovidVaccinations
--order by 3,4

--select Data that we are going to use

select Location,date,total_cases,new_cases,total_deaths,population
from portfolioproject..covidDeaths
order by 1,2

--Looking at Total cases vs Total Deaths
--shows likelhood of dying if you contract the covid in your country

select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from portfolioproject..CovidDeaths
where location like '%Morocco%'
order by 1,2

-- Looking at total_cases vs population
--shows percentage of population that got covid

select Location,date,population,total_cases,(total_cases/population)*100 as PercentPopulationInfected
from portfolioproject..CovidDeaths
--where location like '%Morocco%'
order by 1,2

--Looking at country with Highest Infect Rate compared to the popualtion

select Location,population,MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
from portfolioproject..CovidDeaths
--where location like '%Morocco%'
Group by Location, population
order by PercentPopulationInfected desc

--showing countries with Highest Death Count per Population

select Location,MAX(Cast(Total_deaths as int)) as TotalDeathCount
from portfolioproject..CovidDeaths
--where location like '%Morocco%'
where continent is not null
Group by Location
order by TotalDeathCount desc

--LET'S BRING IT DOWN BY CONTINENT



--Showing continents with the Highest death Count Per Population

select continent,MAX(Cast(Total_deaths as int)) as TotalDeathCount
from portfolioproject..CovidDeaths
--where location like '%Morocco%'
where continent is not null
Group by continent
order by TotalDeathCount desc

--GLOBAL NUMBERS

select SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from portfolioproject..CovidDeaths
--where location like '%Morocco%'
where continent is not null
Group by date
order by 1,2

--Looking at Total Population vs Vaccinations



select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,dea.Date) as RollingPeopleVaccinated
 from portfolioproject..covidDeaths dea
 Join portfolioproject..covidVaccinations vac
 on dea.location = vac.location
 and dea. date = vac. date
 where dea.continent is not null
 --order by 2,3

 --USE CTE
 with popvsVac(continent,Date, Location,population,New_Vaccinations,RollingPeopleVaccinated)
 as
 (
 select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,dea.Date) as RollingPeopleVaccinated
 from portfolioproject..covidDeaths dea
 Join portfolioproject..covidVaccinations vac
 on dea.location = vac.location
 and dea. date = vac. date
 where dea.continent is not null
 --order by 2,3
 )
 select* , (RollingPeopleVaccinated/Population)*100
 from popvsVac

 DROP Table If exists ##PercentPopulationVaccinated
 --TEMP TABLE
 create table ##PercentPopulationVaccinated

 (
 continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 population numeric,
 new_vaccinations numeric,
 RollingPeopleVaccinated numeric
 )




 insert into ##PercentPopulationVaccinated

 select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
 SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,dea.Date) as RollingPeopleVaccinated
 from portfolioproject..covidDeaths dea
 Join portfolioproject..covidVaccinations vac
 on dea.location = vac.location
 and dea. date = vac. date
 --where dea.continent is not null
 --order by 2,3

 select* , (RollingPeopleVaccinated/Population)*100
 from ##PercentPopulationVaccinated 

 --creating view to store data for later visualizations

 create view PercentPopulationVaccinated as
  select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
 SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,dea.Date) as RollingPeopleVaccinated
 from portfolioproject..covidDeaths dea
 Join portfolioproject..covidVaccinations vac
 on dea.location = vac.location
 and dea. date = vac. date
 --where dea.continent is not null
 --order by 2,3

 select*
 from PercentPopulationVaccinated 




 



 
 
















