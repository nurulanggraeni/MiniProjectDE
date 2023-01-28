--Query for Production Analysis & Shipment Analysis
SELECT p.ProductName, SUM(od.UnitPrice*od.Quantity) AS salesorder, MONTH(o.OrderDate) AS Month, YEAR(o.OrderDate) AS YEAR, od.Discount, cg.CategoryName, o.ShipCountry, o.ShipCity, c.CompanyName
FROM Products p
JOIN [Order Details] od
ON p.ProductID = od.ProductID
JOIN Orders o
ON od.OrderID = o.OrderID
JOIN Categories cg
ON p.CategoryID = cg.CategoryID
JOIN Customers c
ON o.CustomerID = c.CustomerID
GROUP BY p.ProductName, MONTH(o.OrderDate), YEAR(o.OrderDate), od.Discount, cg.CategoryName, o.ShipCountry, o.ShipCity, c.CompanyName
ORDER BY Month DESC;

-- Query for employee analysis
SELECT SUM(od.UnitPrice*od.Quantity) AS salesorder, MONTH(o.OrderDate) AS Month, YEAR(o.OrderDate) AS YEAR, e.FirstName, e.LastName, e.Title, p.ProductName, cg.CategoryName
FROM [Order Details] od
JOIN Orders o
ON od.OrderID = o.OrderID
JOIN Employees e
ON e.EmployeeID = o.EmployeeID
JOIN Products p
ON p.ProductID = od.ProductID
JOIN Categories cg
ON p.CategoryID = CG.CategoryID
GROUP BY od.UnitPrice*od.Quantity, MONTH(o.OrderDate), YEAR(o.OrderDate), e.FirstName, e.LastName, e.Title, p.ProductName, cg.CategoryName
ORDER BY Month DESC;

SELECT SUM(od.UnitPrice*od.Quantity) AS salesorder, MONTH(o.OrderDate) AS Month, YEAR(o.OrderDate) AS YEAR, e.FirstName, e.LastName, e.Title, p.ProductName, cg.CategoryName
FROM [Order Details] od
JOIN Orders o
ON od.OrderID = o.OrderID
JOIN Employees e
ON e.EmployeeID = o.EmployeeID
JOIN Products p
ON p.ProductID = od.ProductID
JOIN Categories cg
ON p.CategoryID = CG.CategoryID
WHERE YEAR(o.OrderDate) = 1997
GROUP BY od.UnitPrice*od.Quantity, MONTH(o.OrderDate), YEAR(o.OrderDate), e.FirstName, e.LastName, e.Title, p.ProductName, cg.CategoryName
HAVING SUM(od.UnitPrice*od.Quantity) > 100
ORDER BY Month DESC;


