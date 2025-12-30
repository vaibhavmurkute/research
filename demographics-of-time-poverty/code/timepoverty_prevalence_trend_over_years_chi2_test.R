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

# Convert Time_Poor to a descriptive factor for the table
atus_data <- atus_data %>%
  mutate(
    Time_Poverty_Status = factor(Time_Poor,
                                 levels = c(0, 1),
                                 labels = c("Not Time Poor", "Time Poor"))
  )

time_trend_table <- xtabs(~ Time_Poverty_Status + YEAR, data = atus_data)

print("2x5 Contingency Table (Counts by Year):")
print(time_trend_table)

# Chi-Squared Test to test the independence of time poverty status and year
chi_sq_trend_result <- chisq.test(time_trend_table)

cat("\n--- Chi-Squared Test of Independence (Time Poverty vs. Year) ---\n")
print(chi_sq_trend_result)
