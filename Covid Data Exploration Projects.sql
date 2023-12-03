#Importing CovidDeaths
SELECT * FROM portfolio_project_covid_19.coviddeaths;
select count(*) from coviddeaths;
TRUNCATE table coviddeaths;
DESCRIBE coviddeaths;

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CovidDeaths.csv'
INTO TABLE coviddeaths
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
ignore 1 rows;
#Will show a "--secure-file-priv" error

SHOW VARIABLES like "--secure-file-priv";
#The value will show null which means we need to configure it. Or copy the data to path
#C:\ProgramData\MySQL\MySQL Server 8.0\Uploads

#Since some of the data is out of range for int32(DEfault) we need to
#change the dtype of column to int64 - BIGINT
alter TABLE coviddeaths
MODIFY population BIGINT;

#Similarly Import CovidVaccinations
SELECT * FROM portfolio_project_covid_19.covidvaccinations;
TRUNCATE table covidvaccinations;
DESCRIBE covidvaccinations;

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CovidVaccinations.csv'
INTO TABLE covidvaccinations
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
ignore 1 rows;

----------------------------------------------------------------------------------------------------------------------------
#Queries:-
#1 Selecting which data we are using

select location, date, total_cases, new_cases, total_deaths, population
from coviddeaths
order by 1,2;

#2 Looking at Total Cases vs Total Deaths country wise (Chance of death)

select location, date, total_cases, total_deaths, round((total_deaths/total_cases)*100,2) as 'Death%'
from coviddeaths
order by 1,2;

#3 Looking at Total Cases vs Total Deaths of India (Chance of death)

select location, date, total_cases, total_deaths, round((total_deaths/total_cases)*100,2) as 'Death%'
from coviddeaths
where location like "India"
order by 2;

#4 Looking at Total Cases vs Total Deaths of India (What % of population got covid)

select location, date, total_cases, population, round((total_cases/population)*100,2) as 'Infection%'
from coviddeaths
where location like "India"
order by 3;

#5 Countries with highest Infection Rate compared to population

select location, population, MAX(total_cases) as HighestInfectionCount, Max(round((total_cases/population)*100,2)) as 'InfectedPopulation%'
from coviddeaths
group by location, population
order by 4 desc;

#6 Countries with highest death count per population
select location, MAX(cast (total_deaths as BIGINT)) as TotalDeaths
from coviddeaths
where continent is not null
group by location, population
order by 2;
DESC coviddeaths;

#7 Continents with highest death count per population #ASK mam about the output
select continent, MAX(total_deaths) as TotalDeaths
from coviddeaths
where continent is not null
group by continent
order by 2;

#8 Deaths join Vaccination
SELECT * FROM portfolio_project_covid_19.covidvaccinations;

select * 
from coviddeaths as deaths
join covidvaccinations as vac
on deaths.location = vac.location and deaths.date = vac.date;

#9 Total population that have been vacinated
select deaths.continent, deaths.location, deaths.date, deaths.population, vac.new_vaccinations
from coviddeaths as deaths
join covidvaccinations as vac
on deaths.location = vac.location and deaths.date = vac.date
where deaths.continent is not null;

