# Load necessary librabry 
library(readr)
library(dplyr)
library(ggplot2)

# Assign the name Carseats to csv dataset
Carseats <- read_csv("Carseats_dataset.csv")

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

# Extract only the numeric variable from the Carseats dataset
Carseats_num <- Carseats[sapply(Carseats, is.numeric)]
print(Carseats_num)

# Calculate the correlation matrix from the Carseats_num dataset 
cor_matix <- cor(Carseats_num)
print(cor_matix)

# Create a new column called IncomeCategory and classify income into three 
# groups "Low' (below 40), "Medium" (40-80) and "High" (above 80), 
# also provide the number of entries in each gategory

# Add new column and used the case_when for the category assignment

#Carseats$IncomeCategory <- case_when(
#  Carseats$Income < 40 ~ "Low",
#  Carseats$Income >= 40 & Carseats$Income <= 80 ~ "Medium",
#  Carseats$Income > 80 ~ "High"
#)

Carseats$IncomeCategory <- cut(Carseats$Income, 
                               breaks = c(-Inf, 40, 80, Inf), 
                               labels = c("Low", "Medium", "High"), 
                               include.lowest = TRUE
)

# Number of gategory entries 
table(Carseats$IncomeCategory)

# Bar chart visualising the distribution of IncomeCategory
ggplot(Carseats, aes(x=IncomeCategory)) + 
  geom_bar(fill="coral") + ggtitle("Distribution of IncomeCategory")

# Box plot of Sales using ShelveLoc
ggplot(Carseats, aes(x=ShelveLoc, y=Sales)) + 
  geom_boxplot(fill="cyan") + ggtitle("Sales by ShelveLoc")

# Scatter plot of Sales versus Advertising
ggplot(Carseats, aes(x=Advertising, y=Sales)) + 
  geom_point(colour="green", size=2) + ggtitle("Sales vs Advertising")

# Density plot for Price
ggplot(Carseats, aes(x=Price)) + geom_density(color="purple") + 
  ggtitle("Density Plot of Price") + 
  geom_vline(aes(xintercept=mean(Price)), 
             color="blue", linetype="dashed", size=1)

# Hypothesis test to check the mean Sales is different from 7 using a one-sample t.test
test <- t.test(Carseats$Sales, mu=7, alternative = "two.sided")
print(test)

# Hypothesis test to check the mean Price differ between urban and rural stores using a two-sample t.test
test2 <- t.test(Price ~ Urban, data = Carseats, alternative = "two.sided")
print(test2)

# Compute 90th percentile of Advertising
quantile(Carseats$Advertising, probs = c(0.9))

# Compute 25th and 75th percentile of Sales
quantile(Carseats$Sales, probs = c(0.25, 0.75))

# Data set
set.seed(123)
Inflation_rates <- c(2.1, 1.8, 2.3, 1.7, 2.5, 2.8, 3.0, 2.2, 1.9, 2.4)

# Mean inflation rate
mean_inflation <- mean(Inflation_rates)
print(mean_inflation)

# 1000 generated bootstrap
n <- length(Inflation_rates)
nboots <- 1000
bootstrap_samples <- matrix(sample(Inflation_rates, n * nboots, replace = TRUE),
                            nrow = n,
                            ncol = nboots
)

print(bootstrap_samples[1:5, 1:5])

# Compute mean statistic of bootstrap and asign to bs_mean
bs_means <- colMeans(bootstrap_samples)
print(bs_means)

# Calculate the difference (v) between (mean_inflation) and (bs_means)
v <- mean_inflation - bs_means
print(v)

# Calculate the descriptive statistics for v
# Summary statistics
summary(v)

# Standard deviation
sd(v)

# Mean
mean(v)

# Histogram plot to visualise the distribution of v
hist(v, main = "Distribution of v", xlab = "v", col = "deepskyblue", labels = TRUE)
