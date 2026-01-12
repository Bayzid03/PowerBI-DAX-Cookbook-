-- =============================================
-- DAX FILTER FUNCTIONS COOKBOOK
-- Sample Data: Sales, Products, Customers, Calendar
-- =============================================

-- 1. ALL
-- Returns all the rows in a table, or all the values in a column, ignoring any filters that might have been applied
-- Useful for clearing filters and creating calculations on all the rows in a table
Total Sales All Regions = 
CALCULATE(
    SUM(Sales[TotalAmount]),
    ALL(Sales[Region])
)

Percent of Total Sales = 
DIVIDE(
    SUM(Sales[TotalAmount]),
    CALCULATE(SUM(Sales[TotalAmount]), ALL(Sales))
)

All Products Revenue = 
CALCULATE(
    SUM(Sales[TotalAmount]),
    ALL(Products)
)

Total Customers Ignoring Filters = 
CALCULATE(
    DISTINCTCOUNT(Sales[CustomerID]),
    ALL(Sales[CustomerID])
)


-- 2. ALLCROSSFILTERED
-- Clear all filters which are applied to a table
Grand Total Sales = 
CALCULATE(
    SUM(Sales[TotalAmount]),
    ALLCROSSFILTERED(Sales)
)

Total Orders Unfiltered = 
CALCULATE(
    COUNTROWS(Sales),
    ALLCROSSFILTERED(Sales)
)


-- 3. ALLEXCEPT
-- Removes all context filters in the table except filters that have been applied to the specified columns
Sales by Region Only = 
CALCULATE(
    SUM(Sales[TotalAmount]),
    ALLEXCEPT(Sales, Sales[Region])
)

Orders by Customer Only = 
CALCULATE(
    COUNTROWS(Sales),
    ALLEXCEPT(Sales, Sales[CustomerID])
)

Revenue by Category Only = 
CALCULATE(
    SUM(Sales[TotalAmount]),
    ALLEXCEPT(Products, Products[Category])
)


-- 4. ALLSELECTED
-- Returns all rows in a table, or all values in columns, ignoring filters applied inside the query, but keeping filters from outside
Percent of Selected Total = 
DIVIDE(
    SUM(Sales[TotalAmount]),
    CALCULATE(SUM(Sales[TotalAmount]), ALLSELECTED(Sales))
)

Selected Regions Revenue = 
CALCULATE(
    SUM(Sales[TotalAmount]),
    ALLSELECTED(Sales[Region])
)

Selected Customer Count = 
CALCULATE(
    DISTINCTCOUNT(Sales[CustomerID]),
    ALLSELECTED(Sales[CustomerID])
)


-- 5. CALCULATE
-- Evaluates an expression in a modified filter context
Electronics Sales = 
CALCULATE(
    SUM(Sales[TotalAmount]),
    Products[Category] = "Electronics"
)

Corporate Segment Revenue = 
CALCULATE(
    SUM(Sales[TotalAmount]),
    Customers[Segment] = "Corporate"
)

North Region Orders = 
CALCULATE(
    COUNTROWS(Sales),
    Sales[Region] = "North"
)

High Value Orders = 
CALCULATE(
    COUNTROWS(Sales),
    Sales[TotalAmount] > 500
)

Q1 Sales = 
CALCULATE(
    SUM(Sales[TotalAmount]),
    Calendar[Quarter] = "Q1"
)

Electronics in North Region = 
CALCULATE(
    SUM(Sales[TotalAmount]),
    Products[Category] = "Electronics",
    Sales[Region] = "North"
)


-- 6. CALCULATETABLE
-- Evaluates a table expression in a modified filter context
Electronics Orders Table = 
CALCULATETABLE(
    Sales,
    Products[Category] = "Electronics"
)

Corporate Customers Sales = 
CALCULATETABLE(
    Sales,
    Customers[Segment] = "Corporate"
)

High Value Transactions = 
CALCULATETABLE(
    Sales,
    Sales[TotalAmount] > 500
)

Q2 Sales Table = 
CALCULATETABLE(
    Sales,
    Calendar[Quarter] = "Q2"
)

Count Electronics Orders = 
COUNTROWS(
    CALCULATETABLE(
        Sales,
        Products[Category] = "Electronics"
    )
)


