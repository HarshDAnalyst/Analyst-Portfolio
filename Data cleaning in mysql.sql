-- Data cleaning

select *
from layoffs;

-- 1. Remove Duplicates
-- 2. Standadrize the Data
-- 3. Null values or blank value
-- 4. Remove Any columns


create table layoffs_staging
like layoffs;

select *
from layoffs_staging;


insert into layoffs_staging
 select * 
 from layoffs;

select *
from layoffs_staging;


with duplicate_cte as
(
select * ,
row_number() over( 
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions)
as row_num
from layoffs_staging
)
select *
from duplicate_cte
where row_num > 1;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



insert into layoffs_staging2
select * ,
row_number() over( 
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions)
as row_num
from layoffs_staging;



delete from layoffs_staging2
where row_num > 1;

select * 
from layoffs_staging2
where row_num > 1;


-- standardizing data


select company, trim(company)
from layoffs_staging2;     

update layoffs_staging2
set company = trim(company);

select company
from layoffs_staging2;

select distinct industry
from layoffs_staging2
order by industry;

select industry 
from layoffs_staging2
where industry like 'crypto%';


update layoffs_staging2
set industry = 'crypto'
where industry like 'crypto%'
;

update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

select `date`
from layoffs_staging2;

alter table layoffs_staging2
modify column `date` date;

 

-- working with null and blank values

select * 
from layoffs_staging2;

select *
from layoffs_staging2
where industry is null
or industry = '';

update layoffs_staging2
set industry = null
where industry = '';


update layoffs_staging2 t1
join layoffs_staging2 t2
  on t1.company = t2.company
  set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null;


select *
from layoffs_staging2
where company like 'Bally%';

-- deleting coloumns

select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

delete from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

select *
from layoffs_staging2;

alter table layoffs_staging2
drop column row_num;



