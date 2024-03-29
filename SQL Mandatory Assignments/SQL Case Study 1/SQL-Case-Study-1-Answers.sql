
/**1. Display the number of states present in the LocationTable.**/
SELECT COUNT(DISTINCT State) AS NumberOfStates
FROM Location;

/**2. How many products are of regular type?**/
SELECT COUNT(*) AS RegularProducts
FROM Product
WHERE Type = 'regular';

/**3. How much spending has been done on marketing of product ID 1?**/
SELECT SUM(Marketing) AS MarketingSpend
FROM fact
WHERE ProductId = 1;

/**4. What is the minimum sales of a product?**/
SELECT MIN(Sales) AS MinimumSales FROM fact;

/**5. Display the max Cost of Good Sold (COGS).**/
SELECT MAX(COGS) AS MaxCOGS FROM fact;

/**6. Display the details of the product where product type is coffee.**/
SELECT * FROM Product WHERE Product_Type = 'coffee';

/**7. Display the details where total expenses are greater than 40.**/
SELECT * FROM fact WHERE Total_Expenses > 40;

/**8. What is the average sales in area code 719?**/
SELECT AVG(Sales) AS AvgSales FROM fact WHERE Area_Code = 719;


/**9. Find out the total profit generated by Colorado state.**/
SELECT SUM(Profit) AS TotalProfit
FROM fact
INNER JOIN Location ON fact.Area_Code = Location.Area_Code
WHERE Location.State = 'Colorado';


/**10. Display the average inventory for each product ID. **/
SELECT ProductId, AVG(Inventory) AS AvgInventory
FROM fact
GROUP BY ProductId;

/**11. Display state in a sequential order in a Location Table.**/
SELECT * FROM Location ORDER BY State ASC;

/**12. Display the average budget of the Product where the average budget
margin should be greater than 100.**/
SELECT ProductId,AVG(Budget_Margin) as Avg_Budget_Margin
FROM fact
Group by ProductId
Having AVG(Budget_Margin) > 100;


/**13. What is the total sales done on date 2010-01-01?**/
SELECT SUM(Sales) AS TotalSales
FROM fact
WHERE Date = '2010-01-01';

/**14. Display the average total expense of each product ID on an individual date.**/
SELECT ProductId, Date, AVG(Total_Expenses) AS AvgTotalExpense
FROM fact
GROUP BY ProductId, Date Order by Date,ProductId;

/**15. Display the table with the following attributes such as date, productID, product_type,
product, sales, profit, state, area_code.**/
SELECT  Date,F.ProductId,P.Product_Type,P.Product, Sales, Profit,L.State, F.Area_Code
FROM fact F
Left Join Product P ON F.ProductId=P.ProductId
Left Join Location L ON F.Area_Code=L.Area_Code;


/**16. Display the rank without any gap to show the sales wise rank.**/
SELECT *,
       DENSE_RANK() OVER (ORDER BY Sales DESC) AS SalesRank
FROM fact;

/**17. Find the state wise profit and sales. **/
SELECT L.State, SUM(Profit) AS TotalProfit, SUM(Sales) AS TotalSales
FROM fact F
INNER JOIN Location L ON F.Area_Code = L.Area_Code
GROUP BY L.State;

/**18. Find the state wise profit and sales along with the productname.**/
SELECT Location.State, SUM(Profit) AS TotalProfit, SUM(Sales) AS TotalSales, p.Product
FROM fact AS f
INNER JOIN Location ON f.Area_Code = Location.Area_Code
INNER JOIN Product AS p ON f.ProductId = p.ProductId
GROUP BY Location.State, p.Product;

/**19. If there is an increase in sales of 5%, calculate the increasedsales. **/

/**20. Find the maximum profit along with the product ID and producttype.**/
SELECT P.ProductId, Product_Type, MAX(Profit) AS MaxProfit
FROM fact F
INNER JOIN Product P ON F.ProductId = P.ProductId
GROUP BY P.ProductId, Product_Type;

--If we removed ProductId will have good picture
SELECT Product_Type, MAX(Profit) AS MaxProfit
FROM fact F
INNER JOIN Product P ON F.ProductId = P.ProductId
GROUP BY  Product_Type;


/**21. Create a stored procedure to fetch the result according to the product type
from Product Table. **/
CREATE PROCEDURE usp_GetProductsByType (@productType nvarchar(50))
AS
BEGIN
  SELECT *
  FROM Product
  WHERE Product_Type = @productType;
END;
-- Test stored procedure by fetching the result 
Exec usp_GetProductsByType 'Coffee';

/**22. Write a query by creating a condition in which if the total expenses is less than
60 then it is a profit or else loss.**/
SELECT *,
CASE WHEN Total_Expenses < 60 THEN 'Profit'
     ELSE 'Loss'
END AS Profit_and_Loss
FROM fact;

/**23. Give the total weekly sales value with the date and product ID details. Use
roll-up to pull the data in hierarchical order.**/
SELECT Date, ProductId, SUM(Sales) AS TotalSales,
       DATEPART(year, Date) * 100 + DATEPART(iso_week, Date) AS WeekNumber
FROM fact
GROUP BY Date,ROLLUP(DATEPART(year, Date) * 100 + DATEPART(iso_week, Date) , ProductId)
ORDER BY DATEPART(year, Date) * 100 + DATEPART(iso_week, Date)  ASC, ProductId ASC;


/**24. Apply union and intersection operator on the tables which consist of
attribute area code.**/
--Union
SELECT Area_Code
FROM Product
UNION
SELECT Area_Code
FROM Location;

--INTERSECT
SELECT Area_Code
FROM Product
INTERSECT
SELECT Area_Code
FROM Location;

/**25. Create a user-defined function for the product table to fetch a particular
product type based upon the user�s preference.**/
CREATE FUNCTION udf_GetProductsByType (@desiredType nvarchar(50))
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM Product
    WHERE Product_Type = @desiredType
);
-- Test stored procedure by fetching the result 
SELECT * FROM udf_GetProductsByType('electronics'); -- Get all electronics products


/**26. Change the product type from coffee to tea where product ID is 1 and undo it.**/
UPDATE Product
SET Product_Type = 'Tea'
WHERE ProductId = 1;
--Undo the change and set the product type back to coffee:
UPDATE Product
SET Product_Type = 'Coffee'
WHERE ProductId = 1;


/**27. Display the date, product ID and sales where total expenses are
between 100 to 200. **/
SELECT Date, ProductId, Sales
FROM fact
WHERE Total_Expenses BETWEEN 100 AND 200;

/**28. Delete the records in the Product Table for regular type. **/
DELETE FROM Product
WHERE Type = 'Regular';

/**29. Display the ASCII value of the fifth character from the columnProduct**/
SELECT Product, ASCII(SUBSTRING(Product, 5, 1)) AS ASCIIValue
FROM Product;
