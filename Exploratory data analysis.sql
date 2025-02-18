-- Exploratory data analysis

select *
from layoffs_staging2;

select company, sum(total_laid_off) SM
from layoffs_staging2
group by company
order by sm desc;

select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by 1
order by 1 desc;

select stage, sum(total_laid_off)
from layoffs_staging2
group by 1
order by 2 desc;

select substring(`date`, 1, 7) `month`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`, 1, 7) is not null
group by 1
order by 1 asc;


with rolling_total as
(
select substring(`date`, 1, 7) `month`, sum(total_laid_off) tot_off
from layoffs_staging2
where substring(`date`, 1, 7) is not null
group by `month`
order by 1 asc
)
select `month`, tot_off, sum(tot_off) over(order by `month`) roll_tot
from rolling_total 
;

with company_year (company, years, total_laid_off) as
(
select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
)
, company_year_ranking as
(
select *, dense_rank() over (partition by years order by total_laid_off desc) ranking
from company_year
where years is not null
)
select *
from company_year_ranking
where ranking <= 5;









