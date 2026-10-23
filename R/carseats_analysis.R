# Carseats Analysis
# Exploratory analysis, visualisation and hypothesis tests on the Carseats
# dataset, followed by a bootstrap example on inflation rates.
# Run from the project root (open R_Projects.Rproj in RStudio).

# Load necessary libraries
library(readr)
library(dplyr)
library(ggplot2)

# Save plots to output/ when run non-interactively (e.g. with Rscript)
if (!interactive()) {
  dir.create("output", showWarnings = FALSE)
  pdf(file.path("output", "carseats_analysis.pdf"))
}

# Import the Carseats csv dataset
Carseats <- read_csv(file.path("data", "Carseats_dataset.csv"), show_col_types = FALSE)

# Check data structure of Carseats dataset
str(Carseats)

# Display the data type for each variable in the Carseats dataset
# Number of columns in dataset
ncol(Carseats)

# Number of rows in dataset
nrow(Carseats)

# Data types within dataset
sapply(Carseats, class)

# Display summary statistics for the Carseats dataset
summary(Carseats)

# Check for missing values in the Carseats dataset
sum(is.na(Carseats))

# Extract only the numeric variables from the Carseats dataset
Carseats_num <- select(Carseats, where(is.numeric))
print(Carseats_num)

# Calculate the correlation matrix from the Carseats_num dataset
cor_matrix <- cor(Carseats_num)
print(cor_matrix)

# Create a new column called IncomeCategory and classify income into three
# groups "Low" (below 40), "Medium" (40-80) and "High" (above 80)
Carseats <- Carseats %>%
  mutate(IncomeCategory = case_when(
    Income < 40 ~ "Low",
    Income <= 80 ~ "Medium",
    TRUE ~ "High"
  )) %>%
  mutate(IncomeCategory = factor(IncomeCategory, levels = c("Low", "Medium", "High")))

# Number of entries in each category
table(Carseats$IncomeCategory)

# Bar chart visualising the distribution of IncomeCategory
ggplot(Carseats, aes(x = IncomeCategory)) +
  geom_bar(fill = "coral") + ggtitle("Distribution of IncomeCategory")

# Box plot of Sales using ShelveLoc
ggplot(Carseats, aes(x = ShelveLoc, y = Sales)) +
  geom_boxplot(fill = "cyan") + ggtitle("Sales by ShelveLoc")

# Scatter plot of Sales versus Advertising
ggplot(Carseats, aes(x = Advertising, y = Sales)) +
  geom_point(colour = "green", size = 2) + ggtitle("Sales vs Advertising")

# Density plot for Price with the mean marked
ggplot(Carseats, aes(x = Price)) + geom_density(color = "purple") +
  ggtitle("Density Plot of Price") +
  geom_vline(xintercept = mean(Carseats$Price),
             color = "blue", linetype = "dashed", linewidth = 1)

# Hypothesis test to check the mean Sales is different from 7 using a one-sample t.test
test <- t.test(Carseats$Sales, mu = 7, alternative = "two.sided")
print(test)

# Hypothesis test to check the mean Price differs between urban and rural stores using a two-sample t.test
test2 <- t.test(Price ~ Urban, data = Carseats, alternative = "two.sided")
print(test2)

# Compute 90th percentile of Advertising
quantile(Carseats$Advertising, probs = c(0.9))

# Compute 25th and 75th percentile of Sales
quantile(Carseats$Sales, probs = c(0.25, 0.75))

# Inflation data set
set.seed(123)
Inflation_rates <- c(2.1, 1.8, 2.3, 1.7, 2.5, 2.8, 3.0, 2.2, 1.9, 2.4)

# Mean inflation rate
mean_inflation <- mean(Inflation_rates)
print(mean_inflation)

# Generate 1000 bootstrap samples, one per column
n <- length(Inflation_rates)
nboots <- 1000
bootstrap_samples <- matrix(sample(Inflation_rates, n * nboots, replace = TRUE),
                            nrow = n,
                            ncol = nboots)

print(bootstrap_samples[1:5, 1:5])

# Compute the mean of each bootstrap sample
bs_means <- colMeans(bootstrap_samples)
print(head(bs_means))

# Calculate the difference (v) between mean_inflation and bs_means
v <- mean_inflation - bs_means
print(head(v))

# Calculate the descriptive statistics for v
# Summary statistics
summary(v)

# Standard deviation
sd(v)

# Mean
mean(v)

# Histogram plot to visualise the distribution of v
hist(v, main = "Distribution of v", xlab = "v", col = "deepskyblue", labels = TRUE)
