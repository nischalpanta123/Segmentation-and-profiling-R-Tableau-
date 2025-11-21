library(dplyr)
library(readr)

INPUT <- "data/customer.csv"
customer <- read_csv(INPUT, show_col_types = FALSE)

customer <- customer %>%
  mutate(
    Multiline = as.factor(Multiline),
    EquipmentRental = as.factor(EquipmentRental),
    Gender = as.factor(Gender),
    DebtToIncomeRatio = as.numeric(DebtToIncomeRatio),
    DataOverTenure = as.numeric(DataOverTenure),
    DataOverTenureCategory = ifelse(DataOverTenure >= median(DataOverTenure, na.rm=TRUE), "High","Low"),
    DebtToIncomeCategory = case_when(
      DebtToIncomeRatio < 4 ~ "Low",
      DebtToIncomeRatio < 6 ~ "Medium",
      TRUE ~ "High"
    ),
    ValueScore = as.numeric(VoiceLastMonth) + as.numeric(EquipmentLastMonth) + as.numeric(DataLastMonth),
    CustomerValueCategory = factor(ifelse(ValueScore >= 100, "High","Low"))
  )

formula <- CustomerValueCategory ~ DebtToIncomeCategory + DataOverTenureCategory +
  Multiline + EquipmentRental + Gender

logit_fit <- glm(formula = formula, family = binomial, data = customer)
print(summary(logit_fit))
