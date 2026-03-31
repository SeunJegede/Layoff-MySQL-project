SELECT * from layoffs;

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT * from layoffs_staging;

INSERT INTO layoffs_staging
SELECT * 
FROM layoffs;

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,
`date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging
;

WITH duplicate_CTE AS(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,
`date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_CTE
where row_num > 1;

-- creating another staging table where we delete row_num greater than 2
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
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * from layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,
`date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging;

-- to remove restriction from deleting
SET SQL_SAFE_UPDATES = 1;

DELETE
FROM layoffs_staging2
WHERE row_num > 1;


-- Standardizing data: Fixing mistakes in data
SELECT *
from layoffs_staging2;

UPDATE layoffs_staging2
SET company = trim(company);

SELECT DISTINCT industry
from layoffs_staging2
;
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT country, trim( trailing '.' FROM country)
from layoffs_staging2
ORDER BY 1
;

UPDATE layoffs_staging2
SET country = trim( trailing '.' FROM country)
WHERE country LIKE 'United States%';

-- Change the data type and date format of the date column
SELECT `date`
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2 MODIFY COLUMN `date` DATE;

-- UPDATE layoffs_staging2
-- SET `date` = '2023-03-24'
-- WHERE `date` IS NULL;

-- debugging
ALTER TABLE layoffs_staging2 ADD COLUMN clean_date DATE;

UPDATE layoffs_staging2
SET clean_date = CASE
    WHEN `date` REGEXP '^[0-3][0-9]/[0-1][0-9]/[0-9]{4}$'
        THEN STR_TO_DATE(`date`, '%d/%m/%Y')
    WHEN `date` REGEXP '^[0-1][0-9]/[0-3][0-9]/[0-9]{4}$'
        THEN STR_TO_DATE(`date`, '%m/%d/%Y')
    WHEN `date` REGEXP '^[0-9]{4}-[0-1][0-9]-[0-3][0-9]$'
        THEN STR_TO_DATE(`date`, '%Y-%m-%d')
    ELSE NULL
END;

SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE clean_date IS NULL;

ALTER TABLE layoffs_staging2 DROP COLUMN `date`;
ALTER TABLE layoffs_staging2 CHANGE clean_date `date` DATE;
-- debugging 

ALTER TABLE layoffs_staging2 
MODIFY COLUMN `date` DATE;

-- Fill in blank cells for industry column
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL OR industry = '';

UPDATE layoffs_staging2
SET industry = null
WHERE industry = '';

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON  t1.company = t2.company
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT `date`, stage
FROM layoffs_staging2
WHERE stage LIKE 'Post%'
ORDER BY 1;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON  t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL; 

-- Deleting rows were bith total laid off and percentge laid off is blank
-- Thinking that it doesn't add to lay off analytical data
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
from layoffs_staging2;

-- Remove redundant row num column
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- Show column data types
SHOW COLUMNS FROM layoffs_staging2;