-- 7. EARLIER
-- Returns the current value of the specified column in an outer evaluation pass of the mentioned column
-- Calculated Column: Rank by Customer Total Sales
Customer Sales Rank = 
RANKX(
    FILTER(
        ALL(Customers),
        CALCULATE(SUM(Sales[TotalAmount])) >= 
        CALCULATE(SUM(Sales[TotalAmount]), ALL(Sales))
    ),
    CALCULATE(SUM(Sales[TotalAmount]))
)

-- Calculated Column: Orders Above Customer Average
Above Customer Avg = 
VAR CurrentCustomer = Sales[CustomerID]
VAR CustomerAvg = 
    CALCULATE(
        AVERAGE(Sales[TotalAmount]),
        FILTER(ALL(Sales), Sales[CustomerID] = CurrentCustomer)
    )
RETURN
    IF(Sales[TotalAmount] > CustomerAvg, "Yes", "No")


-- 8. EARLIER (duplicate entry - same as #7)
-- Returns the current value of the specified column in an outer evaluation pass of the mentioned column
-- Calculated Column: Product Price Comparison
Price vs Product Avg = 
VAR CurrentProduct = Sales[ProductID]
VAR ProductAvg = 
    CALCULATE(
        AVERAGE(Sales[UnitPrice]),
        FILTER(ALL(Sales), Sales[ProductID] = CurrentProduct)
    )
RETURN
    Sales[UnitPrice] - ProductAvg


-- 9. EARLIEST
-- Returns the current value of the specified column in an outer evaluation pass of the specified column
-- Calculated Column: Running Total by Customer
Running Total by Customer = 
CALCULATE(
    SUM(Sales[TotalAmount]),
    FILTER(
        ALL(Sales),
        Sales[CustomerID] = EARLIEST(Sales[CustomerID]) &&
        Sales[Date] <= EARLIEST(Sales[Date])
    )
)


-- 10. FILTER
-- Returns a table that represents a subset of another table or expression
High Value Sales = 
CALCULATE(
    SUM(Sales[TotalAmount]),
    FILTER(Sales, Sales[TotalAmount] > 500)
)

Electronics Revenue = 
CALCULATE(
    SUM(Sales[TotalAmount]),
    FILTER(Products, Products[Category] = "Electronics")
)

Corporate Customers Count = 
COUNTROWS(
    FILTER(Customers, Customers[Segment] = "Corporate")
)

Multiple Quantity Orders = 
CALCULATE(
    COUNTROWS(Sales),
    FILTER(Sales, Sales[Quantity] > 1)
)

January Sales = 
CALCULATE(
    SUM(Sales[TotalAmount]),
    FILTER(Calendar, Calendar[Month] = 1)
)

North Region Electronics = 
CALCULATE(
    SUM(Sales[TotalAmount]),
    FILTER(
        Sales,
        Sales[Region] = "North" && 
        RELATED(Products[Category]) = "Electronics"
    )
)

Expensive Products Sold = 
CALCULATE(
    SUM(Sales[TotalAmount]),
    FILTER(
        Sales,
        RELATED(Products[Cost]) > 500
    )
)


-- =============================================
-- ADVANCED FILTER COMBINATIONS
-- =============================================

-- Using ALL with CALCULATE
Sales % of Grand Total = 
DIVIDE(
    SUM(Sales[TotalAmount]),
    CALCULATE(SUM(Sales[TotalAmount]), ALL(Sales)),
    0
)

-- Using FILTER with CALCULATETABLE
Top 5 Customers Table = 
TOPN(
    5,
    CALCULATETABLE(
        SUMMARIZE(
            Sales,
            Customers[CustomerName],
            "Total Sales", SUM(Sales[TotalAmount])
        )
    ),
    [Total Sales],
    DESC
)

-- Nested FILTER expressions
High Value Electronics = 
CALCULATE(
    SUM(Sales[TotalAmount]),
    FILTER(
        FILTER(
            Sales,
            RELATED(Products[Category]) = "Electronics"
        ),
        Sales[TotalAmount] > 500
    )
)


-- =============================================
-- END OF FILTER FUNCTIONS
-- =============================================
