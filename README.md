# Regional Sales EDA (2014–2018)

## Project Summary
Regional Sales EDA (2014–2018) is a data analytics project focused on understanding Acme Co.'s historical sales performance across U.S. regions, customers, products, and sales channels. The analysis involves combining multiple Excel sheets containing sales orders, customer information, product details, and budgets into a unified dataset using SQL-style joins in Pandas.

---

## Objectives

- Merge customer, product, region, and sales data into a single view
- Clean and standardize the dataset (header fixes, null handling, type conversion)
- Derive key business metrics like Revenue, Profit, Total Cost, and Profit Margin
- Identify high/low performing products, regions, and sales channels
- Discover monthly trends, seasonality, and outliers
- Prepare the dataset for dashboard reporting (Power BI-ready)

---

## Tools Used

- Languages: Python (Pandas, NumPy)
- Data Manipulation: SQL-style logic in Pandas
- Visualization: Matplotlib, Seaborn
- Environment: Vs
- Source Data: Excel Sheets (Sales Orders, Customers, Products, Regions, State Regions, 2017 Budgets)

---

## Techniques Used

-  SQL-style JOINs with pd.merge() (similar to LEFT JOIN)
-  Conditional filtering (like SQL WHERE)
-  Aggregation using groupby() (like SQL GROUP BY)
-  Calculated columns (Revenue, Cost, Profit, Margin %)
-  Time-based grouping using datetime and Period objects
-  Exporting final results to CSV for further use

---

##  Data Processing Steps

- Loaded all sheets from Excel workbook using sheet_name=None
- Cleaned inconsistent headers (especially in State Regions)
- Merged datasets on customer, product, region, and state codes
- Filtered out records (e.g., Jan & Feb 2018) for trend accuracy
- Renamed columns to standardized format
- Created new fields:  
  - total_cost = order_quantity * unit_cost  
  - profit = revenue - total_cost  
  - profit_margin % = profit / revenue * 100

---

##  Exploratory Visualizations

###  Monthly & Seasonal Trends
- Line chart showing monthly revenue from 2014 to 2018
- Seasonality trend using monthly grouping (excluding Jan & Feb 2018)

### Product-Level Analysis
- Bar chart of Top 10 products by total revenue
- Bar chart of Bottom 10 products by total revenue

### Channel Performance
- Pie chart showing share of sales by channel (Wholesale, Online, etc.)

### Order Value Distribution
- Histogram showing distribution of average order value (AOV)

---

## Key Business Insights

- Certain products and regions significantly outperform others
- Seasonal spikes in sales (e.g., late Q3 and Q4)
- Online and wholesale dominate overall revenue
- Some orders show extremely high revenue → potential B2B deals
- Clean dataset exported as Resive.csv for use in BI dashboards
