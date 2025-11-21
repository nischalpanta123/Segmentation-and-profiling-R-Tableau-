library(dplyr)
library(readr)

INPUT <- "data/customer.csv"
customer <- read_csv(INPUT, show_col_types = FALSE)

# Derived categories (example thresholds)
customer <- customer %>%
  mutate(
    HHIncome = as.numeric(gsub("[\\$,()\\-]", "", HHIncome)),
    DebtToIncomeRatio = as.numeric(DebtToIncomeRatio),
    DataOverTenure = as.numeric(DataOverTenure),
    EquipmentRental = as.factor(EquipmentRental),
    Multiline = as.factor(Multiline),
    Gender = as.factor(Gender),
    DebtToIncomeCategory = case_when(
      DebtToIncomeRatio < 4 ~ "Low",
      DebtToIncomeRatio < 6 ~ "Medium",
      TRUE ~ "High"
    ),
    CustomerValueCategory = case_when(
      (as.numeric(VoiceLastMonth) + as.numeric(EquipmentLastMonth) + as.numeric(DataLastMonth)) >= 100 ~ "High",
      TRUE ~ "Low"
    ),
    DataOverTenureCategory = ifelse(DataOverTenure >= median(DataOverTenure, na.rm=TRUE), "High", "Low")
  )

# Segments
seg1 <- customer %>% filter(Gender == "Female",
                            DebtToIncomeCategory == "Low",
                            Multiline == "Yes",
                            EquipmentRental == "Yes")
seg2 <- seg1 %>% filter(DataOverTenureCategory == "High")
seg3 <- customer %>% filter(Gender == "Female",
                            DebtToIncomeCategory == "High",
                            Multiline == "Yes",
                            EquipmentRental == "Yes",
                            CustomerValueCategory == "High")
seg0 <- customer %>% filter(Gender == "Male")

cat("n(seg0 Men):", nrow(seg0), "\n")
cat("n(seg1 Women-LowDTI-Multiline-EquipRental):", nrow(seg1), "\n")
cat("n(seg2 + High DataOverTenure):", nrow(seg2), "\n")
cat("n(seg3 High DTI & High Value):", nrow(seg3), "\n")

write.csv(seg1, "outputs/segment1.csv", row.names = FALSE)
write.csv(seg2, "outputs/segment2.csv", row.names = FALSE)
write.csv(seg3, "outputs/segment3.csv", row.names = FALSE)
write.csv(seg0, "outputs/segment0.csv", row.names = FALSE)
