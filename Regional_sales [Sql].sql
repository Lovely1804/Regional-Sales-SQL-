/* -------------------------------------------------------
    1. View All Records from Tables
-------------------------------------------------------- */
SELECT * FROM [Regional_Sales].dbo.[Regional Sales Dataset];
SELECT * FROM [Regional_Sales].dbo.[Product];
SELECT * FROM [Regional_Sales].dbo.[Regions];
SELECT * FROM [Regional_Sales].dbo.[Customer];
SELECT * FROM [Regional_Sales].dbo.[2017_Budget];
SELECT * FROM [Regional_Sales].dbo.[State_Regions];


/* -------------------------------------------------------
    2. Preview Only Column Names (No Rows)
-------------------------------------------------------- */
SELECT TOP 0 * FROM [Regional_Sales].dbo.[Regional Sales Dataset];
SELECT TOP 0 * FROM [Regional_Sales].dbo.[Regions];
SELECT TOP 0 * FROM [Regional_Sales].dbo.[State_Regions];
SELECT TOP 0 * FROM [Regional_Sales].dbo.[Product];
SELECT TOP 0 * FROM [Regional_Sales].dbo.[Customer];
SELECT TOP 0 * FROM [Regional_Sales].dbo.[2017_Budget];


/* -------------------------------------------------------
    3. List Imported Table Names (From Excel Sheet)
-------------------------------------------------------- */
SELECT Table_Name
FROM [Regional_Sales].INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'Base Table';


/* -------------------------------------------------------
    4. Clean Up Extra Header Row from Excel Import
-------------------------------------------------------- */
DELETE FROM [Regional_Sales].dbo.[State_Regions]
WHERE Column1 = 'State Code';


/* -------------------------------------------------------
    5. View Column Names of State_Regions Table
-------------------------------------------------------- */

SELECT COLUMN_NAME
FROM [Regional_Sales].INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'State_Regions';


/* -------------------------------------------------------
    6. Rename Columns in State_Regions Table
-------------------------------------------------------- */
USE Regional_Sales;
EXEC sp_rename 'dbo.State_Regions.Column1', 'State code', 'COLUMN';
EXEC sp_rename 'dbo.State_Regions.Column2', 'State', 'COLUMN';
EXEC sp_rename 'dbo.State_Regions.Column3', 'Region', 'COLUMN';


/* -------------------------------------------------------
    7. Get Column Names from Other Tables
-------------------------------------------------------- */
SELECT COLUMN_NAME
FROM [Regional_Sales].INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Regional Sales Dataset';

SELECT COLUMN_NAME
FROM [Regional_Sales].INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Regions';

SELECT COLUMN_NAME
FROM [Regional_Sales].INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Product';

SELECT COLUMN_NAME
FROM [Regional_Sales].INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Customer';

SELECT COLUMN_NAME
FROM [Regional_Sales].INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = '2017_Budget';


/* -------------------------------------------------------
    8. Joins: Customer Orders Count
-------------------------------------------------------- */
SELECT 
    Rs.Customer_Name_index,
    C.Customer_Names,
    COUNT(*) AS Total_Orders
FROM [Regional_Sales].dbo.[Regional Sales Dataset] AS RS
INNER JOIN [Regional_Sales].dbo.[Customer] AS C
    ON Rs.Customer_Name_Index = C.Customer_Index
GROUP BY Rs.Customer_Name_index, C.Customer_Names
ORDER BY Total_Orders DESC;


/* -------------------------------------------------------
    9. Find 3rd Highest Total Orders
-------------------------------------------------------- */
WITH Customer_Total_order AS (
    SELECT 
        Rs.Customer_Name_index,
        C.Customer_Names,
        COUNT(*) AS Total_Orders
    FROM [Regional_Sales].dbo.[Regional Sales Dataset] AS RS
    INNER JOIN [Regional_Sales].dbo.[Customer] AS C
        ON Rs.Customer_Name_Index = C.Customer_Index
    GROUP BY Rs.Customer_Name_index, C.Customer_Names
)

SELECT 
    Customer_Names,
    Total_Orders
FROM Customer_Total_order
WHERE Total_Orders = (
    SELECT MAX(Total_Orders)
    FROM Customer_Total_order
    WHERE Total_Orders < (
        SELECT MAX(Total_Orders)
        FROM Customer_Total_order
        WHERE Total_Orders < (
            SELECT MAX(Total_Orders)
            FROM Customer_Total_order
        )
    )
);


/* -------------------------------------------------------
    10. Join: Combine Customer, Region, Product Info
-------------------------------------------------------- */
SELECT
    c.Customer_Names,
    rsd.Customer_Name_Index,
    r.county,
    r.state,
    r.name,
    r.population,
    p.Product_Name,
    rsd.Product_Description_Index,
    rsd.Delivery_Region_Index
FROM [Regional Sales Dataset] rsd
INNER JOIN [Regions] r ON rsd.Delivery_Region_Index = r.id 
INNER JOIN [Customer] c ON rsd.Customer_Name_Index = c.Customer_Index 
INNER JOIN [Product] p ON rsd.Product_Description_Index = p.[Index];


/* -------------------------------------------------------
    11. Total Quantity Sold per Product
-------------------------------------------------------- */
SELECT 
    P.Product_Name,
    SUM(rsd.Order_Quantity) AS Total_QTY
