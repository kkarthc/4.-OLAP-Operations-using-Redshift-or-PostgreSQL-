-- Create the "sales_sample" table
CREATE TABLE sales_sample (
    Product_Id INTEGER,
    Region VARCHAR(50),
    Sales_Date DATE,
    Sales_Amount NUMERIC
);
select * from sales_sample;
--insert sample 10 data----
INSERT INTO sales_sample (Product_Id, Region, Sales_Date, Sales_Amount) VALUES
(101, 'East', '2024-01-15', 500),
(102, 'West', '2024-01-15', 600),
(103, 'North', '2024-02-01', 700),
(104, 'South', '2024-02-01', 800),
(101, 'East', '2024-03-10', 300),
(102, 'West', '2024-03-15', 400),
(103, 'North', '2024-04-20', 900),
(104, 'South', '2024-04-20', 1000),
(105, 'East', '2024-05-05', 1200),
(106, 'West', '2024-05-15', 1500);
select * from sales_sample;

-- Drill down: Analyze sales data at a more detailed level (from region to product).
SELECT 
    Region, -- The region where the sales occurred.
    Product_Id, -- The specific product sold in the region.
    SUM(Sales_Amount) AS Total_Sales -- Total sales amount for the region-product combination.
FROM 
    sales_sample
GROUP BY 
    Region, Product_Id -- Grouping by region and product to break down sales data.
ORDER BY 
    Region, Product_Id; -- Sorting results by region and product for better readability.

-- Roll up: Summarize sales data at different levels of granularity (product to region).
SELECT 
    Region, -- The region where sales occurred.
    COALESCE(CAST(Product_Id AS TEXT), 'All Products') AS Product_Id, -- Convert Product_Id to text for string substitution.
    SUM(Sales_Amount) AS Total_Sales -- Total sales amount for the region or overall.
FROM 
    sales_sample
GROUP BY 
    ROLLUP (Region, Product_Id) -- Use ROLLUP to create subtotals at region and product levels.
ORDER BY 
    Region, Product_Id; -- Sort by region and product for hierarchical viewing.
-- Cube: Analyze sales data across multiple dimensions (product, region, and date).
SELECT 
    COALESCE(CAST(Product_Id AS TEXT), 'All Products') AS Product_Id, -- Convert Product_Id to text for substitution.
    COALESCE(Region, 'All Regions') AS Region, -- Replace NULL in Region with 'All Regions'.
    COALESCE(Sales_Date::TEXT, 'All Dates') AS Sales_Date, -- Replace NULL in Sales_Date with 'All Dates'.
    SUM(Sales_Amount) AS Total_Sales -- Calculate total sales for each combination.
FROM 
    sales_sample
GROUP BY 
    CUBE (Product_Id, Region, Sales_Date) -- Use CUBE to generate combinations of dimensions.
ORDER BY 
    Product_Id, Region, Sales_Date; -- Sort results by product, region, and date for readability.
-- Slice: Extract a subset of data based on specific criteria.

-- Example 1: View sales for the 'East' region.
SELECT 
    * -- Select all columns from the table.
FROM 
    sales_sample
WHERE 
    Region = 'East'; -- Filter for records where the region is 'East'.

-- Example 2: View sales data for a specific date range.
SELECT 
    * -- Select all columns from the table.
FROM 
    sales_sample
WHERE 
    Sales_Date BETWEEN '2024-03-01' AND '2024-04-30'; -- Filter for dates within the range.
-- Dice: Extract data based on multiple criteria.

-- View sales for specific combinations of product, region, and date range.
SELECT 
    * -- Select all columns from the table.
FROM 
    sales_sample
WHERE 
    Product_Id IN (101, 102) -- Include only products with IDs 101 and 102.
    AND Region IN ('East', 'West') -- Include only sales from 'East' or 'West' regions.
    AND Sales_Date BETWEEN '2024-01-01' AND '2024-03-31'; -- Filter for sales within the date range.

