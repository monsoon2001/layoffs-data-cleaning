-- DATA CLEANING WORKFLOW: LAYOFFS DATA
-- ---------------------------------------------------------------
-- 1. Remove Duplicates
-- 2. Standardize Data (e.g., Trim, Fix Spelling)
-- 3. Handle Null or Blank Values
-- 4. Drop Irrelevant Columns
-- ---------------------------------------------------------------

-- Step 0: View Original Raw Data
select *
from layoffs;

-- Step 1.1: Create a Staging Table to Work On (Best Practice)
-- creating a new table named 'layoffs_staging' with same column name as 'layoffs' table
-- cause working on the original raw table data is not appropriate
create table layoffs_staging
like layoffs
;

-- Step 1.2: Populate Staging Table with Raw Data
-- populating the 'layoff_staging' table with same data as 'layoffs' table
insert into layoffs_staging
select *
from layoffs
;

-- Step 1.3: Identify Duplicates using ROW_NUMBER() and PARTITION BY all columns
-- This helps us flag identical rows so we can keep only the first one
-- adding a new column named 'row_num'
-- same value will have row number as 1, 2, 3... and so on. but we need to keep only the row_num with value = 1
select *,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, 
`date`, stage, country, funds_raised_millions)  as row_num
from layoffs_staging
;

-- Step 1.4: Create a CTE to Extract Duplicate Records (row_num > 1)
-- like creating a temporary table or subquering
with duplicate_cte as
(
	select *,
	row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, 
    `date`, stage, country, funds_raised_millions)  as row_num
	from layoffs_staging
)
select * 
from duplicate_cte 
where row_num > 1
;

-- Step 1.5: Create Clean Table With row_num Column
-- creating a new table named 'layoffs_staging2' with a new added column 'row_num'
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

-- Step 1.6: Insert Only Unique Records (row_num = 1) into Clean Table
-- directly insert the data of table 'layoff_staging' into 'layoff_staging2' where row_num = 1
-- we can also add the data without row_num = 1 and later delete the value where row_num > 1
INSERT INTO layoffs_staging2
SELECT *
FROM (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, 
		percentage_laid_off, `date`, stage, country, funds_raised_millions
        ) AS row_num
    FROM layoffs_staging
) AS duplicate_cte
WHERE row_num = 1;

select *
from layoffs_staging2
;


-- 2. Standarizing data

-- Step 2.1: Trim Whitespace from Company Names
-- removes the white spaces of left and right side of company name
update layoffs_staging2
set company = trim(company)
;

-- Step 2.2: Standardize Industry Values (e.g., Merge All Variants of "Crypto")
select distinct industry    -- using distinct keyword removes the duplicates
from layoffs_staging2
order by 1                  -- sorts the first column automatically in ascending order
;

select *
from layoffs_staging2
where industry like 'Crypto%'
;

-- Clean up entries that start with "Crypto" but vary in naming
update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%'
;

select distinct country
from layoffs_staging2
order by 1                -- we can also use order by location
;

-- Step 2.3: Standardize Country Names (Remove Trailing Periods)
select distinct country , trim(trailing '.' from country)
from layoffs_staging2
order by 1
;

update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'United States%'
;

-- Step 2.4: Convert Date Format to Standard 'YYYY-MM-DD'
select `date`,
str_to_date(`date`, '%m/%d/%Y')    -- the month should be small 'm' not 'M'
from layoffs_staging2
;

-- first update date column from '12/16/2022' to '2022-12-16' standard format
update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y') 
;

-- only alter tabel in staging table, don't do this in original raw data table
-- previous format '10/12/2022' is in 'text' format
-- Then modify the column type from TEXT to DATE
alter table layoffs_staging2
modify column `date` Date
;


-- Step 3: Handle Null or Empty Fields
-- Step 3.1: Check rows where both layoff counts are NULL (likely invalid rows)
select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null
;

-- Step 3.2: Check rows with missing or blank industry values
select *
from layoffs_staging2
where industry is null
or industry = ''
;

-- Checking is a company has both a value and a null for same column name
select *
from layoffs_staging2
where company = 'Airbnb'
;

-- Step 3.3: Identify matching rows (same company) that have industry filled in
-- Try to populate the missing values if possible
select t1.company, t1.industry, t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
where (t1.industry is null)
and t2.industry is not null
;

-- Step 3.4: Convert empty string industries to NULL for consistency
update layoffs_staging2
set industry = null
where industry = ''
;

-- Step 3.5: Populate missing industries from other records with the same company name
update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
set t1.industry = t2.industry
where (t1.industry is null)
and t2.industry is not null
;

-- Step 3.6: Delete Records Where Both Layoff Columns Are NULL
delete
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null
;

-- Step 4: Drop Irrelevant Columns
-- Step 4.1: Drop Helper Column 'row_num' (no longer needed)
alter table layoffs_staging2
drop column row_num
;

-- Final Step: Clean Table Ready: layoff_staging2
select *
from layoffs_staging2
;
