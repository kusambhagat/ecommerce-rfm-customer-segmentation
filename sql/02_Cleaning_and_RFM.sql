USE EcommerceRFM;

SELECT COUNT(*) 
FROM raw_data
WHERE CustomerID IS NOT NULL;

SELECT COUNT(*) 
FROM raw_data
WHERE CustomerID IS NOT NULL AND InvoiceNo NOT LIKE 'C%' AND Description IS NULL AND UnitPrice = 0;

SELECT TRY_CAST('12-25-2010' AS DATE) AS test_date;
SELECT TRY_CAST('12/25/2011' AS DATE) AS test_slash_date;

SELECT 
	InvoiceNo AS InvoiceNo, 
	StockCode AS StockCode, 
	Description AS Description, 
	TRY_CAST(Quantity AS INT) AS Quantity, 
	CASE WHEN InvoiceDate LIKE '%/%' OR InvoiceDate LIKE '%-%' THEN TRY_CAST(InvoiceDate AS DATE) END AS InvoiceDate,
	UnitPrice AS UnitPrice, 
	CustomerID AS CustomerID, 
	Country AS Country, 
    (CASE WHEN InvoiceNo LIKE 'C%' THEN 1 ELSE 0 END) AS IsCancellation
INTO cleaned_data
FROM raw_data
WHERE CustomerID IS NOT NULL;

SELECT TOP 20 * FROM cleaned_data;

SELECT TOP 5 * FROM cleaned_data WHERE IsCancellation = 1;

-- Find Recency (Recent perchase)

WITH overall_recent_date AS (
	SELECT MAX(InvoiceDate) AS recent_date
	FROM cleaned_data
), 
last_purchase_by_cust AS (
		SELECT CustomerID, MAX(InvoiceDate) AS cust_recent_purchase_date 
		FROM cleaned_data 
		GROUP BY CustomerID
		)
SELECT l.CustomerID, DATEDIFF(DAY, l.cust_recent_purchase_date, o.recent_date) AS recent_purchase
FROM last_purchase_by_cust l
CROSS JOIN overall_recent_date o

-- Frequency — count of distinct invoices per customer
SELECT CustomerID, COUNT(DISTINCT InvoiceNo) AS Order_Count
FROM cleaned_data
GROUP BY CustomerID
ORDER BY Order_Count DESC;

-- Monetary — count of distinct invoices per customer
SELECT CustomerID, SUM(Quantity * UnitPrice) AS Total_Spend
FROM cleaned_data
GROUP BY CustomerID
ORDER BY Total_Spend DESC;

-- R/F/M

-- Turn your Recency query into a CTE (e.g. recency_cte), 
-- keeping its own overall_recent_date and last_purchase_by_cust CTEs inside it, 
-- ending with CustomerID, recent_purchase as its output.

WITH overall_recent_date AS (
	SELECT MAX(InvoiceDate) AS recent_date
	FROM cleaned_data
), 
last_purchase_by_cust AS (
		SELECT CustomerID, MAX(InvoiceDate) AS cust_recent_purchase_date 
		FROM cleaned_data 
		GROUP BY CustomerID
		),
recency_cte AS (
	SELECT l.CustomerID, DATEDIFF(DAY, l.cust_recent_purchase_date, o.recent_date) AS recency
	FROM last_purchase_by_cust l
	CROSS JOIN overall_recent_date o
),
frequency_cte AS (
	SELECT CustomerID, COUNT(DISTINCT InvoiceNo) AS frequency
	FROM cleaned_data
	GROUP BY CustomerID
),
monetory_cte AS (
	SELECT CustomerID, SUM(Quantity * UnitPrice) AS monetory
	FROM cleaned_data
	GROUP BY CustomerID
),
rfm_raw AS (
	SELECT r.CustomerID, r.recency, f.frequency, m.monetory
	FROM recency_cte r
	JOIN frequency_cte f
	ON r.CustomerID = f.CustomerID
	JOIN monetory_cte m
	ON f.CustomerID = m.CustomerID
),
rfm_score AS (
	SELECT CustomerID, recency, frequency, monetory,
	NTILE(5) OVER(ORDER BY recency DESC, CustomerID) AS R_Score,
	NTILE(5) OVER(ORDER BY frequency ASC, CustomerID) AS F_Score,
	NTILE(5) OVER(ORDER BY monetory ASC, CustomerID) AS M_Score
	FROM rfm_raw
),
customer_rfm_status AS(
	SELECT r.*, CONCAT(R_Score, F_Score, M_Score) AS RFM_Code,
	CASE 
		WHEN R_Score>=4  AND F_Score>=4 AND M_Score>=4 THEN 'Loyal'
		WHEN R_Score=5 AND F_Score=1 AND M_Score=5 THEN 'Big Spender'
		WHEN R_Score=5 AND F_Score=1 THEN 'New Customer'
		WHEN R_Score<=2 AND F_Score<=2 AND M_Score<=2 THEN 'Dormant'
	ELSE 'At_Risk' 
	END AS Cust_Status
	FROM rfm_score r

)
SELECT * 
INTO rfm_final
FROM customer_rfm_status;

SELECT * FROM rfm_final;


SELECT TOP 5 * FROM rfm_final;


SELECT 
	TOP 20 CustomerID, monetory,
    NTILE(10) OVER (ORDER BY monetory DESC , CustomerID) AS Decile
FROM rfm_final
ORDER BY monetory DESC;

ALTER TABLE rfm_final
ADD Decile INT;

ALTER TABLE rfm_final
DROP COLUMN Decile;

SELECT *, NTILE(10) OVER (ORDER BY monetory DESC , CustomerID) AS Decile
INTO rfm_final_v2
FROM rfm_final;

SELECT TOP 10 * 
FROM rfm_final_v2
ORDER BY monetory DESC;







