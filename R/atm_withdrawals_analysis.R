# ATM Withdrawals Analysis
# Regression, residual diagnostics and CART on ATM withdrawal data, followed by
# a hand-computed entropy / information gain example on economic data.
# Run from the project root (open R_Projects.Rproj in RStudio).

# Load necessary libraries
library(readr)
library(ggplot2)
library(rpart)
library(rpart.plot)

# Save plots to output/ when run non-interactively (e.g. with Rscript)
if (!interactive()) {
  dir.create("output", showWarnings = FALSE)
  pdf(file.path("output", "atm_withdrawals_analysis.pdf"))
}

# Import ATM data into withdrawals
withdrawals <- read_csv(file.path("data", "ATM_Withdrawals.csv"), show_col_types = FALSE)

# Create a scatter plot using withdrawal amount and next withdrawal
ggplot(withdrawals, aes(x = Withdrawal_Amount_ZAR, y = Time_Until_Next_Withdrawal_Hours)) +
  geom_point(color = "chocolate1") +
  labs(title = "Withdrawal Amount against Next Withdrawal",
       x = "Withdrawal Amount (ZAR)",
       y = "Time Until Next Withdrawal (Hours)")

# Calculate the mean and standard deviation of withdrawal amount
# Mean
mean_withdrawal <- mean(withdrawals$Withdrawal_Amount_ZAR)
print(mean_withdrawal)

# Standard deviation
sd_withdrawal <- sd(withdrawals$Withdrawal_Amount_ZAR)
print(sd_withdrawal)

# Use lm() function to fit a regression line on y and x
withdrawal_lm_fit <- lm(Time_Until_Next_Withdrawal_Hours ~ Withdrawal_Amount_ZAR, data = withdrawals)
print(withdrawal_lm_fit)

# Use summary function to provide a summary of the withdrawal regression
summary(withdrawal_lm_fit)

# What is the R-squared value of withdrawal regression
r_squared <- summary(withdrawal_lm_fit)$r.squared
print(r_squared)

# Hypothesis test for the slope β1 on withdrawal regression
summary(withdrawal_lm_fit)$coefficients

# Predict how long it will take to visit the ATM again after a 10,000 ZAR withdrawal
next_atm_visit <- predict(withdrawal_lm_fit, data.frame(Withdrawal_Amount_ZAR = 10000))
print(next_atm_visit)

# Create a residual plot with a zero reference line
plot(withdrawal_lm_fit$fitted.values, withdrawal_lm_fit$residuals,
     xlab = "Fitted Values", ylab = "Residuals", col = "darkred",
     main = "Residual Plot")
abline(h = 0, col = "red", lwd = 2)

# Fit a CART regression tree
cart_model <- rpart(Time_Until_Next_Withdrawal_Hours ~ Withdrawal_Amount_ZAR, data = withdrawals)
# Plot the CART regression tree
rpart.plot(cart_model)

# Economic data set
economic_data <- data.frame(
  Interest_Rate = c(0, 0, 1, 1, 1),
  Unemployment_Rate = c(0, 1, 0, 1, 1),
  Economic_Growth = c(0, 0, 0, 0, 1),
  Recession = c(0, 1, 1, 0, 0)
)

# Entropy calculation
calculate_entropy <- function(target) {
  counts <- table(target)
  probabilities <- prop.table(counts)
  entropy <- -sum(probabilities * log2(probabilities), na.rm = TRUE)
  return(entropy)
}

S_Y <- calculate_entropy(economic_data$Recession)
print(S_Y)

# Information gain: total entropy minus the conditional entropy given a feature
calculate_info_gain <- function(data, feature) {
  total_entropy <- calculate_entropy(data$Recession)
  feature_levels <- unique(data[[feature]])
  weighted_entropy <- 0

  for (level in feature_levels) {
    subset_data <- data[data[[feature]] == level, ]
    subset_entropy <- calculate_entropy(subset_data$Recession)
    subset_prob <- nrow(subset_data) / nrow(data)
    weighted_entropy <- weighted_entropy + subset_prob * subset_entropy
  }
  info_gain <- total_entropy - weighted_entropy
  return(info_gain)
}

S_Y_V <- calculate_info_gain(economic_data, "Interest_Rate")
print(S_Y_V)

S_Y_W <- calculate_info_gain(economic_data, "Unemployment_Rate")
print(S_Y_W)

S_Y_X <- calculate_info_gain(economic_data, "Economic_Growth")
print(S_Y_X)

# Convert the 0/1 codes to labelled factors for the classification tree
df <- within(economic_data, {
  Recession <- factor(Recession, levels = c(0, 1), labels = c("No recession", "Recession"))
  Interest_Rate <- factor(Interest_Rate, levels = c(0, 1), labels = c("Low interest", "High interest"))
  Unemployment_Rate <- factor(Unemployment_Rate, levels = c(0, 1), labels = c("Low unemployment", "High unemployment"))
  Economic_Growth <- factor(Economic_Growth, levels = c(0, 1), labels = c("No growth", "Positive growth"))
})

economic_tree <- rpart(Recession ~ Interest_Rate + Unemployment_Rate + Economic_Growth,
                       data = df, method = "class",
                       parms = list(split = "information"),
                       control = rpart.control(cp = 0.0, minsplit = 1, minbucket = 1, maxdepth = 5))

rpart.plot(economic_tree, type = 3, extra = 104, under = TRUE, fallen.leaves = TRUE,
           main = "Decision Tree Using Information Gain (Entropy)")
