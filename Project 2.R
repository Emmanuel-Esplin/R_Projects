# Load neccessary libraries
library(readr)
library(ggplot2)
library(rpart)
library(rpart.plot)

# Import ATM data into withdrawals
withdrawals <- read_csv("ATM_Withdrawals.csv")

# Create a Scatter plot using withdrawal amount and next withdrawal
ggplot(withdrawals, aes(x = Withdrawal_Amount_ZAR, y = Time_Until_Next_Withdrawal_Hours)) +
  geom_point(color="chocolate1") +
  labs(title = "Withdrawal Amount against next Withdrawal", 
       x = "Withdrawal Amount (ZAR)",
       y = "Time Until next Withdrawal (Hours)")

# Calculate the mean and standard deviation of Withdrawal amount
# Mean
mean_withdrawal <- mean(withdrawals$Withdrawal_Amount_ZAR)
print(mean_withdrawal)

# Standard Deviation
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

# Hypothesis test for the slop β1 on withdrawal regression
summary(withdrawal_lm_fit)$coefficients

# Predict how long it will take to vist atm again for a withdrawal
next_atm_visit <- predict(withdrawal_lm_fit, data.frame(Withdrawal_Amount_ZAR = 10000))
print(next_atm_visit)

# Create a residual plot 
plot(withdrawal_lm_fit$fitted.values, withdrawal_lm_fit$residuals, 
     xlab = "Fitted Values", ylab = "Residuals", col = "darkred",
     main = "Residual Plot")
abline(withdrawal_lm_fit, col = "red", lwd = 2)

# Fit a CART regression tree
cart_model <- rpart(Time_Until_Next_Withdrawal_Hours ~ Withdrawal_Amount_ZAR, data = withdrawals)
# Plot the cart regression tree
rpart.plot(cart_model)

# Economic data set
economic_data <- data.frame(
  Interest_Rate = c(0, 0, 1, 1, 1),
  Unemployment_Rate = c(0, 1, 0, 1, 1),
  Economic_Growth = c(0, 0, 0, 0, 1),
  Recession = c(0, 1, 1, 0, 0)
)

# Entropy calculation
calculate_entropy <- function(economic_data) {
  counts <- table(economic_data)
  probabilities <- prop.table(counts)
  entropy <- -sum(probabilities * log2(probabilities), na.rm = TRUE)
  return(entropy)
}

S_Y <- calculate_entropy(economic_data$Recession)
print(S_Y)

# Conditonal entropy calculation
calc_conditionl_entropy <- function(economic_data, feature) {
  total_entropy <- calculate_entropy(economic_data$Recession)
  feature_level <- unique(economic_data[[feature]])
  weighted_entrop <- 0
  
  for (level in feature_level) {
    subset_data <- subset(economic_data, economic_data[[feature]] == level)
    subset_entropy <- calculate_entropy(subset_data$Recession)
    subset_prob <- nrow(subset_data) / nrow(economic_data)
    weighted_entrop <- weighted_entrop + subset_prob * subset_entropy
  }
  infor_gain <- total_entropy - weighted_entrop
  return(infor_gain)
}

S_Y_V <- calc_conditionl_entropy(economic_data, "Interest_Rate")
S_Y_V

S_Y_W <- calc_conditionl_entropy(economic_data, "Unemployment_Rate")
S_Y_W

S_Y_X <- calc_conditionl_entropy(economic_data, "Economic_Growth")
S_Y_X


df <- within(economic_data, {
  Recession <- factor(Recession, levels = c(0,1), labels = c("No recession","Recession"))
  Interest_Rate <- factor(Interest_Rate, levels = c(0,1), labels = c("Low interest","High interest"))
  Unemployment_Rate <- factor(Unemployment_Rate, levels = c(0,1), labels = c("Low unemployment", "High unemployment"))
  Economic_Growth <- factor(Economic_Growth, levels = c(0,1), labels = c("No growth", "Positive growth"))
})


economic_tree <- rpart(Recession ~ Interest_Rate + Unemployment_Rate + Economic_Growth, 
                       data = df, method = "class",
                       control = rpart.control(cp = 0.0, minsplit = 1, minbucket =  1, maxdepth = 5))

rpart.plot(economic_tree, type = 3, extra = 104, under = TRUE, fallen.leaves = TRUE, 
           main = "Decision Tree Using Information Gain (Entropy)")
