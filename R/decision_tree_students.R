# Student Registration Decision Tree
# Computes entropy and information gain by hand to find the best splitting
# feature, then fits a classification tree with rpart.
# Run from the project root (open R_Projects.Rproj in RStudio).

# Load necessary libraries
library(readxl)
library(rpart)
library(rpart.plot)

# Save plots to output/ when run non-interactively (e.g. with Rscript)
if (!interactive()) {
  dir.create("output", showWarnings = FALSE)
  pdf(file.path("output", "decision_tree_students.pdf"))
}

# Import the student registration data
student_R <- read_xlsx(file.path("data", "students_registration.xlsx"))
str(student_R)

# Entropy calculation
calculate_entropy <- function(target) {
  counts <- table(target)
  probs <- prop.table(counts)
  entropy <- -sum(probs * log2(probs), na.rm = TRUE)
  return(entropy)
}

# Information gain: total entropy minus the conditional entropy given a feature
calculate_info_gain <- function(data, feature) {
  total_entropy <- calculate_entropy(data$Registration)
  feature_levels <- unique(data[[feature]])
  weighted_entropy <- 0

  for (level in feature_levels) {
    subset_data <- data[data[[feature]] == level, ]
    subset_entropy <- calculate_entropy(subset_data$Registration)
    subset_probs <- nrow(subset_data) / nrow(data)
    weighted_entropy <- weighted_entropy + subset_probs * subset_entropy
  }

  info_gain <- total_entropy - weighted_entropy
  return(info_gain)
}

entropy <- calculate_entropy(student_R$Registration)
print(entropy)

info_gain_degree <- calculate_info_gain(student_R, "Degree")
print(info_gain_degree)

info_gain_finance <- calculate_info_gain(student_R, "Finance")
print(info_gain_finance)

info_gain_marks <- calculate_info_gain(student_R, "Marks")
print(info_gain_marks)

info_gain <- data.frame(
  Feature = c("Degree", "Finance", "Marks"),
  Information_Gain = c(info_gain_degree, info_gain_finance, info_gain_marks)
)
print(info_gain)

best_feature <- info_gain$Feature[which.max(info_gain$Information_Gain)]
print(best_feature)

# Fit a classification tree using information gain as the split criterion
student_R$Registration <- factor(student_R$Registration)

decision_tree <- rpart(Registration ~ Finance + Marks + Degree, data = student_R,
                       method = "class",
                       parms = list(split = "information"),
                       control = rpart.control(minsplit = 20))

rpart.plot(decision_tree)
