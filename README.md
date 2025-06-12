Layoffs Data Cleaning Project 🧹
This project contains a complete SQL-based data cleaning process performed on a dataset of tech layoffs. The goal is to clean, standardize, and prepare the data for accurate analysis using best SQL practices.

📁 Files
layoffs_data_cleaning.sql: Full SQL script for cleaning the layoffs dataset.

README.md: Documentation and breakdown of each step in the workflow.

🧽 Data Cleaning Workflow
Step 0: View Original Raw Data
Display raw layoffs table for reference.

Step 1: Remove Duplicates
1.1. Create staging table layoffs_staging using LIKE to avoid modifying raw data.
1.2. Insert all data from layoffs into layoffs_staging.
1.3. Use ROW_NUMBER() to identify duplicates based on all columns.
1.4. Create a CTE (duplicate_cte) to view duplicate rows.
1.5. Create new table layoffs_staging2 with same columns + row_num.
1.6. Insert only unique rows (row_num = 1) into layoffs_staging2.

Step 2: Standardize the Data
2.1. Trim whitespace from company names.
2.2. Standardize industry values, especially all variants of "Crypto".
2.3. Fix trailing periods in country values (e.g., "United States.").
2.4. Convert date values from TEXT (MM/DD/YYYY) to DATE format (YYYY-MM-DD), then alter the column type.

Step 3: Handle Null or Blank Values
3.1. Identify rows where both total_laid_off and percentage_laid_off are NULL.
3.2. Find blank or null industry values.
3.3. Check for companies with both filled and null industry values.
3.4. Convert empty strings to NULL in industry.
3.5. Update NULL industries using matching companies' filled values.
3.6. Delete rows where both total_laid_off and percentage_laid_off are NULL.

Step 4: Drop Irrelevant Columns
4.1. Drop helper column row_num from layoffs_staging2.

✅ Final Output
The cleaned table is layoffs_staging2 and is ready for downstream analytics and reporting.

🛠 Technologies Used
MySQL 8+

SQL Window Functions (ROW_NUMBER())

CTEs (Common Table Expressions)

Joins, String Functions, and Date Formatting

📊 Next Steps
You can now use layoffs_staging2 for:

Exploratory Data Analysis (EDA)

Data visualization in tools like Power BI or Tableau

Further transformation and modeling

👨‍💻 Author
Monsoon Parajuli
[GitHub](https://github.com/monsoon2001) | [Portfolio](https://monsoon-portfolio.vercel.app) 
