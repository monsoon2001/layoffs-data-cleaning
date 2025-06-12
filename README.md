# 📉 Layoffs Data Cleaning Project 🧹

This project demonstrates a complete SQL-based data cleaning process performed on a dataset of tech layoffs. The goal is to clean, standardize, and prepare the data for accurate analysis using best SQL practices.

---

## 📁 Files

- **`layoffs_data_cleaning.sql`** — Full SQL script for cleaning the layoffs dataset.
- **`README.md`** — Documentation and detailed breakdown of each step in the workflow.

---

## 🧽 Data Cleaning Workflow

### 🔍 Step 0: View Original Raw Data

- Display the raw `layoffs` table for reference.

### 🗑️ Step 1: Remove Duplicates

- Create a staging table `layoffs_staging` using `LIKE` to avoid modifying raw data.
- Insert all data from `layoffs` into `layoffs_staging`.
- Use `ROW_NUMBER()` to identify duplicates based on all columns.
- Create a CTE (`duplicate_cte`) to view and verify duplicate rows.
- Create a new table `layoffs_staging2` with an additional helper column `row_num`.
- Insert only unique rows (`row_num = 1`) into `layoffs_staging2`.

### 🧼 Step 2: Standardize the Data

- Trim whitespace from company names using `TRIM()`.
- Standardize industry values — unify inconsistent entries (e.g., all variations of "Crypto").
- Fix country names — remove trailing periods (e.g., "United States." → "United States").
- Convert date values from text (`MM/DD/YYYY`) to proper `DATE` format (`YYYY-MM-DD`).
- Alter the column type of the date column to `DATE`.

### 🚫 Step 3: Handle Null or Blank Values

- Identify rows where both `total_laid_off` and `percentage_laid_off` are `NULL`.
- Detect blank or `NULL` industry values.
- Check for companies that have both filled and missing industry values.
- Convert empty strings in industry to `NULL`.
- Update `NULL` industries using values from matching company names.
- Delete rows where both `total_laid_off` and `percentage_laid_off` are `NULL`.

### 🧹 Step 4: Drop Irrelevant Columns

- Drop the helper column `row_num` from `layoffs_staging2`.

---

## ✅ Final Output

The cleaned and standardized dataset is now in the table `layoffs_staging2`, ready for downstream analytics and reporting.

---

## 🛠 Technologies Used

- MySQL 8+
- SQL Window Functions (`ROW_NUMBER()`)
- Common Table Expressions (CTEs)
- String Manipulation Functions
- Date Formatting
- Joins and Subqueries

---

## 📊 Next Steps

You can now use the cleaned dataset for:

- 🧠 Exploratory Data Analysis (EDA)
- 📊 Data Visualization (Power BI, Tableau, etc.)
- 🔍 Predictive Modeling or Dashboard creation

---

## 👨‍💻 Author

Monsoon Parajuli  
[GitHub](https://github.com/monsoon2001) | [Portfolio](https://monsoon-portfolio.vercel.app)
