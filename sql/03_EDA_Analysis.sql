USE EcommerceRFM;

SELECT * FROM cleaned_data;
SELECT * FROM rfm_final_v2;

-- 1. What's the total revenue, and how does it trend by month?(growth, decline, seasonality)

SELECT FORMAT(InvoiceDate, 'yyyy-MM') AS Month, ROUND(SUM(Quantity * UnitPrice),0) AS Revenue
FROM cleaned_data
GROUP BY FORMAT(InvoiceDate, 'yyyy-MM')
ORDER BY Month;

--How many unique customers are active in the dataset?
SELECT COUNT(DISTINCT CustomerID) AS active_customers
FROM rfm_final_v2
WHERE Recency <= 90;

--What's the average purchase size (per transaction/invoice)?
WITH purchase_per_invoice AS (
	SELECT InvoiceNo, ROUND(SUM(Quantity * UnitPrice), 2) AS Purchase_Amount
	FROM cleaned_data
	GROUP BY InvoiceNo
	)
SELECT ROUND(AVG(Purchase_Amount),2) AS Average_Purchase_Size
FROM purchase_per_invoice;


--How many total transactions (distinct invoices) were placed overall?

SELECT COUNT(DISTINCT InvoiceNo) AS total_transactions
FROM cleaned_data;


--Which country contributes the most revenue? (useful context, not explicitly required but adds insight)
SELECT TOP 5 Country, ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue
FROM cleaned_data
GROUP BY Country
ORDER BY total_revenue DESC;

SELECT COUNT(*) FROM cleaned_data WHERE IsCancellation = 1;