FROM [Regional Sales Dataset] rsd
INNER JOIN [Product] P ON rsd.Product_Description_Index = P.[Index]
GROUP BY P.Product_Name
ORDER BY Total_QTY DESC;


/* -------------------------------------------------------
    12. Average Quantity Sold per Product
-------------------------------------------------------- */
SELECT 
    P.Product_Name,
    AVG(rsd.Order_Quantity) AS Total_Avg
FROM [Regional Sales Dataset] rsd
INNER JOIN [Product] P ON rsd.Product_Description_Index = P.[Index]
GROUP BY P.Product_Name
ORDER BY Total_Avg;


/* -------------------------------------------------------
    13. Window Function: Min Quantity by Customer
-------------------------------------------------------- */
SELECT 
    Order_Quantity,
    MIN(Order_Quantity) OVER (PARTITION BY Customer_Name_Index) AS Min_Qty
FROM [Regional_Sales].dbo.[Regional Sales Dataset];


/* -------------------------------------------------------
   14. Window Function: Max Quantity by Customer
-------------------------------------------------------- */
SELECT 
    Order_Quantity,
    MAX(Order_Quantity) OVER (PARTITION BY Customer_Name_Index) AS Min_Qty
FROM [Regional_Sales].dbo.[Regional Sales Dataset];


/* -------------------------------------------------------
   15. Window Function: Using Joins
-------------------------------------------------------- */
SELECT
    Rsd.Order_Quantity,
    P.Product_Name,
    C.Customer_Names
FROM [Regional_Sales].dbo.[Regional Sales Dataset] Rsd
INNER JOIN [Product] P ON Rsd.Product_Description_index = P.[Index]
INNER JOIN [Customer] C ON Rsd.Customer_Name_index = C.Customer_Index
ORDER BY Customer_Names;


/* -------------------------------------------------------
   16. Count of Customers
-------------------------------------------------------- */
SELECT COUNT(Customer_Names) AS Total_Customer
FROM [Customer] C;


/* -------------------------------------------------------
   17. Distinct Count: Product & Customer
-------------------------------------------------------- */
SELECT COUNT(DISTINCT Customer_Name_Index) AS Total_Count
FROM [Regional_Sales].dbo.[Regional Sales Dataset] Rsd
INNER JOIN [Product] P ON Rsd.Product_Description_Index = P.[Index]
INNER JOIN [Customer] C ON Rsd.Customer_Name_Index = Customer_Index;


/* -------------------------------------------------------
   18. Rank Customers by Total Order Quantity
-------------------------------------------------------- */
SELECT 
    C.Customer_Names,
    SUM(Rsd.Order_Quantity) AS Total_Order,
    RANK() OVER (ORDER BY SUM(Rsd.Order_Quantity) DESC) AS Total_Rank
FROM [Customer] C
INNER JOIN [Regional_Sales].dbo.[Regional Sales Dataset] Rsd
    ON Rsd.Customer_Name_Index = C.Customer_Index
GROUP BY C.Customer_Names;


/* -------------------------------------------------------
   19. Dense Rank Customers by Total Order Quantity
-------------------------------------------------------- */
SELECT 
    C.Customer_Names,
    SUM(Rsd.Order_Quantity) AS Total_Order,
    DENSE_RANK() OVER (ORDER BY SUM(Rsd.Order_Quantity) DESC) AS Total_Rank
FROM [Customer] C
INNER JOIN [Regional_Sales].dbo.[Regional Sales Dataset] Rsd
    ON Rsd.Customer_Name_Index = C.Customer_Index
GROUP BY C.Customer_Names;

/*-----------------------------------------------------------------------
   20.Sales Data Segmentation: Customer-Wise Order Percentage and Rank
------------------------------------------------------------------------ */

WITH Customer_Order_Total AS (
    SELECT 
        C.First_Name + ' ' + C.Last_Name AS Customer_Name,
        SUM(Rsd.Order_Quantity) AS Total_Quantity
    FROM [Regional_Sales].dbo.[Regional Sales Dataset] Rsd
    INNER JOIN [Customer] C
        ON Rsd.Customer_Name_Index = C.CustomerID
    GROUP BY C.First_Name, C.Last_Name
),

With_Perc AS (
    SELECT *,
        CAST(CAST(Total_Quantity AS FLOAT) / SUM(Total_Quantity) OVER () * 100 AS DECIMAL(5,2)) AS Order_Perc,
        PERCENT_RANK() OVER (ORDER BY Total_Quantity DESC) AS Percentile_Rank
    FROM Customer_Order_Total
)

SELECT *,
    RANK() OVER (ORDER BY Order_Perc DESC) AS Customer_Perc,
    CASE    
        WHEN Percentile_Rank <= 0.1 THEN 'Top 10%'
        WHEN Percentile_Rank <= 0.3 THEN 'Top 30%'
        WHEN Percentile_Rank <= 0.6 THEN 'Top 60%'
        ELSE 'Bottom 40%'
    END AS Rank_Category
FROM With_Perc
ORDER BY Order_Perc DESC;



/*---------------------------------------------------------------------------------------
    21.Find the top 5 customers based on total quantity of orders placed across all years. 
       Display customer names and their total order quantity.
------------------------------------------------------------------------------------------*/