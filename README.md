# R Projects

R scripts for statistical analysis, visualisation and introductory machine learning, based on textbook and coursework exercises.

## Structure

```
├── R_Projects.Rproj   # RStudio project; open this to set the working directory
├── data/              # Input datasets
├── R/                 # Analysis scripts
└── output/            # Plots written when scripts run via Rscript (git-ignored)
```

## Projects

### Carseats Analysis: `R/carseats_analysis.R`

**Data:** `data/Carseats_dataset.csv` (car seat sales across store locations)

- Data structure, summary statistics and missing-value checks
- Correlation matrix of the numeric variables
- Income grouped into Low (< 40), Medium (40–80) and High (> 80)
- Bar, box, scatter and density plots
- One-sample and two-sample t-tests, plus percentiles
- Bootstrap estimate of the mean of an inflation-rate sample

### ATM Withdrawals Analysis: `R/atm_withdrawals_analysis.R`

**Data:** `data/ATM_Withdrawals.csv` (withdrawal amount vs. hours until the next withdrawal)

- Scatter plot, mean and standard deviation
- Linear regression: R², slope hypothesis test, residual plot and prediction
- CART regression tree
- Entropy and information gain calculated by hand for a small economic dataset, compared with an `rpart` classification tree

### Student Registration Decision Tree: `R/decision_tree_students.R`

**Data:** `data/students_registration.xlsx` (degree, finance type, marks and registration outcome for 100 students)

- Entropy and information gain calculated by hand to choose the best splitting feature
- Classification tree using the information-gain split criterion

## How to Run

1. Install the required packages:
   ```r
   install.packages(c("readr", "readxl", "dplyr", "ggplot2", "rpart", "rpart.plot"))
   ```
2. Open `R_Projects.Rproj` in RStudio, then open a script from `R/` and run it.

   Or, from the repository root on the command line:
   ```bash
   Rscript R/carseats_analysis.R
   ```
   Plots are then saved to `output/<script_name>.pdf`.

Scripts read data with paths relative to the repository root, so run them from there.

## Technologies

R · ggplot2 · dplyr · readr · readxl · rpart · rpart.plot

## License

MIT. See [LICENSE](LICENSE).
