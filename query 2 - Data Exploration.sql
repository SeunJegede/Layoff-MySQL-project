SELECT * 
FROM layoffs_staging2;

-- Maximum number of layoffs per company
SELECT company, max(total_laid_off) as max_laid_off, max(percentage_laid_off) as max_per_off
FROM layoffs_staging2
GROUP BY company
ORDER BY max_laid_off desc;

-- Total number of layoffs per company
SELECT company, SUM(total_laid_off) as total_laid_off
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 desc;

-- The date range for these layoffs
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- Number of layoffs by industry
SELECT industry, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 desc;

SELECT country, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 desc;

SELECT YEAR(`date`) as year, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY year
ORDER BY 1 desc;

SELECT stage, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY stage DESC;

SELECT SUBSTRING(`date`, 1,7) AS month_year, SUM(total_laid_off) as total
FROM layoffs_staging2
GROUP BY month_year
ORDER BY 1 asc;

-- Calculating the rolloing total of layoffs by months
WITH Rolling_Total AS (
SELECT SUBSTRING(`date`, 1,7) AS month_year, SUM(total_laid_off) as total
FROM layoffs_staging2
GROUP BY month_year
ORDER BY 1 asc
)
SELECT month_year, total, SUM(total) OVER(ORDER BY month_year) as rolling_total
FROM Rolling_Total;

-- Calculating layoffs per month for company
SELECT company, YEAR(`date`), SUM(total_laid_off) as sum_total
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 desc;

-- Ranking companies by total layoffs per year
WITH Company_Year(company, years, total_laid_off) AS(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Ranking AS
(
SELECT *,
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off desc) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL)
SELECT *
FROM Company_Ranking 
WHERE Ranking <= 5;
 