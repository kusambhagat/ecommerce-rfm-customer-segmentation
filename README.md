# E-Commerce Customer Segmentation (RFM Analysis)

Segmenting customers of a UK online retailer using RFM (Recency, Frequency, Monetary) analysis to support targeted marketing and budget allocation.
- Raw data: `data/data.zip` (unzip to get the CSV used in the SQL scripts)

![Dashboard](images/E_Com_Dashboard.jpg)

## Business Problem
Retail businesses generate a lot of customer transaction data, but most don't use it to actually understand their customers — who's valuable, who's slipping away. So I segmented customers using RFM analysis — Recency, Frequency, Monetary value — to identify these groups and turn that into marketing recommendations."

## Dataset
- UK Online Retail transactional dataset (~542,000 rows)
- Source: [add link]

## Tools
SQL Server (T-SQL) · Power BI (DAX) · Python (pandas, Jupyter) · PowerPoint

## Approach
1. **Data exploration** – `sql/01_Exploring_Data.sql`
2. **Cleaning and RFM scoring** – `sql/02_Cleaning_and_RFM.sql`
   - Removed rows with missing CustomerID and invalid negative quantities
   - Kept cancellations with an IsCancellation flag (406,829 clean rows)
   - Calculated R, F and M per customer and scored 1–5 using NTILE(5)
3. **EDA** – `sql/03_EDA_Analysis.sql`
4. **Dashboard** – `powerbi/E_Com_Dashboard.pbix`
5. **Validation** – `python/RFM_Validation.ipynb` rebuilds the RFM logic in pandas and confirms the segment counts match SQL and Power BI

## Customer Segments and Budget Allocation
| Segment | Budget share |
|---|---|
| Loyal | 40% |
| At-Risk | 30% |
| Dormant | 15% |
| New Customer | 10% |
| Big Spender | 5% |

## Key Insights
- [Insight 1]
- [Insight 2]
- [Insight 3]

## Recommendations
[One line per segment: what action to take]

## Files
- `docs/` – presentation (PPTX)
- `images/` – dashboard screenshot

## Author
Kusam Bhagat · [LinkedIn](https://linkedin.com/in/kusam-bhagat)
