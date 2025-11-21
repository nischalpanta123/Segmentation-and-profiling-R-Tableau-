# Tableau workbook notes

- Visualize DataOverTenure vs Multiline by Gender:
  - Rows: Gender
  - Columns: Multiline
  - Measure: SUM(DataOverTenure)

- Debt-to-Income vs Income Class by Gender:
  - Rows: HHIncome class (derived bins)
  - Measure: SUM(DebtToIncomeRatio)
  - Color: Gender

- Segments vs DebtToIncomeRatio vs IncomeClass:
  - Use segment IDs from CSVs
  - Plot distributions per income class
