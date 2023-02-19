create database covid_analysisproject;
SELECT * FROM covid_analysisproject. `covid_vaccine`
order by 3,4;
SELECT * FROM covid_analysisproject. `covid_deaths`
order by 3,4;
select location, date, total_cases, new_cases, total_deaths, population
from covid_analysisproject. `covid_deaths`
order by 1,2;

---looking at total cases vs total deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage
from covid_analysisproject. `covid_deaths`
where location like '%afghanistan%'
order by 1,2;

---looking at Total cases vs population
---- shows what percentage of the population got Covid
select location, date, population, total_cases, (total_cases/population)*100 as totalpercentage
from covid_analysisproject. `covid_deaths`
where location like '%afghanistan%'
order by 1,2;

------looking at Afghanistan highest infection rate compared to its population

select location, population, max(total_cases) as highestinfectioncount, max(total_cases/population)*100 as percentpopulationinfected
from covid_analysisproject. `covid_deaths`
where location like '%afghanistan%'
group by location, population
order by percentpopulationinfected;

----showing Afghanistan highest death count
select location, max(total_deaths) as totaldeathcount
from covid_analysisproject. `covid_deaths`
where location like '%afghanistan%'
group by location
order by totaldeathcount;

---total death count by continent
select continent, max(total_deaths) as totaldeathcount
from covid_analysisproject. `covid_deaths`
where continent is not null
group by continent 
order by totaldeathcount asc;

----showing the continent with highest death count
select continent, max(total_deaths) as highestdeathcount
from covid_analysisproject. `covid_deaths`
where continent is not null
group by continent 
order by highestdeathcount;

select date, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_cases)/sum(new_deaths)*100 as deathpercentage
from covid_analysisproject. `covid_deaths`
where location like '%afghanistan%'
group by date
order by 1,2;

---total cases and total_deaths
select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_cases)/sum(new_deaths)*100 as deathpercentage
from covid_analysisproject. `covid_deaths`
where location like '%afghanistan%'
order by 1,2;
---join both tables 
SELECT * 
FROM covid_analysisproject. `covid_vaccine`
join covid_analysisproject. `covid_deaths`
on covid_analysisproject. `covid_vaccine`.location = covid_analysisproject. `covid_deaths`.location
and covid_analysisproject. `covid_vaccine`.date = covid_analysisproject. `covid_deaths`.date

---looking at total population vs vaccinations
SELECT  covid_deaths.continent,covid_deaths.location,covid_deaths.date,covid_deaths.population,covid_vaccine.new_vaccinations
FROM covid_analysisproject. `covid_vaccine`
join covid_analysisproject. `covid_deaths`
on covid_analysisproject. `covid_vaccine`.location = covid_analysisproject. `covid_deaths`.location
and covid_analysisproject. `covid_vaccine`.date = covid_analysisproject. `covid_deaths`.date
order by 1,2,3;

SELECT  covid_deaths.continent,covid_deaths.location,covid_deaths.date,covid_deaths.population,covid_vaccine.new_vaccinations,
sum(covid_vaccine.new_vaccinations) over (partition by covid_deaths.location) as people_vaccinated
FROM covid_analysisproject. `covid_vaccine`
join covid_analysisproject. `covid_deaths`
on covid_analysisproject. `covid_vaccine`.location = covid_analysisproject. `covid_deaths`.location
and covid_analysisproject. `covid_vaccine`.date = covid_analysisproject. `covid_deaths`.date
order by 1,2,3;

-----using temp table

CREATE TEMPORARY TABLE percentage_population_vacinated(
continent varchar(40),
location varchar(55),
date varchar(15),
population int,
new_vaccinations text,
people_vaccinated int
);
insert into  percentage_population_vacinated
SELECT  covid_deaths.continent,covid_deaths.location,covid_deaths.date,covid_deaths.population,covid_vaccine.new_vaccinations,
sum(covid_vaccine.new_vaccinations) over (partition by covid_deaths.location) as people_vaccinated
FROM covid_vaccine
join covid_deaths
on covid_vaccine.location = covid_deaths.location
and covid_vaccine.date = covid_deaths.date
where covid_deaths.continent is not null ;
 select * from percentage_population_vacinated;

----creating view to store data for visualization 
create view percentage_population_vacinated as
SELECT  covid_deaths.continent,covid_deaths.location,covid_deaths.date,covid_deaths.population,covid_vaccine.new_vaccinations,
sum(covid_vaccine.new_vaccinations) over (partition by covid_deaths.location) as people_vaccinated
FROM covid_vaccine
join covid_deaths
on covid_vaccine.location = covid_deaths.location
and covid_vaccine.date = covid_deaths.date
where covid_deaths.continent is not null;
SELECT * FROM covid_analysisproject.percentage_population_vacinated;