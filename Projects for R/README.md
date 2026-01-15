# R Analysis Projects

This folder contains two comprehensive R projects focused on statistical analysis and data exploration.

## Projects Overview

### 1. Carseats Analysis (`Carseats_Analysis.R`)

**Dataset**: `Carseats_dataset.csv`

**Description**: 
This project performs exploratory data analysis and data manipulation on the Carseats dataset, which contains information about car seat sales across different locations.

**Key Analysis**:
- Data structure exploration and summary statistics
- Missing value detection
- Correlation matrix calculation for numeric variables
- Income categorization into three groups: "Low" (< 40), "Medium" (40-80), and "High" (> 80)
- Data visualization and transformation

**Libraries Used**:
- `readr` - Data import
- `dplyr` - Data manipulation
- `ggplot2` - Data visualization

**Learning Focus**: Data exploration, data wrangling, categorical variable creation, and correlation analysis

---

### 2. ATM Withdrawals Analysis (`ATM_Withdrawals_Analysis.R`)

**Dataset**: `ATM_Withdrawals.csv`

**Description**: 
This project analyzes ATM withdrawal patterns using regression analysis and predictive modeling. It examines the relationship between withdrawal amounts and the time until the next ATM visit.

**Key Analysis**:
- Scatter plot visualization of withdrawal amounts vs. time until next withdrawal
- Descriptive statistics (mean and standard deviation)
- Linear regression modeling
- R-squared value interpretation
- Residual plot analysis
- Predictive modeling (forecasting next ATM visit time)
- CART regression tree implementation

**Libraries Used**:
- `readr` - Data import
- `ggplot2` - Data visualization
- `rpart` - Decision tree/CART regression
- `rpart.plot` - Tree visualization

**Learning Focus**: Regression analysis, model diagnostics, predictive modeling, and machine learning with decision trees

---

## How to Run

1. Ensure you have R and RStudio installed
2. Install required libraries (if not already installed):
   ```r
   install.packages(c("readr", "dplyr", "ggplot2", "rpart", "rpart.plot"))
   ```
3. Open either script in RStudio
4. Ensure the corresponding CSV file is in the same directory
5. Run the script line-by-line or execute the entire script

## Dataset Files

- `Carseats_dataset.csv` - Car seat sales data
- `ATM_Withdrawals.csv` - ATM withdrawal transaction records

## Technologies

- **R** - Statistical computing and graphics
- **ggplot2** - Data visualization
- **dplyr** - Data manipulation
- **rpart** - Classification and regression trees

## Purpose

These projects demonstrate practical applications of:
- Exploratory data analysis
- Statistical modeling and inference
- Predictive analytics
- Data visualization best practices
