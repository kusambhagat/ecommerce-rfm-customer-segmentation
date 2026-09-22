USE EcommerceRFM;

-- total number of rows in the raw dataset (sanity check after import)
SELECT COUNT(*) AS row_count 
FROM raw_data;

-- how many rows have a blank/missing CustomerID?
SELECT COUNT(*) AS blank_cust_id
FROM raw_data
WHERE CustomerID IS NULL;

-- how many rows have a blank/missing InvoiceNo?
SELECT COUNT(*) AS blank_invoice_number
FROM raw_data
WHERE InvoiceNo IS NULL;

-- how many rows have a blank/missing Description?
SELECT COUNT(*) AS Blank_Description
FROM raw_data
WHERE Description IS NULL;

-- how many rows have a blank/missing Quantity?
SELECT COUNT(*) AS Blank_Description
FROM raw_data
WHERE Quantity IS NULL;

-- how many rows have a blank/missing InvoiceDate?
SELECT COUNT(*) AS Blank_InvoiceDate
FROM raw_data
WHERE InvoiceDate IS NULL;

-- how many rows have UnitPrice = 0? (checking if the £0/NULL description issue is widespread)
SELECT COUNT(*) AS zero_price_count
FROM raw_data
WHERE UnitPrice = 0; 

-- how many rows have blank/missing Country?
SELECT COUNT(*) AS Blank_Country
FROM raw_data
WHERE Country IS NULL;

-- how many rows have negative quantity?
SELECT COUNT(*) AS neg_qty_count
FROM raw_data
WHERE Quantity < 0;

-- preview rows with missing CustomerID to look for patterns
SELECT TOP 20 * 
FROM raw_data 
WHERE CustomerID IS NULL;

SELECT TOP 20 InvoiceNo,COUNT(Quantity) AS negative_quantity
FROM raw_data
WHERE Quantity < 0
GROUP BY InvoiceNo
ORDER BY negative_quantity DESC;

-- does every row with negative Quantity have an InvoiceNo starting with "C", or are there exceptions?
SELECT COUNT(*) AS neg_qty_not_C
FROM raw_data
WHERE Quantity < 0 AND InvoiceNo NOT LIKE 'C%';


-- preview the non-"C" negative-quantity rows to look for patterns (description, price)
SELECT TOP 20 InvoiceNo, StockCode, Description, Quantity, UnitPrice
FROM raw_data
WHERE Quantity < 0 AND InvoiceNo NOT LIKE 'C%';


-- confirm these non-"C" negative rows also have no CustomerID (likely internal stock adjustments)
SELECT COUNT(*) AS adjustment_rows_no_customer
FROM raw_data
WHERE Quantity < 0 AND InvoiceNo NOT LIKE 'C%' AND CustomerID IS NULL;

-- check date range (note: InvoiceDate is text, so this may sort alphabetically, not chronologically)
SELECT MIN(InvoiceDate) AS earliest_text, MAX(InvoiceDate) AS latest_text
FROM raw_data;

-- -- count how many rows use slash-format dates (vs dash-format) to check for inconsistent formatting
SELECT COUNT(*) AS slash_format
FROM raw_data
WHERE InvoiceDate LIKE '%/%';


-- check if any dash-format date has a first number > 12 (would prove day-first, not month-first)
SELECT TOP 5 InvoiceDate
FROM raw_data
WHERE InvoiceDate NOT LIKE '%/%'
AND TRY_CAST(LEFT(InvoiceDate, 2) AS INT) > 12;


