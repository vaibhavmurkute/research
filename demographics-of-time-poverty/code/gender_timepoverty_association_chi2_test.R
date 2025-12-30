library(ipumsr)
library(dplyr)
library(janitor)

ddi <- read_ipums_ddi("atus_00001.xml") 
atus_data <- read_ipums_micro(ddi)

head(atus_data)

# Calculate the Leisure Time Threshold (T_Leisure)
T_Leisure <- atus_data %>%
  filter(!is.na(Leisure)) %>%
  pull(Leisure) %>%
  # Calculate the 25th percentile
  quantile(probs = 0.25, na.rm = TRUE)

# Calculate the Personal Care Threshold (T_Personal Care)
T_PersonalCare <- atus_data %>%
  filter(!is.na(Personal_Care_Comp)) %>%
  pull(Personal_Care_Comp) %>%
  quantile(probs = 0.25, na.rm = TRUE)

cat("Time Poverty Thresholds (25th Percentile):\n")
cat(paste("T_Leisure (Daily Minutes):", round(T_Leisure, 2), "\n"))
cat(paste("T_Personal Care (Daily Minutes):", round(T_PersonalCare, 2), "\n"))

# Store the calculated thresholds as single numeric values
# (The quantile function returns a named vector, so need to extract the value)
T_L <- as.numeric(T_Leisure)
T_P <- as.numeric(T_PersonalCare)

# We are considering Year 2024 for this initial analysis
atus_data <- atus_data %>%
  filter(YEAR == 2024)

atus_data <- atus_data %>%
  mutate(
    # Create the binary variable (0 or 1)
    # Time Poor = (L <= T_Leisure) AND (P <= T_Personal Care)
    Time_Poor = if_else(
      (Leisure <= T_L) & (Personal_Care_Comp <= T_P),
      1,    # Time Poor
      0     # Not Time Poor
    )
  )

# The Distribution of the New Variable: Time_Poor
table(atus_data$Time_Poor)
prop.table(table(atus_data$Time_Poor)) * 100


# Clean and factor the Gender variable and
# Convert Time_Poor to a descriptive factor for the table
atus_data <- atus_data %>%
  mutate(
    Gender = factor(SEX,
                    levels = c(1, 2),
                    labels = c("Male", "Female")),
    
    Time_Poverty_Status = factor(Time_Poor,
                                 levels = c(0, 1),
                                 labels = c("Not Time Poor", "Time Poor"))
  )

# Create the Contingency Table (Time_Poverty_Status by Gender)
contingency_table <- atus_data %>%
  tabyl(Time_Poverty_Status, Gender) %>%
  select(Male, Female) %>% # Explicitly KEEP only the count columns
  as.matrix()

colnames(contingency_table) <- c("Male", "Female")
rownames(contingency_table) <- c("Not Time Poor", "Time Poor")

print("Contingency Table (Counts):")
print(contingency_table)

# Perform the Chi-Squared Test of Independence
chi_sq_result <- chisq.test(contingency_table)

print(chi_sq_result)

cat("\n--- Chi-Squared Test Results ---\n")
cat(paste("X-squared Statistic:", round(chi_sq_result$statistic, 4), "\n"))
cat(paste("Degrees of Freedom:", chi_sq_result$parameter, "\n"))
cat(paste("P-value:", format.pval(chi_sq_result$p.value, digits = 4), "\n"))



