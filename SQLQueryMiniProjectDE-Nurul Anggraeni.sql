--1. Tulis query untuk mendapatkan jumlah customer tiap bulan yang melakukan order pada tahun 1997
SELECT MONTH(OrderDate) as month, COUNT(CustomerID) as monthly_customers
FROM Orders
WHERE YEAR(OrderDate) = 1997
GROUP BY MONTH(OrderDate)
Order by Month;

--2. Tulis query untuk mendapatkan nama employee yang termasuk Sales Representative
SELECT FirstName,LastName FROM Employees
WHERE Title = 'Sales Representative';

--3. Tulis query untuk mendapatkan top 5 nama produk yang quantitynya paling banyak diorder pada bulan Januari 1997
SELECT TOP 5 p.ProductName, SUM(od.Quantity) AS TotalQuantity, o.OrderDate
FROM Products p
INNER JOIN [Order Details] od
ON p.ProductID = od.ProductID
INNER JOIN Orders o
ON od.OrderID = o.OrderID
WHERE MONTH(o.OrderDate) = 1
AND YEAR(o.OrderDate) = 1997
GROUP BY p.ProductName, o.OrderDate
ORDER BY TotalQuantity DESC;

--4. Tulis query untuk mendapatkan nama company yang melakukan order Chai pada bulan Juni 1997
SELECT c.CompanyName
FROM Customers c
INNER JOIN Orders o
ON o.CustomerID = c.CustomerID
INNER JOIN [Order Details] od
ON od.OrderID = o.OrderID
INNER JOIN Products p
ON p.ProductID = od.ProductID
WHERE p.ProductName = 'Chai'
AND MONTH(o.OrderDate) = 6
AND YEAR(o.OrderDate) = 1997;

--5. Tulis query untuk mendapatkan jumlah OrderID yang pernah melakukan pembelian (unit_price dikali quantity) <=100, 100<x<=250, 250<x<=500, dan >500
ALTER TABLE [Order Details] ADD AmountRange VARCHAR(300);
UPDATE [Order Details]
SET AmountRange = 
    CASE
        WHEN UnitPrice * Quantity <= 100 THEN '<=100'
        WHEN UnitPrice * Quantity > 100 AND UnitPrice * Quantity <= 250 THEN '100<x<=250'
        WHEN UnitPrice * Quantity > 250 AND UnitPrice * Quantity <= 500 THEN '250<x<=500'
        WHEN UnitPrice * Quantity > 500 THEN '>500'
    END

SELECT 
	COUNT(DISTINCT OrderID) AS OrderCount, AmountRange
FROM [Order Details]
GROUP BY AmountRange

--6. Tulis query untuk mendapatkan Company name pada tabel customer yang melakukan pembelian di atas 500 pada tahun 1997

SELECT c.CompanyName, SUM(od.UnitPrice * od.Quantity) AS totalorder
FROM Customers c
INNER JOIN Orders o
ON c.CustomerID = o.CustomerID
INNER JOIN [Order Details] od
ON od.OrderID = o.OrderID
WHERE od.UnitPrice * od.Quantity > 500
AND YEAR(o.OrderDate) = 1997
GROUP BY c.CompanyName
ORDER BY c.CompanyName;

--7. Tulis query untuk mendapatkan nama produk yang merupakan Top 5 sales tertinggi tiap bulan di tahun 1997

WITH cte AS (
	SELECT DATEPART(MONTH, o.OrderDate) AS [Month],
	p.ProductName,
	SUM(od.Quantity*od.UnitPrice) AS [TotalSales],
	ROW_NUMBER() OVER (PARTITION BY DATEPART(MONTH, o.OrderDate) 
	ORDER BY SUM(od.Quantity*od.UnitPrice) DESC) as row
	FROM Orders o
	JOIN [Order Details] od ON o.OrderID = od.OrderID
	JOIN Products p ON p.ProductID = od.ProductID
	GROUP BY DATEPART(MONTH, o.OrderDate), ProductName
)
SELECT DISTINCT Month, ProductName, [TotalSales]
FROM cte
WHERE row <= 5
ORDER BY Month, [TotalSales] DESC

--8. Buatlah view untuk melihat Order Details yang berisi OrderID, ProductID, ProductName, UnitPrice, Quantity, Discount, Harga setelah diskon.

CREATE VIEW OrderDetailsView1 AS
SELECT od.OrderID, od.ProductID, p.ProductName, od.UnitPrice, od.Quantity, od.Discount, (od.UnitPrice) - (od.UnitPrice*od.Discount) AS 'HargaSetelahDiskon'
FROM [Order Details] od
JOIN Products p
ON od.ProductID = p.ProductID

SELECT * FROM OrderDetailsView1

--9. Buatlah procedure Invoice untuk memanggil CustomerID, CustomerName/company name, OrderID, OrderDate, RequiredDate, ShippedDate jika terdapat inputan CustomerID tertentu

CREATE PROCEDURE GenerateInvoice8 (@CustomerID VARCHAR(5))
AS
BEGIN
	SELECT
		c.CustomerID,
		c.CompanyName AS 'CustomerName',
		o.OrderID,
		o.OrderDate,
		o.RequiredDate,
		o.ShippedDate
	FROM Orders o
	JOIN Customers c
	ON o.CustomerID = c.CustomerID
	WHERE c.CustomerID = @CustomerID
END

To input CustomerID (example):

EXEC GenerateInvoice8 VICTE
