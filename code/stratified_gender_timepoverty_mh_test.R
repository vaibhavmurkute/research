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

# Calculate Odds of Time Poverty by Year
time_poverty_odds <- atus_data %>%
  group_by(YEAR) %>%
  summarise(
    Time_Poor_Count = sum(Time_Poor == 1),
    Not_Time_Poor_Count = sum(Time_Poor == 0),
    Odds = Time_Poor_Count / Not_Time_Poor_Count
  ) %>%
  ungroup()

print("Odds of Time Poverty by Year:")
print(time_poverty_odds)


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


# Create Contingency Table with dimension (2, 2, 5) 
# for Time_Poverty_Status (Rows), Males (Column 1), Females (Column 2), stratified by Year
contingency_array <- xtabs(~ Time_Poverty_Status + Gender + YEAR, data = atus_data)

print(dim(contingency_array))
print("Contingency Array (Counts by Year):")
print(contingency_array)

# MH test to check the association between Time Poverty and Gender, controlling for YEAR
mh_result <- mantelhaen.test(contingency_array)

print("\n--- Mantel-Haenszel Test Results (Controlling for Year) ---")
print(mh_result)

cat("\nMantel-Haenszel Pooled Odds Ratio (Gender and Time Poverty):\n")
cat(paste("Odds Ratio Estimate:", round(mh_result$estimate, 4), "\n"))


