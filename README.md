# 🗃️ Layoff Data Cleaning & Exploration — MySQL Project

A MySQL-based project focused on cleaning and exploring a real-world layoff dataset to uncover trends across industries and companies.

---

## 📌 Overview

This project demonstrates end-to-end data work using MySQL — from raw CSV import through data cleaning to exploratory analysis. The dataset captures global layoff events and provides insight into which industries and companies were hit hardest.

---

## 🚀 Workflow

1. **Data Acquisition** — Sourced a sample layoff CSV dataset for analysis
2. **Database Setup** — Created a dedicated database and imported the CSV table using MySQL Workbench
3. **Data Cleaning** — Identified and resolved common data quality issues
4. **Exploratory Analysis** — Queried the cleaned data to surface meaningful patterns

---

## 🧹 Data Cleaning Steps

The raw dataset required several fixes before analysis could begin:

- Removed **trailing whitespace** from string fields
- Identified and dropped **duplicate rows**
- Handled **empty/null cells** that made entire rows unusable
- Standardised inconsistent values across key columns

---

## 🔍 Key Findings

| Insight | Description |
|---|---|
| **Max & Min Layoffs by Industry** | Identified which sectors faced the most and fewest layoffs |
| **Total Layoffs by Year** | Tracked how layoff volume changed over time |
| **Company Rankings** | Ranked companies by their total number of layoffs |

---

## 🛠️ Tools Used

- **MySQL Workbench** — Database creation, table import, and query execution
- **SQL** — Data cleaning and exploratory queries

---

## 🔭 Next Steps

The dataset has more to offer. Planned further exploration includes:

- Layoff trends by country and region
- Correlation between company funding stage and layoff size
- Month-over-month trend analysis

---

## 📁 Files

| File | Description |
|---|---|
| `layoffs.csv` | Raw source data |
| `data_cleaning.sql` | SQL scripts used for cleaning |
| `exploration.sql` | SQL scripts used for analysis |

