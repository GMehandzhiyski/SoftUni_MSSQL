--Lecture exercise
--01.
USE [SoftUni]

SELECT TOP 50
	e.[FirstName], e.[LastName], t.[Name] AS [Town], a.[AddressText]
FROM [Employees] AS e
	JOIN [Addresses] AS a ON e.[AddressID] = a.[AddressID]
	JOIN [Towns] AS t ON a.[TownID] = t.[TownID]
ORDER BY
	e.[FirstName], e.[LastName]


--02.
SELECT 
	e.[FirstName], e.[LastName],e.[HireDate], d.[Name] AS [DeptName]
FROM
	[Employees] AS e
	JOIN [Departments] AS d ON e.[DepartmentID] = d.[DepartmentID]
WHERE 
	e.[HireDate] > '1999-1-1'
	AND d.[Name] IN('Sales', 'Finance')
ORDER BY
	e.[HireDate]

--Exercise
--01.
SELECT TOP 5
	e.[EmployeeID],e.[JobTitle], a.[AddressID], a.[AddressText] 
FROM 
	[Employees] AS e
	JOIN [Addresses] AS a ON e.AddressID = a.[AddressID]
ORDER BY a.[AddressID]

--02. 
SELECT TOP 50
	e.[FirstName], e.[LastName], t.[Name] AS [Town], a.[AddressText]
FROM
	[Employees] AS e
	JOIN [Addresses] AS a ON e.AddressID = a.AddressID
	JOIN [Towns] AS t ON t.TownID = a.TownID
ORDER BY [FirstName], [LastName]

--03.
SELECT 
	e.[EmployeeID], e.[FirstName], e.[LastName], d.[Name] AS [DepartmentName]
FROM
	[Employees] AS e
	JOIN [Departments] AS d ON e.DepartmentID = d.DepartmentID
WHERE d.[Name] = 'Sales'
ORDER BY e.EmployeeID