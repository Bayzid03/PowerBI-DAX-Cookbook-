-- =============================================
-- DAX AGGREGATION FUNCTIONS COOKBOOK
-- Sample Data: Sales, Products, Customers, Calendar
-- =============================================

-- 1. APPROXIMATEDISTINCTCOUNT
-- Returns an estimated count of unique values in a column
Approx Unique Customers = 
APPROXIMATEDISTINCTCOUNT(Sales[CustomerID])

Approx Unique Products Sold = 
APPROXIMATEDISTINCTCOUNT(Sales[ProductID])


-- 2. AVERAGE
-- Returns the average (arithmetic mean) of all the numbers in a column
Average Order Amount = 
AVERAGE(Sales[TotalAmount])

Average Unit Price = 
AVERAGE(Sales[UnitPrice])

Average Product Cost = 
AVERAGE(Products[Cost])


-- 3. AVERAGEA
-- Returns the average (arithmetic mean) of the values in a column. Handles text and non-numeric values
Average Quantity with Text Handling = 
AVERAGEA(Sales[Quantity])


-- 4. AVERAGEX
-- Calculates the average (arithmetic mean) of a set of expressions evaluated over a table
Average Profit Per Order = 
AVERAGEX(
    Sales,
    Sales[TotalAmount] - RELATED(Products[Cost]) * Sales[Quantity]
)

Average Revenue Per Customer = 
AVERAGEX(
    Customers,
    CALCULATE(SUM(Sales[TotalAmount]))
)

Average Daily Sales = 
AVERAGEX(
    Calendar,
    CALCULATE(SUM(Sales[TotalAmount]))
)


-- 5. COUNT
-- Counts the number of rows in the specified column that contain non-blank values
Count of Orders = 
COUNT(Sales[OrderID])

Count of Product Names = 
COUNT(Products[ProductName])


-- 6. COUNTA
-- Counts the number of rows in the specified column that contain non-blank values
Count of Customer Names = 
COUNTA(Customers[CustomerName])

Count of Regions = 
COUNTA(Sales[Region])


-- 7. COUNTAX
-- Counts non-blank results when evaluating the result of an expression over a table
Count Orders Above Average = 
COUNTAX(
    Sales,
    IF(Sales[TotalAmount] > AVERAGE(Sales[TotalAmount]), 1, BLANK())
)

Count Profitable Products = 
COUNTAX(
    Products,
    IF(Products[Cost] < 500, 1, BLANK())
)


-- 8. COUNTBLANK
-- Counts the number of blank cells in a column
Blank Regions = 
COUNTBLANK(Sales[Region])

Blank Product Categories = 
COUNTBLANK(Products[Category])


-- 9. COUNTROWS
-- Counts the number of rows in the specified table, or in a table defined by an expression
Total Orders = 
COUNTROWS(Sales)

Total Customers = 
COUNTROWS(Customers)

Total Products = 
COUNTROWS(Products)

Electronics Orders = 
COUNTROWS(
    FILTER(
        Sales,
        RELATED(Products[Category]) = "Electronics"
    )
)


-- 10. COUNTX
-- Counts the number of rows that contain a non-blank value when evaluating an expression over a table
Count High Value Orders = 
COUNTX(
    Sales,
    IF(Sales[TotalAmount] > 500, 1, BLANK())
)

Count Corporate Segment Sales = 
COUNTX(
    Sales,
    IF(RELATED(Customers[Segment]) = "Corporate", 1, BLANK())
)


-- 11. DISTINCTCOUNT
-- Counts the number of distinct values in a column
Unique Customers = 
DISTINCTCOUNT(Sales[CustomerID])

Unique Products Sold = 
DISTINCTCOUNT(Sales[ProductID])

Unique Regions = 
DISTINCTCOUNT(Sales[Region])

Unique Order Dates = 
DISTINCTCOUNT(Sales[Date])


-- 12. DISTINCTCOUNTNOBLANK
-- Counts the number of distinct values in a column
Distinct Customer Count = 
DISTINCTCOUNTNOBLANK(Sales[CustomerID])

Distinct Product Categories = 
DISTINCTCOUNTNOBLANK(Products[Category])


-- 13. MAX
-- Returns the largest value in a column, or between two scalar expressions
Highest Order Amount = 
MAX(Sales[TotalAmount])

Highest Product Cost = 
MAX(Products[Cost])

Max Unit Price = 
MAX(Sales[UnitPrice])

Max of Two Values = 
MAX(100, 250)


-- 14. MAXA
-- Returns the largest value in a column
Max Quantity Ordered = 
MAXA(Sales[Quantity])


-- 15. MIN
-- Returns the smallest value in a column, or between two scalar expressions
Lowest Order Amount = 
MIN(Sales[TotalAmount])

Lowest Product Cost = 
MIN(Products[Cost])

Min Unit Price = 
MIN(Sales[UnitPrice])

Min of Two Values = 
MIN(50, 25)


-- 16. MINA
-- Returns the smallest value in a column
Min Quantity Ordered = 
MINA(Sales[Quantity])


-- 17. PRODUCT
-- Returns the product of the numbers in a column
Product of Quantities = 
PRODUCT(Sales[Quantity])


-- 18. PRODUCTX
-- Returns the product of an expression evaluated for each row in a table
Product of Order Values = 
PRODUCTX(
    Sales,
    Sales[Quantity] * Sales[UnitPrice]
)

Product of Profit Margins = 
PRODUCTX(
    FILTER(Sales, Sales[Quantity] <= 3),
    (Sales[UnitPrice] - RELATED(Products[Cost])) / Sales[UnitPrice]
)


-- 19. SUM
-- Adds all the numbers in a column
Total Sales Revenue = 
SUM(Sales[TotalAmount])

Total Quantity Sold = 
SUM(Sales[Quantity])

Sum of Product Costs = 
SUM(Products[Cost])


-- 20. SUMX
-- Returns the sum of an expression evaluated for each row in a table
Total Profit = 
SUMX(
    Sales,
    Sales[TotalAmount] - (RELATED(Products[Cost]) * Sales[Quantity])
)

Total Revenue by Category = 
SUMX(
    Products,
    CALCULATE(SUM(Sales[TotalAmount]))
)

Total Cost of Goods Sold = 
SUMX(
    Sales,
    RELATED(Products[Cost]) * Sales[Quantity]
)

Profit Margin = 
SUMX(
    Sales,
    (Sales[UnitPrice] - RELATED(Products[Cost])) * Sales[Quantity]
)


-- =============================================
-- END OF AGGREGATION FUNCTIONS
-- =============================================
